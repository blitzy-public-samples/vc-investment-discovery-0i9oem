import { Schema, model, Document } from 'mongoose';
import { AlertType, AlertPriority } from '../types';

interface IAlert extends Document {
  _id: Schema.Types.ObjectId;
  userId: Schema.Types.ObjectId;
  type: AlertType;
  title: string;
  message: string;
  createdAt: Date;
  isRead: boolean;
  relatedEntityId?: Schema.Types.ObjectId;
  priority: AlertPriority;
  markAsRead(): Promise<void>;
  isExpired(expirationDays: number): boolean;
}

const AlertSchema = new Schema<IAlert>({
  userId: { type: Schema.Types.ObjectId, ref: 'User', required: true },
  type: { type: String, enum: Object.values(AlertType), required: true },
  title: { type: String, required: true },
  message: { type: String, required: true },
  createdAt: { type: Date, default: Date.now },
  isRead: { type: Boolean, default: false },
  relatedEntityId: { type: Schema.Types.ObjectId, required: false },
  priority: { type: String, enum: Object.values(AlertPriority), required: true }
});

AlertSchema.methods.markAsRead = async function(): Promise<void> {
  this.isRead = true;
  await this.save();
};

AlertSchema.methods.isExpired = function(expirationDays: number): boolean {
  const expirationDate = new Date(this.createdAt);
  expirationDate.setDate(expirationDate.getDate() + expirationDays);
  return new Date() > expirationDate;
};

export default model<IAlert>('Alert', AlertSchema);