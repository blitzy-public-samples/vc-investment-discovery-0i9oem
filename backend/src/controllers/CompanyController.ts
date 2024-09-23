import { Request, Response, NextFunction } from 'express';
import CompanyService from '../services/CompanyService';
import { Company } from '../models/Company';
import { HttpError } from '../utils/errors';
import { CompanyCreateData, CompanyUpdateData } from '../types';

class CompanyController {
  private readonly companyService: CompanyService;

  constructor(companyService: CompanyService) {
    this.companyService = companyService;
  }

  async createCompany(req: Request, res: Response, next: NextFunction): Promise<void> {
    try {
      const companyData: CompanyCreateData = req.body;
      // TODO: Implement input validation
      const createdCompany = await this.companyService.createCompany(companyData);
      res.status(201).json(createdCompany);
    } catch (error) {
      next(error);
    }
  }

  async getCompany(req: Request, res: Response, next: NextFunction): Promise<void> {
    try {
      const companyId = req.params.id;
      const company = await this.companyService.getCompany(companyId);
      if (!company) {
        throw new HttpError(404, 'Company not found');
      }
      res.json(company);
    } catch (error) {
      next(error);
    }
  }

  async updateCompany(req: Request, res: Response, next: NextFunction): Promise<void> {
    try {
      const companyId = req.params.id;
      const updateData: CompanyUpdateData = req.body;
      // TODO: Implement input validation
      const updatedCompany = await this.companyService.updateCompany(companyId, updateData);
      if (!updatedCompany) {
        throw new HttpError(404, 'Company not found');
      }
      res.json(updatedCompany);
    } catch (error) {
      next(error);
    }
  }

  async deleteCompany(req: Request, res: Response, next: NextFunction): Promise<void> {
    try {
      const companyId = req.params.id;
      await this.companyService.deleteCompany(companyId);
      res.status(204).send();
    } catch (error) {
      next(error);
    }
  }

  async getCompanyFinancials(req: Request, res: Response, next: NextFunction): Promise<void> {
    try {
      const companyId = req.params.id;
      const financials = await this.companyService.getCompanyFinancials(companyId);
      if (!financials) {
        throw new HttpError(404, 'Company financials not found');
      }
      res.json(financials);
    } catch (error) {
      next(error);
    }
  }

  async getCompanySocialData(req: Request, res: Response, next: NextFunction): Promise<void> {
    try {
      const companyId = req.params.id;
      const socialData = await this.companyService.getCompanySocialData(companyId);
      if (!socialData) {
        throw new HttpError(404, 'Company social data not found');
      }
      res.json(socialData);
    } catch (error) {
      next(error);
    }
  }

  async getCompanyMarketData(req: Request, res: Response, next: NextFunction): Promise<void> {
    try {
      const companyId = req.params.id;
      const marketData = await this.companyService.getCompanyMarketData(companyId);
      if (!marketData) {
        throw new HttpError(404, 'Company market data not found');
      }
      res.json(marketData);
    } catch (error) {
      next(error);
    }
  }
}

export default CompanyController;