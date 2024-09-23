import Foundation

struct Company: Codable, Identifiable {
    let id: UUID
    let name: String
    let industry: String
    let foundingDate: Date
    let description: String
    let headquarters: String
    let website: String?
    var valuation: Double
    var employeeCount: Int
    let founders: [String]
    var stage: CompanyStage
    var fundingRounds: [FundingRound]
    var financialData: FinancialData
    var socialData: SocialData
    var marketData: MarketData

    init(id: UUID, name: String, industry: String, foundingDate: Date, description: String, headquarters: String, website: String?, valuation: Double, employeeCount: Int, founders: [String], stage: CompanyStage, fundingRounds: [FundingRound], financialData: FinancialData, socialData: SocialData, marketData: MarketData) {
        self.id = id
        self.name = name
        self.industry = industry
        self.foundingDate = foundingDate
        self.description = description
        self.headquarters = headquarters
        self.website = website
        self.valuation = valuation
        self.employeeCount = employeeCount
        self.founders = founders
        self.stage = stage
        self.fundingRounds = fundingRounds
        self.financialData = financialData
        self.socialData = socialData
        self.marketData = marketData
    }

    func totalFundingRaised() -> Double {
        return fundingRounds.reduce(0) { $0 + $1.amount }
    }

    func latestValuation() -> Double {
        return valuation
    }

    mutating func updateFinancialData(newData: FinancialData) {
        self.financialData = newData
    }

    mutating func updateSocialData(newData: SocialData) {
        self.socialData = newData
    }

    mutating func updateMarketData(newData: MarketData) {
        self.marketData = newData
    }
}

// Codable conformance is automatically synthesized by Swift
// Identifiable conformance is provided by the `id` property

// MARK: - Pending Human Tasks
// TODO: Implement data validation for company properties (e.g., non-negative valuation)
// TODO: Add methods for calculating growth rates and other key performance indicators
// TODO: Implement a mechanism to fetch and update company information from external APIs
// TODO: Create unit tests for the Company model and its methods
// TODO: Consider adding support for company logos and other media assets
// TODO: Implement a method to generate a company summary or elevator pitch