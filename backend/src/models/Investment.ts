import { Schema, model, Document } from 'mongoose';
import { InvestmentStage } from '../types';

interface IInvestment extends Document {
  companyId: Schema.Types.ObjectId;
  portfolioId: Schema.Types.ObjectId;
  investmentDate: Date;
  initialAmount: number;
  currentValue: number;
  stage: InvestmentStage;
  ownershipPercentage: number;
  transactions: Schema.Types.ObjectId[];

  updateCurrentValue(newValue: number): Promise<void>;
  calculateROI(): number;
  calculateIRR(): Promise<number>;
}

const InvestmentSchema = new Schema<IInvestment>({
  companyId: { type: Schema.Types.ObjectId, ref: 'Company', required: true },
  portfolioId: { type: Schema.Types.ObjectId, ref: 'Portfolio', required: true },
  investmentDate: { type: Date, required: true },
  initialAmount: { type: Number, required: true },
  currentValue: { type: Number, required: true },
  stage: { type: String, enum: Object.values(InvestmentStage), required: true },
  ownershipPercentage: { type: Number, required: true },
  transactions: { type: [Schema.Types.ObjectId], ref: 'Transaction' }
});

InvestmentSchema.methods.updateCurrentValue = async function(newValue: number): Promise<void> {
  this.currentValue = newValue;
  await this.save();
};

InvestmentSchema.methods.calculateROI = function(): number {
  const gain = this.currentValue - this.initialAmount;
  return (gain / this.initialAmount) * 100;
};

InvestmentSchema.methods.calculateIRR = async function(): Promise<number> {
  await this.populate('transactions').execPopulate();
  // TODO: Implement IRR calculation algorithm
  // This is a placeholder implementation
  return 0;
};

export default model<IInvestment>('Investment', InvestmentSchema);