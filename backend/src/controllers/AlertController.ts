import { Request, Response, NextFunction } from 'express';
import AlertService from '../services/AlertService';
import { Alert } from '../models/Alert';
import { HttpError } from '../utils/errors';
import { AlertCreateData, AlertUpdateData, AlertFilterOptions } from '../types';

class AlertController {
  private readonly alertService: AlertService;

  constructor(alertService: AlertService) {
    this.alertService = alertService;
  }

  async createAlert(req: Request, res: Response, next: NextFunction): Promise<void> {
    try {
      const alertData: AlertCreateData = req.body;
      // TODO: Implement input validation for alert creation
      const createdAlert = await this.alertService.createAlert(alertData);
      res.status(201).json(createdAlert);
    } catch (error) {
      next(error);
    }
  }

  async getAlert(req: Request, res: Response, next: NextFunction): Promise<void> {
    try {
      const alertId = req.params.id;
      const alert = await this.alertService.getAlert(alertId);
      if (!alert) {
        throw new HttpError(404, 'Alert not found');
      }
      res.json(alert);
    } catch (error) {
      next(error);
    }
  }

  async updateAlert(req: Request, res: Response, next: NextFunction): Promise<void> {
    try {
      const alertId = req.params.id;
      const updateData: AlertUpdateData = req.body;
      // TODO: Implement input validation for alert updates
      const updatedAlert = await this.alertService.updateAlert(alertId, updateData);
      if (!updatedAlert) {
        throw new HttpError(404, 'Alert not found');
      }
      res.json(updatedAlert);
    } catch (error) {
      next(error);
    }
  }

  async deleteAlert(req: Request, res: Response, next: NextFunction): Promise<void> {
    try {
      const alertId = req.params.id;
      await this.alertService.deleteAlert(alertId);
      res.status(204).send();
    } catch (error) {
      next(error);
    }
  }

  async getUserAlerts(req: Request, res: Response, next: NextFunction): Promise<void> {
    try {
      const userId = req.user.id; // Assuming user is attached to request after authentication
      const filterOptions: AlertFilterOptions = req.query;
      // TODO: Implement pagination
      // TODO: Implement sorting options
      const alerts = await this.alertService.getUserAlerts(userId, filterOptions);
      res.json(alerts);
    } catch (error) {
      next(error);
    }
  }

  async markAlertAsRead(req: Request, res: Response, next: NextFunction): Promise<void> {
    try {
      const alertId = req.params.id;
      const updatedAlert = await this.alertService.markAlertAsRead(alertId);
      if (!updatedAlert) {
        throw new HttpError(404, 'Alert not found');
      }
      res.json(updatedAlert);
    } catch (error) {
      next(error);
    }
  }
}

export default AlertController;