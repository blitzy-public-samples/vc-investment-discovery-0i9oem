// shared/constants/index.ts

export const API_VERSION = 'v1';

export const DEFAULT_CURRENCY = 'USD';

export const DEFAULT_LANGUAGE = 'en';

export const DATE_FORMAT = {
  DISPLAY: 'MMM DD, YYYY',
  API: 'YYYY-MM-DD',
  TIMESTAMP: 'YYYY-MM-DDTHH:mm:ss.SSSZ'
};

export const INVESTMENT_STAGES = {
  SEED: 'Seed',
  SERIES_A: 'Series A',
  SERIES_B: 'Series B',
  SERIES_C: 'Series C',
  SERIES_D: 'Series D',
  LATE_STAGE: 'Late Stage',
  PRE_IPO: 'Pre-IPO'
};

export const COMPANY_STAGES = {
  IDEA: 'Idea',
  MVP: 'MVP',
  EARLY_TRACTION: 'Early Traction',
  SCALING: 'Scaling',
  ESTABLISHED: 'Established',
  MATURE: 'Mature'
};

export const ALERT_TYPES = {
  INVESTMENT_OPPORTUNITY: 'Investment Opportunity',
  PORTFOLIO_UPDATE: 'Portfolio Update',
  MARKET_NEWS: 'Market News',
  COMPANY_MILESTONE: 'Company Milestone',
  TREND_ALERT: 'Trend Alert'
};

export const ALERT_PRIORITIES = {
  LOW: 'Low',
  MEDIUM: 'Medium',
  HIGH: 'High',
  URGENT: 'Urgent'
};

export const TREND_CATEGORIES = {
  TECHNOLOGY: 'Technology',
  MARKET: 'Market',
  REGULATORY: 'Regulatory',
  SOCIAL: 'Social',
  ECONOMIC: 'Economic',
  ENVIRONMENTAL: 'Environmental'
};