import { Request, Response, NextFunction } from 'express';
import PortfolioService from '../services/PortfolioService';
import { Portfolio } from '../models/Portfolio';
import { HttpError } from '../utils/errors';
import { PortfolioCreateData, PortfolioUpdateData } from '../types';

class PortfolioController {
    private readonly portfolioService: PortfolioService;

    constructor(portfolioService: PortfolioService) {
        this.portfolioService = portfolioService;
    }

    async createPortfolio(req: Request, res: Response, next: NextFunction): Promise<void> {
        try {
            const portfolioData: PortfolioCreateData = req.body;
            // TODO: Implement input validation for portfolioData
            const createdPortfolio = await this.portfolioService.createPortfolio(portfolioData);
            res.status(201).json(createdPortfolio);
        } catch (error) {
            next(error);
        }
    }

    async getPortfolio(req: Request, res: Response, next: NextFunction): Promise<void> {
        try {
            const portfolioId = req.params.id;
            const portfolio = await this.portfolioService.getPortfolio(portfolioId);
            if (!portfolio) {
                throw new HttpError(404, 'Portfolio not found');
            }
            res.json(portfolio);
        } catch (error) {
            next(error);
        }
    }

    async updatePortfolio(req: Request, res: Response, next: NextFunction): Promise<void> {
        try {
            const portfolioId = req.params.id;
            const updateData: PortfolioUpdateData = req.body;
            // TODO: Implement input validation for updateData
            const updatedPortfolio = await this.portfolioService.updatePortfolio(portfolioId, updateData);
            if (!updatedPortfolio) {
                throw new HttpError(404, 'Portfolio not found');
            }
            res.json(updatedPortfolio);
        } catch (error) {
            next(error);
        }
    }

    async deletePortfolio(req: Request, res: Response, next: NextFunction): Promise<void> {
        try {
            const portfolioId = req.params.id;
            await this.portfolioService.deletePortfolio(portfolioId);
            res.status(204).send();
        } catch (error) {
            next(error);
        }
    }

    async getPortfolioPerformance(req: Request, res: Response, next: NextFunction): Promise<void> {
        try {
            const portfolioId = req.params.id;
            const performance = await this.portfolioService.getPortfolioPerformance(portfolioId);
            res.json(performance);
        } catch (error) {
            next(error);
        }
    }

    async getPortfolioInvestments(req: Request, res: Response, next: NextFunction): Promise<void> {
        try {
            const portfolioId = req.params.id;
            // TODO: Implement pagination, sorting, and filtering
            const investments = await this.portfolioService.getPortfolioInvestments(portfolioId);
            res.json(investments);
        } catch (error) {
            next(error);
        }
    }
}

export default PortfolioController;