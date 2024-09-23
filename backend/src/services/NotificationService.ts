import { User } from '../models/User';
import { Alert } from '../models/Alert';
import { NotificationPayload, NotificationType } from '../types';
import { NotificationError } from '../utils/errors';
import nodemailer from 'nodemailer';
import admin from 'firebase-admin';

class NotificationService {
    private readonly emailTransporter: nodemailer.Transporter;
    private readonly firebaseAdmin: admin.app.App;

    constructor() {
        // Initialize the emailTransporter using nodemailer
        this.emailTransporter = nodemailer.createTransport({
            // Configure email transport settings
            // This is just an example, replace with your actual email service configuration
            host: 'smtp.example.com',
            port: 587,
            secure: false,
            auth: {
                user: process.env.EMAIL_USER,
                pass: process.env.EMAIL_PASS
            }
        });

        // Initialize the firebaseAdmin for push notifications
        this.firebaseAdmin = admin.initializeApp({
            // Configure Firebase Admin SDK
            // This is just an example, replace with your actual Firebase configuration
            credential: admin.credential.cert({
                projectId: process.env.FIREBASE_PROJECT_ID,
                clientEmail: process.env.FIREBASE_CLIENT_EMAIL,
                privateKey: process.env.FIREBASE_PRIVATE_KEY?.replace(/\\n/g, '\n')
            })
        });
    }

    async createNotification(userId: string, payload: NotificationPayload): Promise<Alert> {
        try {
            const alert = new Alert({
                userId,
                type: payload.type,
                title: payload.title,
                message: payload.message,
                createdAt: new Date(),
                isRead: false,
                relatedEntityId: payload.relatedEntityId,
                priority: payload.priority
            });

            await alert.save();
            return alert;
        } catch (error) {
            throw new NotificationError('Failed to create notification', error);
        }
    }

    async sendNotification(userId: string, payload: NotificationPayload): Promise<void> {
        try {
            const user = await User.findById(userId);
            if (!user) {
                throw new NotificationError('User not found');
            }

            const alert = await this.createNotification(userId, payload);

            if (user.preferences.notificationSettings.email) {
                await this.sendEmailNotification(user.email, payload);
            }

            if (user.preferences.notificationSettings.push && user.deviceToken) {
                await this.sendPushNotification(user.deviceToken, payload);
            }

            alert.isSent = true;
            await alert.save();
        } catch (error) {
            throw new NotificationError('Failed to send notification', error);
        }
    }

    async sendEmailNotification(email: string, payload: NotificationPayload): Promise<void> {
        try {
            const mailOptions = {
                from: 'noreply@vcinvestmentdiscovery.com',
                to: email,
                subject: payload.title,
                text: payload.message,
                // You can add HTML content here for rich email notifications
            };

            await this.emailTransporter.sendMail(mailOptions);
        } catch (error) {
            throw new NotificationError('Failed to send email notification', error);
        }
    }

    async sendPushNotification(deviceToken: string, payload: NotificationPayload): Promise<void> {
        try {
            const message = {
                notification: {
                    title: payload.title,
                    body: payload.message
                },
                token: deviceToken
            };

            await this.firebaseAdmin.messaging().send(message);
        } catch (error) {
            throw new NotificationError('Failed to send push notification', error);
        }
    }

    async getUnreadNotifications(userId: string): Promise<Alert[]> {
        try {
            return await Alert.find({ userId, isRead: false }).sort({ createdAt: -1 });
        } catch (error) {
            throw new NotificationError('Failed to retrieve unread notifications', error);
        }
    }

    async markNotificationAsRead(notificationId: string): Promise<void> {
        try {
            const alert = await Alert.findById(notificationId);
            if (!alert) {
                throw new NotificationError('Notification not found');
            }

            alert.isRead = true;
            await alert.save();
        } catch (error) {
            throw new NotificationError('Failed to mark notification as read', error);
        }
    }
}

export default new NotificationService();