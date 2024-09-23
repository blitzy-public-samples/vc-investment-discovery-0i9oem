import { Schema, model, Document } from 'mongoose';
import { TrendCategory } from '../types';

interface ITrend extends Document {
  _id: Schema.Types.ObjectId;
  name: string;
  description: string;
  category: TrendCategory;
  identifiedDate: Date;
  growthRate: number;
  confidenceScore: number;
  relatedIndustries: string[];
  relatedCompanyIds: Schema.Types.ObjectId[];
  keywords: string[];
  data: any;

  isEmergingTrend(emergingThreshold: number, emergingPeriodDays: number): boolean;
  calculateRelevanceScore(): number;
  updateTrendData(newData: any): Promise<void>;
}

const TrendSchema = new Schema<ITrend>({
  name: { type: String, required: true },
  description: { type: String, required: true },
  category: { type: String, enum: Object.values(TrendCategory), required: true },
  identifiedDate: { type: Date, default: Date.now },
  growthRate: { type: Number, required: true },
  confidenceScore: { type: Number, required: true, min: 0, max: 100 },
  relatedIndustries: { type: [String], required: true },
  relatedCompanyIds: { type: [Schema.Types.ObjectId], ref: 'Company' },
  keywords: { type: [String], required: true },
  data: { type: Schema.Types.Mixed }
});

TrendSchema.methods.isEmergingTrend = function(emergingThreshold: number, emergingPeriodDays: number): boolean {
  // Check if the growth rate is above the emergingThreshold
  const isGrowthRateHigh = this.growthRate > emergingThreshold;

  // Calculate the time difference between now and the identifiedDate
  const daysSinceIdentified = (Date.now() - this.identifiedDate.getTime()) / (1000 * 60 * 60 * 24);

  // Check if the time difference is within the emergingPeriodDays
  const isWithinEmergingPeriod = daysSinceIdentified <= emergingPeriodDays;

  // Return true if both conditions are met, false otherwise
  return isGrowthRateHigh && isWithinEmergingPeriod;
};

TrendSchema.methods.calculateRelevanceScore = function(): number {
  // TODO: Implement relevance score calculation
  // Consider factors such as growth rate, confidence score, and number of related companies
  // Apply weights to each factor
  // Calculate and return the weighted average as the relevance score
  return 0; // Placeholder return value
};

TrendSchema.methods.updateTrendData = async function(newData: any): Promise<void> {
  // Update the data property with the new trend data
  this.data = { ...this.data, ...newData };

  // TODO: Recalculate the growth rate and confidence score based on the new data

  // Save the updated trend document
  await this.save();
};

export default model<ITrend>('Trend', TrendSchema);