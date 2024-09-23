import Foundation

struct Investment: Codable {
    let id: UUID
    let companyId: UUID
    let investmentDate: Date
    let initialAmount: Double
    var currentValue: Double
    let stage: InvestmentStage
    let ownershipPercentage: Double
    var transactions: [Transaction]
    
    init(id: UUID, companyId: UUID, investmentDate: Date, initialAmount: Double, stage: InvestmentStage, ownershipPercentage: Double) {
        self.id = id
        self.companyId = companyId
        self.investmentDate = investmentDate
        self.initialAmount = initialAmount
        self.currentValue = initialAmount
        self.stage = stage
        self.ownershipPercentage = ownershipPercentage
        self.transactions = []
    }
    
    mutating func updateCurrentValue(_ newValue: Double) {
        self.currentValue = newValue
    }
    
    mutating func addTransaction(_ transaction: Transaction) {
        self.transactions.append(transaction)
        // Update currentValue based on transaction type and amount
        // This is a simplified example, you may need to implement more complex logic
        self.currentValue += transaction.amount
    }
    
    func calculateROI() -> Double {
        let gain = currentValue - initialAmount
        return (gain / initialAmount) * 100
    }
    
    func calculateIRR() -> Double {
        // TODO: Implement IRR calculation algorithm
        // This is a placeholder implementation
        return 0.0
    }
}

extension Investment {
    enum CodingKeys: String, CodingKey {
        case id, companyId, investmentDate, initialAmount, currentValue, stage, ownershipPercentage, transactions
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(companyId, forKey: .companyId)
        try container.encode(investmentDate, forKey: .investmentDate)
        try container.encode(initialAmount, forKey: .initialAmount)
        try container.encode(currentValue, forKey: .currentValue)
        try container.encode(stage, forKey: .stage)
        try container.encode(ownershipPercentage, forKey: .ownershipPercentage)
        try container.encode(transactions, forKey: .transactions)
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(UUID.self, forKey: .id)
        companyId = try container.decode(UUID.self, forKey: .companyId)
        investmentDate = try container.decode(Date.self, forKey: .investmentDate)
        initialAmount = try container.decode(Double.self, forKey: .initialAmount)
        currentValue = try container.decode(Double.self, forKey: .currentValue)
        stage = try container.decode(InvestmentStage.self, forKey: .stage)
        ownershipPercentage = try container.decode(Double.self, forKey: .ownershipPercentage)
        transactions = try container.decode([Transaction].self, forKey: .transactions)
    }
}