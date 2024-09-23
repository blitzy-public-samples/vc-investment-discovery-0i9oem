import Foundation

struct Trend: Codable, Identifiable {
    let id: UUID
    let name: String
    let description: String
    let category: TrendCategory
    let identifiedDate: Date
    var growthRate: Double
    var confidenceScore: Int
    let relatedIndustries: [String]
    let relatedCompanyIds: [UUID]
    let keywords: [String]
    var data: TrendData
    
    init(id: UUID, name: String, description: String, category: TrendCategory, identifiedDate: Date, growthRate: Double, confidenceScore: Int, relatedIndustries: [String], relatedCompanyIds: [UUID], keywords: [String], data: TrendData) {
        self.id = id
        self.name = name
        self.description = description
        self.category = category
        self.identifiedDate = identifiedDate
        self.growthRate = growthRate
        self.confidenceScore = confidenceScore
        self.relatedIndustries = relatedIndustries
        self.relatedCompanyIds = relatedCompanyIds
        self.keywords = keywords
        self.data = data
    }
    
    func isEmergingTrend() -> Bool {
        let growthRateThreshold = 0.2 // 20%
        let emergingPeriod: TimeInterval = 180 * 24 * 60 * 60 // 6 months in seconds
        
        let isHighGrowth = growthRate > growthRateThreshold
        let isRecent = Date().timeIntervalSince(identifiedDate) < emergingPeriod
        
        return isHighGrowth && isRecent
    }
    
    func calculateRelevanceScore() -> Double {
        // TODO: Determine appropriate weights for each factor
        let growthRateWeight = 0.4
        let confidenceScoreWeight = 0.3
        let relatedCompaniesWeight = 0.3
        
        let normalizedConfidenceScore = Double(confidenceScore) / 100.0
        let normalizedRelatedCompanies = min(Double(relatedCompanyIds.count) / 10.0, 1.0) // Normalize to max of 10 companies
        
        let relevanceScore = (growthRate * growthRateWeight) +
                             (normalizedConfidenceScore * confidenceScoreWeight) +
                             (normalizedRelatedCompanies * relatedCompaniesWeight)
        
        return min(relevanceScore, 1.0) // Ensure the score is between 0 and 1
    }
    
    mutating func updateTrendData(_ newData: TrendData) {
        self.data = newData
        
        // Recalculate growth rate and confidence score based on new data
        // This is a simplified example; actual implementation may vary based on TrendData structure
        self.growthRate = newData.calculateGrowthRate()
        self.confidenceScore = newData.calculateConfidenceScore()
    }
}

extension Trend {
    enum CodingKeys: String, CodingKey {
        case id, name, description, category, identifiedDate, growthRate, confidenceScore, relatedIndustries, relatedCompanyIds, keywords, data
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(name, forKey: .name)
        try container.encode(description, forKey: .description)
        try container.encode(category, forKey: .category)
        try container.encode(identifiedDate, forKey: .identifiedDate)
        try container.encode(growthRate, forKey: .growthRate)
        try container.encode(confidenceScore, forKey: .confidenceScore)
        try container.encode(relatedIndustries, forKey: .relatedIndustries)
        try container.encode(relatedCompanyIds, forKey: .relatedCompanyIds)
        try container.encode(keywords, forKey: .keywords)
        try container.encode(data, forKey: .data)
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(UUID.self, forKey: .id)
        name = try container.decode(String.self, forKey: .name)
        description = try container.decode(String.self, forKey: .description)
        category = try container.decode(TrendCategory.self, forKey: .category)
        identifiedDate = try container.decode(Date.self, forKey: .identifiedDate)
        growthRate = try container.decode(Double.self, forKey: .growthRate)
        confidenceScore = try container.decode(Int.self, forKey: .confidenceScore)
        relatedIndustries = try container.decode([String].self, forKey: .relatedIndustries)
        relatedCompanyIds = try container.decode([UUID].self, forKey: .relatedCompanyIds)
        keywords = try container.decode([String].self, forKey: .keywords)
        data = try container.decode(TrendData.self, forKey: .data)
    }
}