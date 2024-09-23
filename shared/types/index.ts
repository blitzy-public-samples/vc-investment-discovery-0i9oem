// shared/types/index.ts

// User preferences for app customization
export interface UserPreferences {
  theme: string;
  notificationSettings: {
    email: boolean;
    push: boolean;
  };
  defaultCurrency: string;
  language: string;
}

// Financial data for a company
export interface FinancialData {
  revenue: number;
  profit: number;
  cashFlow: number;
  burnRate: number;
  fundingRounds: {
    date: Date;
    amount: number;
    valuation: number;
  }[];
}

// Social media and web presence data for a company
export interface SocialData {
  twitterFollowers: number;
  linkedInFollowers: number;
  webTraffic: number;
  sentimentScore: number;
}

// Market-related data for a company
export interface MarketData {
  marketSize: number;
  competitorCount: number;
  marketGrowthRate: number;
  marketShare: number;
}

// Asset allocation for a portfolio
export interface AssetAllocation {
  sectors: { [sector: string]: number };
  stages: { [stage in InvestmentStage]: number };
  geographies: { [country: string]: number };
}

// Performance metrics for investments or portfolios
export interface PerformanceMetrics {
  roi: number;
  irr: number;
  tvpi: number;
  dpi: number;
  rvpi: number;
}

// Stages of investment for a company
export enum InvestmentStage {
  SEED = "SEED",
  SERIES_A = "SERIES_A",
  SERIES_B = "SERIES_B",
  SERIES_C = "SERIES_C",
  SERIES_D = "SERIES_D",
  LATE_STAGE = "LATE_STAGE",
  PRE_IPO = "PRE_IPO"
}

// Stages of a company's lifecycle
export enum CompanyStage {
  IDEA = "IDEA",
  MVP = "MVP",
  EARLY_TRACTION = "EARLY_TRACTION",
  SCALING = "SCALING",
  ESTABLISHED = "ESTABLISHED",
  MATURE = "MATURE"
}

// Types of alerts in the system
export enum AlertType {
  INVESTMENT_OPPORTUNITY = "INVESTMENT_OPPORTUNITY",
  PORTFOLIO_UPDATE = "PORTFOLIO_UPDATE",
  MARKET_NEWS = "MARKET_NEWS",
  COMPANY_MILESTONE = "COMPANY_MILESTONE",
  TREND_ALERT = "TREND_ALERT"
}

// Priority levels for alerts
export enum AlertPriority {
  LOW = "LOW",
  MEDIUM = "MEDIUM",
  HIGH = "HIGH",
  URGENT = "URGENT"
}

// Categories of trends
export enum TrendCategory {
  TECHNOLOGY = "TECHNOLOGY",
  MARKET = "MARKET",
  REGULATORY = "REGULATORY",
  SOCIAL = "SOCIAL",
  ECONOMIC = "ECONOMIC",
  ENVIRONMENTAL = "ENVIRONMENTAL"
}