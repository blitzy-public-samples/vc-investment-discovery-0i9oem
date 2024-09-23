import { Router } from 'express';
import UserController from '../controllers/UserController';
import PortfolioController from '../controllers/PortfolioController';
import InvestmentController from '../controllers/InvestmentController';
import CompanyController from '../controllers/CompanyController';
import AlertController from '../controllers/AlertController';
import TrendController from '../controllers/TrendController';
import { authMiddleware } from '../middleware/auth';
import { errorHandler } from '../middleware/errorHandler';

const router = Router();

function setupRoutes(): Router {
  // User routes
  router.post('/users', UserController.register);
  router.post('/users/login', UserController.login);
  router.post('/users/refresh-token', UserController.refreshToken);
  router.get('/users/profile', authMiddleware, UserController.getProfile);
  router.put('/users/profile', authMiddleware, UserController.updateProfile);

  // Portfolio routes
  router.post('/portfolios', authMiddleware, PortfolioController.createPortfolio);
  router.get('/portfolios', authMiddleware, PortfolioController.getPortfolios);
  router.get('/portfolios/:id', authMiddleware, PortfolioController.getPortfolio);
  router.put('/portfolios/:id', authMiddleware, PortfolioController.updatePortfolio);
  router.delete('/portfolios/:id', authMiddleware, PortfolioController.deletePortfolio);
  router.get('/portfolios/:id/performance', authMiddleware, PortfolioController.getPortfolioPerformance);
  router.get('/portfolios/:id/investments', authMiddleware, PortfolioController.getPortfolioInvestments);

  // Investment routes
  router.post('/investments', authMiddleware, InvestmentController.createInvestment);
  router.get('/investments/:id', authMiddleware, InvestmentController.getInvestment);
  router.put('/investments/:id', authMiddleware, InvestmentController.updateInvestment);
  router.delete('/investments/:id', authMiddleware, InvestmentController.deleteInvestment);
  router.get('/investments/:id/performance', authMiddleware, InvestmentController.getInvestmentPerformance);
  router.post('/investments/:id/transactions', authMiddleware, InvestmentController.addTransaction);

  // Company routes
  router.post('/companies', authMiddleware, CompanyController.createCompany);
  router.get('/companies', authMiddleware, CompanyController.getCompanies);
  router.get('/companies/:id', authMiddleware, CompanyController.getCompany);
  router.put('/companies/:id', authMiddleware, CompanyController.updateCompany);
  router.delete('/companies/:id', authMiddleware, CompanyController.deleteCompany);
  router.get('/companies/:id/financials', authMiddleware, CompanyController.getCompanyFinancials);
  router.get('/companies/:id/social', authMiddleware, CompanyController.getCompanySocialData);
  router.get('/companies/:id/market', authMiddleware, CompanyController.getCompanyMarketData);

  // Alert routes
  router.post('/alerts', authMiddleware, AlertController.createAlert);
  router.get('/alerts', authMiddleware, AlertController.getUserAlerts);
  router.get('/alerts/:id', authMiddleware, AlertController.getAlert);
  router.put('/alerts/:id', authMiddleware, AlertController.updateAlert);
  router.delete('/alerts/:id', authMiddleware, AlertController.deleteAlert);
  router.put('/alerts/:id/read', authMiddleware, AlertController.markAlertAsRead);

  // Trend routes
  router.post('/trends', authMiddleware, TrendController.createTrend);
  router.get('/trends', authMiddleware, TrendController.getTrends);
  router.get('/trends/:id', authMiddleware, TrendController.getTrend);
  router.put('/trends/:id', authMiddleware, TrendController.updateTrend);
  router.delete('/trends/:id', authMiddleware, TrendController.deleteTrend);
  router.get('/trends/:id/companies', authMiddleware, TrendController.getRelatedCompanies);
  router.get('/trends/:id/impact', authMiddleware, TrendController.analyzeTrendImpact);

  // Apply error handling middleware
  router.use(errorHandler);

  return router;
}

export default setupRoutes();