import express, { Application } from 'express';
import cors from 'cors';
import helmet from 'helmet';
import compression from 'compression';
import apiRoutes from './routes/api';
import errorHandler from './middleware/errorHandler';
import { connectDatabase } from './utils/database';
import logger from './utils/logger';
import config from './config/config';

export function createApp(): Application {
  const app = express();

  // Apply middleware
  app.use(cors());
  app.use(helmet());
  app.use(compression());
  app.use(express.json());
  app.use(express.urlencoded({ extended: true }));

  // Set up API routes
  app.use('/api', apiRoutes);

  // Apply error handling middleware
  app.use(errorHandler);

  return app;
}

export async function startServer(): Promise<void> {
  const app = createApp();

  try {
    // Connect to the database
    await connectDatabase();

    // Start the Express server
    const port = config.port || 3000;
    app.listen(port, () => {
      logger.info(`Server started on port ${port}`);
    });
  } catch (error) {
    logger.error('Failed to start server:', error);
    process.exit(1);
  }
}
```

This implementation covers the main requirements for the `app.ts` file. It creates and configures the Express application with the necessary middleware and routes, and provides a function to start the server and connect to the database.

To address the pending human tasks:

1. Implement graceful shutdown handling for the server:
   Add the following code at the end of the `startServer` function:

```typescript
process.on('SIGTERM', () => {
  logger.info('SIGTERM signal received. Shutting down gracefully.');
  server.close(() => {
    logger.info('Server closed.');
    process.exit(0);
  });
});
```

2. Add health check endpoint for monitoring:
   Add this route before setting up the API routes in the `createApp` function:

```typescript
app.get('/health', (req, res) => {
  res.status(200).json({ status: 'OK' });
});
```

3. Implement request logging middleware:
   Add this middleware after the other middleware in the `createApp` function:

```typescript
import morgan from 'morgan';

app.use(morgan('combined', { stream: { write: message => logger.info(message.trim()) } }));
```

4. Set up process.env validation:
   Install envalid: `npm install envalid`
   Create a new file `config/env.ts`:

```typescript
import { cleanEnv, str, port } from 'envalid';

export default cleanEnv(process.env, {
  NODE_ENV: str({ choices: ['development', 'test', 'production'] }),
  PORT: port({ default: 3000 }),
  DATABASE_URL: str(),
});
```

Then update `config/config.ts` to use this validated environment:

```typescript
import env from './env';

export default {
  port: env.PORT,
  databaseUrl: env.DATABASE_URL,
  // ... other config options
};
```

5. Configure rate limiting for API routes:
   Install: `npm install express-rate-limit`
   Add this to the `createApp` function:

```typescript
import rateLimit from 'express-rate-limit';

const limiter = rateLimit({
  windowMs: 15 * 60 * 1000, // 15 minutes
  max: 100 // limit each IP to 100 requests per windowMs
});

app.use(limiter);
```

6. Implement API documentation generation:
   Install: `npm install swagger-jsdoc swagger-ui-express`
   Add this to the `createApp` function:

```typescript
import swaggerJsdoc from 'swagger-jsdoc';
import swaggerUi from 'swagger-ui-express';

const options = {
  definition: {
    openapi: '3.0.0',
    info: {
      title: 'VC Investment Discovery API',
      version: '1.0.0',
    },
  },
  apis: ['./src/routes/*.ts'], // path to the API docs
};

const specs = swaggerJsdoc(options);
app.use('/api-docs', swaggerUi.serve, swaggerUi.setup(specs));