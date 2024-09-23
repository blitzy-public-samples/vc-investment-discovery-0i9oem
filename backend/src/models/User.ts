import { Schema, model, Document } from 'mongoose';
import bcrypt from 'bcrypt';
import { UserPreferences } from '../types';

interface IUser extends Document {
  _id: Schema.Types.ObjectId;
  email: string;
  password: string;
  firstName: string;
  lastName: string;
  dateJoined: Date;
  preferences: UserPreferences;
  portfolios: Schema.Types.ObjectId[];
  comparePassword(candidatePassword: string): Promise<boolean>;
  fullName: string;
}

const UserSchema = new Schema<IUser>({
  email: { type: String, required: true, unique: true },
  password: { type: String, required: true },
  firstName: { type: String, required: true },
  lastName: { type: String, required: true },
  dateJoined: { type: Date, default: Date.now },
  preferences: { type: Schema.Types.Mixed, default: {} },
  portfolios: { type: [Schema.Types.ObjectId], ref: 'Portfolio' }
});

UserSchema.pre('save', async function(next) {
  if (!this.isModified('password')) return next();

  try {
    const salt = await bcrypt.genSalt(10);
    this.password = await bcrypt.hash(this.password, salt);
    next();
  } catch (error) {
    next(error);
  }
});

UserSchema.methods.comparePassword = async function(candidatePassword: string): Promise<boolean> {
  try {
    return await bcrypt.compare(candidatePassword, this.password);
  } catch (error) {
    throw new Error('Error comparing passwords');
  }
};

UserSchema.virtual('fullName').get(function(this: IUser) {
  return `${this.firstName} ${this.lastName}`;
});

export default model<IUser>('User', UserSchema);