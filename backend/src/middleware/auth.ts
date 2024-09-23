import { Request, Response, NextFunction } from 'express';
import jwt from 'jsonwebtoken';
import { config } from '../config/config';
import { AuthenticationError } from '../utils/errors';
import AuthService from '../services/AuthService';

const authMiddleware = async (req: Request, res: Response, next: NextFunction): Promise<void> => {
  try {
    const authHeader = req.headers.authorization;
    if (!authHeader) {
      throw new AuthenticationError('No token provided');
    }

    const token = authHeader.split(' ')[1]; // Assuming Bearer token
    if (!token) {
      throw new AuthenticationError('Invalid token format');
    }

    try {
      const decoded = jwt.verify(token, config.jwtSecret);
      (req as any).user = decoded; // Add decoded user info to request object
      next();
    } catch (error) {
      throw new AuthenticationError('Invalid token');
    }
  } catch (error) {
    next(error);
  }
};

export default authMiddleware;