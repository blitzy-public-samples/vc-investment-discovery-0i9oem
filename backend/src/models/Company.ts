import { Schema, model, Document } from 'mongoose';
import { CompanyStage, FinancialData, SocialData, MarketData } from '../types';

interface ICompany extends Document {
  _id: Schema.Types.ObjectId;
  name: string;
  industry: string;
  foundingDate: Date;
  description: string;
  headquarters: string;
  website: string;
  valuation: number;
  employeeCount: number;
  founders: string[];
  stage: CompanyStage;
  fundingRounds: Schema.Types.ObjectId[];
  financialData: FinancialData;
  socialData: SocialData;
  marketData: MarketData;

  totalFundingRaised(): Promise<number>;
  latestValuation(): number;
  updateFinancialData(newData: FinancialData): Promise<void>;
  updateSocialData(newData: SocialData): Promise<void>;
  updateMarketData(newData: MarketData): Promise<void>;
}

const CompanySchema = new Schema<ICompany>({
  name: { type: String, required: true },
  industry: { type: String, required: true },
  foundingDate: { type: Date, required: true },
  description: { type: String, required: true },
  headquarters: { type: String, required: true },
  website: { type: String },
  valuation: { type: Number, required: true },
  employeeCount: { type: Number, required: true },
  founders: { type: [String], required: true },
  stage: { type: String, enum: Object.values(CompanyStage), required: true },
  fundingRounds: { type: [Schema.Types.ObjectId], ref: 'FundingRound' },
  financialData: { type: Schema.Types.Mixed },
  socialData: { type: Schema.Types.Mixed },
  marketData: { type: Schema.Types.Mixed }
});

CompanySchema.methods.totalFundingRaised = async function(): Promise<number> {
  await this.populate('fundingRounds');
  return this.fundingRounds.reduce((total, round) => total + round.amount, 0);
};

CompanySchema.methods.latestValuation = function(): number {
  return this.valuation;
};

CompanySchema.methods.updateFinancialData = async function(newData: FinancialData): Promise<void> {
  this.financialData = newData;
  await this.save();
};

CompanySchema.methods.updateSocialData = async function(newData: SocialData): Promise<void> {
  this.socialData = newData;
  await this.save();
};

CompanySchema.methods.updateMarketData = async function(newData: MarketData): Promise<void> {
  this.marketData = newData;
  await this.save();
};

export default model<ICompany>('Company', CompanySchema);