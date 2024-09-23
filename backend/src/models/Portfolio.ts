import { Schema, model, Document } from 'mongoose';
import { AssetAllocation, PerformanceMetrics } from '../types';

interface IPortfolio extends Document {
  _id: Schema.Types.ObjectId;
  name: string;
  creationDate: Date;
  userId: Schema.Types.ObjectId;
  investments: Schema.Types.ObjectId[];
  totalValue: number;
  assetAllocation: AssetAllocation;
  performanceMetrics: PerformanceMetrics;
}

const PortfolioSchema = new Schema({
  name: { type: String, required: true },
  creationDate: { type: Date, default: Date.now },
  userId: { type: Schema.Types.ObjectId, ref: 'User', required: true },
  investments: { type: [Schema.Types.ObjectId], ref: 'Investment' },
  totalValue: { type: Number, default: 0 },
  assetAllocation: { type: Schema.Types.Mixed, default: {} },
  performanceMetrics: { type: Schema.Types.Mixed, default: {} }
});

PortfolioSchema.methods.calculateTotalValue = async function(): Promise<number> {
  await this.populate('investments');
  const totalValue = this.investments.reduce((sum, investment) => sum + investment.currentValue, 0);
  this.totalValue = totalValue;
  await this.save();
  return totalValue;
};

PortfolioSchema.methods.updateAssetAllocation = async function(): Promise<AssetAllocation> {
  await this.populate('investments');
  const allocation: AssetAllocation = {
    sectors: {},
    stages: {},
    geographies: {}
  };
  
  this.investments.forEach(investment => {
    // Calculate allocation based on investment properties
    // This is a simplified example and should be expanded based on actual investment data
    allocation.sectors[investment.sector] = (allocation.sectors[investment.sector] || 0) + investment.currentValue;
    allocation.stages[investment.stage] = (allocation.stages[investment.stage] || 0) + investment.currentValue;
    allocation.geographies[investment.geography] = (allocation.geographies[investment.geography] || 0) + investment.currentValue;
  });

  this.assetAllocation = allocation;
  await this.save();
  return allocation;
};

PortfolioSchema.methods.calculatePerformanceMetrics = async function(): Promise<PerformanceMetrics> {
  await this.populate('investments');
  const metrics: PerformanceMetrics = {
    roi: 0,
    irr: 0,
    tvpi: 0,
    dpi: 0,
    rvpi: 0
  };

  // Calculate ROI
  const totalInvested = this.investments.reduce((sum, inv) => sum + inv.initialAmount, 0);
  metrics.roi = (this.totalValue - totalInvested) / totalInvested * 100;

  // TODO: Implement advanced calculations for IRR, TVPI, DPI, and RVPI

  this.performanceMetrics = metrics;
  await this.save();
  return metrics;
};

export default model<IPortfolio>('Portfolio', PortfolioSchema);