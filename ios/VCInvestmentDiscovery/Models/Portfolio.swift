import Foundation

struct Portfolio: Codable {
    let id: UUID
    let name: String
    let creationDate: Date
    var investments: [Investment]
    var totalValue: Double
    
    init(id: UUID, name: String, creationDate: Date, investments: [Investment]) {
        self.id = id
        self.name = name
        self.creationDate = creationDate
        self.investments = investments
        self.totalValue = self.calculateTotalValue()
    }
    
    mutating func addInvestment(_ investment: Investment) {
        investments.append(investment)
        totalValue = calculateTotalValue()
    }
    
    mutating func removeInvestment(investmentId: UUID) -> Bool {
        if let index = investments.firstIndex(where: { $0.id == investmentId }) {
            investments.remove(at: index)
            totalValue = calculateTotalValue()
            return true
        }
        return false
    }
    
    func calculateTotalValue() -> Double {
        let total = investments.reduce(0.0) { $0 + $1.currentValue }
        return total
    }
    
    func performanceMetrics() -> PortfolioMetrics {
        let totalInvested = investments.reduce(0.0) { $0 + $1.initialAmount }
        let totalCurrent = calculateTotalValue()
        let roi = (totalCurrent - totalInvested) / totalInvested * 100
        
        // TODO: Implement IRR calculation
        let irr = 0.0 // Placeholder
        
        return PortfolioMetrics(totalInvested: totalInvested,
                                totalCurrentValue: totalCurrent,
                                roi: roi,
                                irr: irr)
    }
}

extension Portfolio {
    enum CodingKeys: String, CodingKey {
        case id, name, creationDate, investments, totalValue
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(name, forKey: .name)
        try container.encode(creationDate, forKey: .creationDate)
        try container.encode(investments, forKey: .investments)
        try container.encode(totalValue, forKey: .totalValue)
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(UUID.self, forKey: .id)
        name = try container.decode(String.self, forKey: .name)
        creationDate = try container.decode(Date.self, forKey: .creationDate)
        investments = try container.decode([Investment].self, forKey: .investments)
        totalValue = try container.decode(Double.self, forKey: .totalValue)
    }
}