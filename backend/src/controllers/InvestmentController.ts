import { Request, Response, NextFunction } from 'express';
import InvestmentService from '../services/InvestmentService';
import { Investment } from '../models/Investment';
import { HttpError } from '../utils/errors';
import { InvestmentCreateData, InvestmentUpdateData } from '../types';

class InvestmentController {
    private readonly investmentService: InvestmentService;

    constructor(investmentService: InvestmentService) {
        this.investmentService = investmentService;
    }

    async createInvestment(req: Request, res: Response, next: NextFunction): Promise<void> {
        try {
            const investmentData: InvestmentCreateData = req.body;
            // TODO: Implement input validation for investment creation
            const createdInvestment = await this.investmentService.createInvestment(investmentData);
            res.status(201).json(createdInvestment);
        } catch (error) {
            next(error);
        }
    }

    async getInvestment(req: Request, res: Response, next: NextFunction): Promise<void> {
        try {
            const investmentId = req.params.id;
            const investment = await this.investmentService.getInvestment(investmentId);
            if (!investment) {
                throw new HttpError(404, 'Investment not found');
            }
            res.json(investment);
        } catch (error) {
            next(error);
        }
    }

    async updateInvestment(req: Request, res: Response, next: NextFunction): Promise<void> {
        try {
            const investmentId = req.params.id;
            const updateData: InvestmentUpdateData = req.body;
            // TODO: Implement input validation for investment updates
            const updatedInvestment = await this.investmentService.updateInvestment(investmentId, updateData);
            res.json(updatedInvestment);
        } catch (error) {
            next(error);
        }
    }

    async deleteInvestment(req: Request, res: Response, next: NextFunction): Promise<void> {
        try {
            const investmentId = req.params.id;
            await this.investmentService.deleteInvestment(investmentId);
            res.status(204).send();
        } catch (error) {
            next(error);
        }
    }

    async getInvestmentPerformance(req: Request, res: Response, next: NextFunction): Promise<void> {
        try {
            const investmentId = req.params.id;
            const performanceMetrics = await this.investmentService.getInvestmentPerformance(investmentId);
            res.json(performanceMetrics);
        } catch (error) {
            next(error);
        }
    }

    async addTransaction(req: Request, res: Response, next: NextFunction): Promise<void> {
        try {
            const investmentId = req.params.id;
            const transactionData = req.body;
            // TODO: Implement input validation for transaction data
            const updatedInvestment = await this.investmentService.addTransaction(investmentId, transactionData);
            res.json(updatedInvestment);
        } catch (error) {
            next(error);
        }
    }
}

export default InvestmentController;