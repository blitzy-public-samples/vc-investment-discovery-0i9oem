import bcrypt from 'bcrypt';
import jwt from 'jsonwebtoken';
import { User } from '../models/User';
import { config } from '../config/config';
import { UserCredentials, AuthTokens } from '../types';
import { AuthenticationError, ValidationError } from '../utils/errors';

class AuthService {
  async signUp(credentials: UserCredentials): Promise<AuthTokens> {
    // Validate user credentials
    this.validateCredentials(credentials);

    // Check if user already exists
    const existingUser = await User.findOne({ email: credentials.email });
    if (existingUser) {
      throw new AuthenticationError('User with this email already exists');
    }

    // Create a new User document
    const hashedPassword = await bcrypt.hash(credentials.password, 10);
    const newUser = new User({
      email: credentials.email,
      password: hashedPassword,
      // Add other user properties as needed
    });

    // Save the user to the database
    await newUser.save();

    // Generate authentication tokens
    const tokens = this.generateTokens(newUser.id);

    return tokens;
  }

  async signIn(credentials: UserCredentials): Promise<AuthTokens> {
    // Validate user credentials
    this.validateCredentials(credentials);

    // Find the user in the database
    const user = await User.findOne({ email: credentials.email });
    if (!user) {
      throw new AuthenticationError('Invalid email or password');
    }

    // Compare provided password with stored hash
    const isPasswordValid = await bcrypt.compare(credentials.password, user.password);
    if (!isPasswordValid) {
      throw new AuthenticationError('Invalid email or password');
    }

    // Generate authentication tokens
    const tokens = this.generateTokens(user.id);

    return tokens;
  }

  async refreshToken(refreshToken: string): Promise<AuthTokens> {
    try {
      // Verify the refresh token
      const decoded = jwt.verify(refreshToken, config.refreshTokenSecret) as { userId: string };

      // Find the user associated with the token
      const user = await User.findById(decoded.userId);
      if (!user) {
        throw new AuthenticationError('User not found');
      }

      // Generate new authentication tokens
      const tokens = this.generateTokens(user.id);

      return tokens;
    } catch (error) {
      throw new AuthenticationError('Invalid refresh token');
    }
  }

  async verifyToken(token: string): Promise<any> {
    try {
      // Verify the token using the secret key
      const decoded = jwt.verify(token, config.accessTokenSecret);
      return decoded;
    } catch (error) {
      throw new AuthenticationError('Invalid token');
    }
  }

  private generateTokens(userId: string): AuthTokens {
    // Generate an access token with a short expiry
    const accessToken = jwt.sign({ userId }, config.accessTokenSecret, {
      expiresIn: config.accessTokenExpiry,
    });

    // Generate a refresh token with a longer expiry
    const refreshToken = jwt.sign({ userId }, config.refreshTokenSecret, {
      expiresIn: config.refreshTokenExpiry,
    });

    return { accessToken, refreshToken };
  }

  private validateCredentials(credentials: UserCredentials): void {
    if (!credentials.email || !credentials.password) {
      throw new ValidationError('Email and password are required');
    }
    // Add more validation as needed (e.g., email format, password strength)
  }
}

export default new AuthService();