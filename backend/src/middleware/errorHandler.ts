import { Request, Response, NextFunction } from 'express';
import { HttpError } from '../utils/errors';
import { config } from '../config/config';

const errorHandler = (err: Error, req: Request, res: Response, next: NextFunction): void => {
  // Log the error (consider using a logging library)
  console.error('Error:', err);

  let statusCode = 500;
  let message = 'Internal Server Error';

  // Determine if the error is an instance of HttpError
  if (err instanceof HttpError) {
    statusCode = err.statusCode;
    message = err.message;
  }

  // Prepare the error response
  const errorResponse: any = {
    error: {
      message: message,
      status: statusCode
    }
  };

  // In development mode, include the error stack in the response
  if (config.nodeEnv === 'development') {
    errorResponse.error.stack = err.stack;
  }

  // Send the error response to the client
  res.status(statusCode).json(errorResponse);
};

export default errorHandler;