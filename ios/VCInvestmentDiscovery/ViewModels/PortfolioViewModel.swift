import Foundation
import Combine

@MainActor
class PortfolioViewModel: ObservableObject {
    @Published var portfolio: Portfolio?
    @Published var assetAllocation: AssetAllocation?
    @Published var performanceMetrics: PerformanceMetrics?
    
    private let dataService: DataService
    private var cancellables = Set<AnyCancellable>()
    
    init(dataService: DataService, portfolioId: UUID) {
        self.dataService = dataService
        setupBindings()
        loadPortfolio(portfolioId)
    }
    
    private func setupBindings() {
        dataService.$portfolio
            .assign(to: \.portfolio, on: self)
            .store(in: &cancellables)
        
        dataService.$assetAllocation
            .assign(to: \.assetAllocation, on: self)
            .store(in: &cancellables)
        
        dataService.$performanceMetrics
            .assign(to: \.performanceMetrics, on: self)
            .store(in: &cancellables)
    }
    
    func loadPortfolio(_ portfolioId: UUID) {
        Task {
            await dataService.fetchPortfolio(portfolioId)
            await dataService.fetchAssetAllocation(portfolioId)
            await dataService.fetchPerformanceMetrics(portfolioId)
        }
    }
    
    func refreshPortfolio() {
        guard let portfolioId = portfolio?.id else { return }
        loadPortfolio(portfolioId)
    }
    
    func addInvestment(_ investment: Investment) {
        guard let portfolioId = portfolio?.id else { return }
        
        Task {
            do {
                try await dataService.addInvestment(investment, to: portfolioId)
                await updateLocalPortfolioData()
            } catch {
                // Handle error
                print("Error adding investment: \(error)")
            }
        }
    }
    
    func removeInvestment(_ investmentId: UUID) {
        guard let portfolioId = portfolio?.id else { return }
        
        Task {
            do {
                try await dataService.removeInvestment(investmentId, from: portfolioId)
                await updateLocalPortfolioData()
            } catch {
                // Handle error
                print("Error removing investment: \(error)")
            }
        }
    }
    
    func updateInvestment(_ updatedInvestment: Investment) {
        Task {
            do {
                try await dataService.updateInvestment(updatedInvestment)
                await updateLocalPortfolioData()
            } catch {
                // Handle error
                print("Error updating investment: \(error)")
            }
        }
    }
    
    private func updateLocalPortfolioData() async {
        guard let portfolioId = portfolio?.id else { return }
        await loadPortfolio(portfolioId)
    }
}