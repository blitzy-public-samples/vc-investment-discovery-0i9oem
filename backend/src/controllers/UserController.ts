import { Request, Response, NextFunction } from 'express';
import AuthService from '../services/AuthService';
import User from '../models/User';
import { HttpError } from '../utils/errors';
import { UserCredentials, UserUpdateData } from '../types';

class UserController {
  private readonly authService: AuthService;

  constructor(authService: AuthService) {
    this.authService = authService;
  }

  public register = async (req: Request, res: Response, next: NextFunction): Promise<void> => {
    try {
      const userCredentials: UserCredentials = req.body;
      
      // TODO: Implement input validation for user registration
      
      const { user, tokens } = await this.authService.signUp(userCredentials);
      
      res.status(201).json({ user, tokens });
    } catch (error) {
      next(error);
    }
  }

  public login = async (req: Request, res: Response, next: NextFunction): Promise<void> => {
    try {
      const userCredentials: UserCredentials = req.body;
      
      // TODO: Implement input validation for login
      
      const { user, tokens } = await this.authService.signIn(userCredentials);
      
      res.status(200).json({ user, tokens });
    } catch (error) {
      next(error);
    }
  }

  public refreshToken = async (req: Request, res: Response, next: NextFunction): Promise<void> => {
    try {
      const { refreshToken } = req.body;
      
      const newTokens = await this.authService.refreshToken(refreshToken);
      
      res.status(200).json(newTokens);
    } catch (error) {
      next(error);
    }
  }

  public getProfile = async (req: Request, res: Response, next: NextFunction): Promise<void> => {
    try {
      const userId = req.user.id; // Assuming the user ID is attached to the request by authentication middleware
      
      const user = await User.findById(userId);
      
      if (!user) {
        throw new HttpError(404, 'User not found');
      }
      
      res.status(200).json(user);
    } catch (error) {
      next(error);
    }
  }

  public updateProfile = async (req: Request, res: Response, next: NextFunction): Promise<void> => {
    try {
      const userId = req.user.id; // Assuming the user ID is attached to the request by authentication middleware
      const updateData: UserUpdateData = req.body;
      
      // TODO: Implement input validation for profile updates
      
      const updatedUser = await User.findByIdAndUpdate(userId, updateData, { new: true });
      
      if (!updatedUser) {
        throw new HttpError(404, 'User not found');
      }
      
      res.status(200).json(updatedUser);
    } catch (error) {
      next(error);
    }
  }
}

export default UserController;