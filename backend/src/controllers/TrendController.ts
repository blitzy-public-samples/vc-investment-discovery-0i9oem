import { Request, Response, NextFunction } from 'express';
import TrendService from '../services/TrendService';
import { Trend } from '../models/Trend';
import { HttpError } from '../utils/errors';
import { TrendCreateData, TrendUpdateData, TrendFilterOptions } from '../types';

class TrendController {
  private readonly trendService: TrendService;

  constructor(trendService: TrendService) {
    this.trendService = trendService;
  }

  async createTrend(req: Request, res: Response, next: NextFunction): Promise<void> {
    try {
      const trendData: TrendCreateData = req.body;
      // TODO: Implement input validation for trend creation
      const createdTrend = await this.trendService.createTrend(trendData);
      res.status(201).json(createdTrend);
    } catch (error) {
      next(error);
    }
  }

  async getTrend(req: Request, res: Response, next: NextFunction): Promise<void> {
    try {
      const trendId = req.params.id;
      const trend = await this.trendService.getTrend(trendId);
      if (!trend) {
        throw new HttpError(404, 'Trend not found');
      }
      res.json(trend);
    } catch (error) {
      next(error);
    }
  }

  async updateTrend(req: Request, res: Response, next: NextFunction): Promise<void> {
    try {
      const trendId = req.params.id;
      const updateData: TrendUpdateData = req.body;
      // TODO: Implement input validation for trend updates
      const updatedTrend = await this.trendService.updateTrend(trendId, updateData);
      if (!updatedTrend) {
        throw new HttpError(404, 'Trend not found');
      }
      res.json(updatedTrend);
    } catch (error) {
      next(error);
    }
  }

  async deleteTrend(req: Request, res: Response, next: NextFunction): Promise<void> {
    try {
      const trendId = req.params.id;
      await this.trendService.deleteTrend(trendId);
      res.status(204).send();
    } catch (error) {
      next(error);
    }
  }

  async getTrends(req: Request, res: Response, next: NextFunction): Promise<void> {
    try {
      const filterOptions: TrendFilterOptions = req.query;
      // TODO: Implement pagination support
      // TODO: Implement sorting options
      const trends = await this.trendService.getTrends(filterOptions);
      res.json(trends);
    } catch (error) {
      next(error);
    }
  }

  async getRelatedCompanies(req: Request, res: Response, next: NextFunction): Promise<void> {
    try {
      const trendId = req.params.id;
      const relatedCompanies = await this.trendService.getRelatedCompanies(trendId);
      res.json(relatedCompanies);
    } catch (error) {
      next(error);
    }
  }

  async analyzeTrendImpact(req: Request, res: Response, next: NextFunction): Promise<void> {
    try {
      const trendId = req.params.id;
      const impactAnalysis = await this.trendService.analyzeTrendImpact(trendId);
      res.json(impactAnalysis);
    } catch (error) {
      next(error);
    }
  }
}

export default TrendController;