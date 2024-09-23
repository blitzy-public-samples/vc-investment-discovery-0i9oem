import Foundation
import Combine

@MainActor
class CompanyProfileViewModel: ObservableObject {
    @Published var company: Company?
    @Published var financialData: FinancialData?
    @Published var socialData: SocialData?
    @Published var marketData: MarketData?
    @Published var relatedTrends: [Trend] = []
    
    private let dataService: DataService
    private var cancellables = Set<AnyCancellable>()
    
    init(dataService: DataService, companyId: UUID) {
        self.dataService = dataService
        setupBindings()
        loadCompanyProfile(companyId: companyId)
    }
    
    private func setupBindings() {
        dataService.$company
            .assign(to: \.company, on: self)
            .store(in: &cancellables)
        
        dataService.$financialData
            .assign(to: \.financialData, on: self)
            .store(in: &cancellables)
        
        dataService.$socialData
            .assign(to: \.socialData, on: self)
            .store(in: &cancellables)
        
        dataService.$marketData
            .assign(to: \.marketData, on: self)
            .store(in: &cancellables)
        
        dataService.$relatedTrends
            .assign(to: \.relatedTrends, on: self)
            .store(in: &cancellables)
    }
    
    func loadCompanyProfile(companyId: UUID) {
        Task {
            await dataService.fetchCompany(companyId)
            await dataService.fetchFinancialData(companyId)
            await dataService.fetchSocialData(companyId)
            await dataService.fetchMarketData(companyId)
            await dataService.fetchRelatedTrends(companyId)
        }
    }
    
    func refreshCompanyProfile() {
        guard let companyId = company?.id else { return }
        loadCompanyProfile(companyId: companyId)
    }
    
    func updateFinancialData(_ newData: FinancialData) {
        guard let companyId = company?.id else { return }
        Task {
            await dataService.updateFinancialData(newData, for: companyId)
            self.financialData = newData
        }
    }
    
    func updateSocialData(_ newData: SocialData) {
        guard let companyId = company?.id else { return }
        Task {
            await dataService.updateSocialData(newData, for: companyId)
            self.socialData = newData
        }
    }
    
    func updateMarketData(_ newData: MarketData) {
        guard let companyId = company?.id else { return }
        Task {
            await dataService.updateMarketData(newData, for: companyId)
            self.marketData = newData
        }
    }
    
    func calculateInvestmentPotential() -> Double {
        // TODO: Implement a sophisticated algorithm for calculating investment potential
        // This is a placeholder implementation
        let financialScore = financialData?.revenue ?? 0
        let socialScore = Double(socialData?.twitterFollowers ?? 0)
        let marketScore = marketData?.marketSize ?? 0
        
        let weightedScore = (financialScore * 0.4) + (socialScore * 0.3) + (marketScore * 0.3)
        return min(max(weightedScore / 1_000_000, 0), 100) // Normalize to 0-100 scale
    }
}