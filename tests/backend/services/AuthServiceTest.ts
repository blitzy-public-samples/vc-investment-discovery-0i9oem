import { jest } from '@jest/globals';
import { AuthService } from '../../src/services/AuthService';
import { User } from '../../src/models/User';
import { AuthenticationError } from '../../src/utils/errors';
import bcrypt from 'bcrypt';
import jwt from 'jsonwebtoken';

jest.mock('../../src/repositories/UserRepository');

describe('AuthServiceTest', () => {
  let authService: AuthService;
  let mockUserRepository: jest.Mocked<typeof import('../../src/repositories/UserRepository').default>;

  beforeEach(() => {
    jest.clearAllMocks();
    mockUserRepository = require('../../src/repositories/UserRepository').default as jest.Mocked<typeof import('../../src/repositories/UserRepository').default>;
    authService = new AuthService(mockUserRepository);
  });

  describe('testSignUp', () => {
    it('should successfully sign up a new user', async () => {
      const testUser = new User('test@example.com', 'password', 'John', 'Doe');
      mockUserRepository.create.mockResolvedValue(testUser);

      const result = await authService.signUp('test@example.com', 'password', 'John', 'Doe');

      expect(mockUserRepository.create).toHaveBeenCalledWith('test@example.com', expect.any(String), 'John', 'Doe');
      expect(result).toHaveProperty('accessToken');
      expect(result).toHaveProperty('refreshToken');
    });

    it('should throw an error for duplicate email', async () => {
      mockUserRepository.create.mockRejectedValue(new Error('Duplicate email'));

      await expect(authService.signUp('existing@example.com', 'password', 'John', 'Doe'))
        .rejects.toThrow(AuthenticationError);
    });
  });

  describe('testSignIn', () => {
    it('should successfully sign in a user', async () => {
      const testUser = new User('test@example.com', await bcrypt.hash('password', 10), 'John', 'Doe');
      mockUserRepository.findByEmail.mockResolvedValue(testUser);

      const result = await authService.signIn('test@example.com', 'password');

      expect(mockUserRepository.findByEmail).toHaveBeenCalledWith('test@example.com');
      expect(result).toHaveProperty('accessToken');
      expect(result).toHaveProperty('refreshToken');
    });

    it('should throw an error for invalid credentials', async () => {
      mockUserRepository.findByEmail.mockResolvedValue(null);

      await expect(authService.signIn('nonexistent@example.com', 'password'))
        .rejects.toThrow(AuthenticationError);
    });
  });

  describe('testRefreshToken', () => {
    it('should successfully refresh tokens', async () => {
      const testUser = new User('test@example.com', 'password', 'John', 'Doe');
      const decodedToken = { userId: testUser.id };
      jest.spyOn(jwt, 'verify').mockImplementation(() => decodedToken);
      mockUserRepository.findById.mockResolvedValue(testUser);

      const result = await authService.refreshToken('validRefreshToken');

      expect(jwt.verify).toHaveBeenCalledWith('validRefreshToken', expect.any(String));
      expect(mockUserRepository.findById).toHaveBeenCalledWith(testUser.id);
      expect(result).toHaveProperty('accessToken');
      expect(result).toHaveProperty('refreshToken');
    });

    it('should throw an error for invalid refresh token', async () => {
      jest.spyOn(jwt, 'verify').mockImplementation(() => { throw new Error('Invalid token'); });

      await expect(authService.refreshToken('invalidRefreshToken'))
        .rejects.toThrow(AuthenticationError);
    });
  });

  describe('testVerifyToken', () => {
    it('should successfully verify a valid token', async () => {
      const decodedToken = { userId: 'testUserId' };
      jest.spyOn(jwt, 'verify').mockImplementation(() => decodedToken);

      const result = await authService.verifyToken('validToken');

      expect(jwt.verify).toHaveBeenCalledWith('validToken', expect.any(String));
      expect(result).toEqual(decodedToken);
    });

    it('should throw an error for invalid token', async () => {
      jest.spyOn(jwt, 'verify').mockImplementation(() => { throw new Error('Invalid token'); });

      await expect(authService.verifyToken('invalidToken'))
        .rejects.toThrow(AuthenticationError);
    });
  });
});