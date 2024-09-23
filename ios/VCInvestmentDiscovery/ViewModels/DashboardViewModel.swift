import Foundation
import Combine

@MainActor
class DashboardViewModel: ObservableObject {
    @Published var portfolioOverview: PortfolioOverview?
    @Published var recentAlerts: [Alert] = []
    @Published var trendingInvestments: [TrendingInvestment] = []
    
    private let dataService: DataService
    private var cancellables = Set<AnyCancellable>()
    
    init(dataService: DataService) {
        self.dataService = dataService
        setupBindings()
    }
    
    private func setupBindings() {
        dataService.$portfolioOverview
            .assign(to: \.portfolioOverview, on: self)
            .store(in: &cancellables)
        
        dataService.$recentAlerts
            .assign(to: \.recentAlerts, on: self)
            .store(in: &cancellables)
        
        dataService.$trendingInvestments
            .assign(to: \.trendingInvestments, on: self)
            .store(in: &cancellables)
    }
    
    func refreshDashboard() {
        Task {
            await dataService.fetchPortfolioOverview()
            await dataService.fetchRecentAlerts()
            await dataService.fetchTrendingInvestments()
        }
    }
    
    func markAlertAsRead(_ alertId: UUID) {
        Task {
            await dataService.markAlertAsRead(alertId)
            if let index = recentAlerts.firstIndex(where: { $0.id == alertId }) {
                recentAlerts[index].isRead = true
            }
        }
    }
    
    func loadMoreTrendingInvestments() {
        Task {
            if let newInvestments = await dataService.fetchMoreTrendingInvestments() {
                trendingInvestments.append(contentsOf: newInvestments)
            }
        }
    }
}