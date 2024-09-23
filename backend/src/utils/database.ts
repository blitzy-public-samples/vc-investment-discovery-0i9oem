import mongoose from 'mongoose';
import { config } from '../config/config';

export const connectDatabase = async (): Promise<void> => {
  try {
    // Retrieve the MongoDB connection URI from the config
    const mongoURI = config.database.uri;

    // Set mongoose connection options
    const options = {
      useNewUrlParser: true,
      useUnifiedTopology: true,
      // Add other options as needed
    };

    // Attempt to connect to the database
    await mongoose.connect(mongoURI, options);

    console.log('Successfully connected to the database');
  } catch (error) {
    console.error('Error connecting to the database:', error);
    process.exit(1);
  }
};

export const disconnectDatabase = async (): Promise<void> => {
  try {
    // Attempt to close the mongoose connection
    await mongoose.disconnect();

    console.log('Successfully disconnected from the database');
  } catch (error) {
    console.error('Error disconnecting from the database:', error);
  }
};