import SwiftUI
import Combine

struct DashboardView: View {
    @ObservedObject var viewModel: DashboardViewModel
    
    init(viewModel: DashboardViewModel) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        NavigationView {
            List {
                portfolioOverviewSection()
                recentAlertsSection()
                trendingInvestmentsSection()
                quickActionsSection()
            }
            .navigationTitle("Dashboard")
            .onAppear {
                viewModel.loadDashboardData()
            }
        }
    }
    
    private func portfolioOverviewSection() -> some View {
        Section(header: Text("Portfolio Overview")) {
            VStack(alignment: .leading) {
                Text("Total Value: \(viewModel.portfolioOverview?.totalValue ?? 0, specifier: "%.2f")")
                    .font(.headline)
                Text("Daily Change: \(viewModel.portfolioOverview?.dailyChange ?? 0, specifier: "%.2f")%")
                Text("Total Return: \(viewModel.portfolioOverview?.totalReturn ?? 0, specifier: "%.2f")%")
                
                NavigationLink(destination: PortfolioView(viewModel: PortfolioViewModel())) {
                    Text("View Details")
                }
            }
        }
    }
    
    private func recentAlertsSection() -> some View {
        Section(header: Text("Recent Alerts")) {
            ForEach(viewModel.recentAlerts) { alert in
                VStack(alignment: .leading) {
                    Text(alert.title)
                        .font(.headline)
                    Text(alert.message)
                        .font(.subheadline)
                }
            }
            
            NavigationLink(destination: AlertCenterView(viewModel: AlertCenterViewModel())) {
                Text("View All Alerts")
            }
        }
    }
    
    private func trendingInvestmentsSection() -> some View {
        Section(header: Text("Trending Investments")) {
            ForEach(viewModel.trendingInvestments) { investment in
                VStack(alignment: .leading) {
                    Text(investment.name)
                        .font(.headline)
                    Text("Sector: \(investment.sector)")
                    Text("Growth: \(investment.growth, specifier: "%.2f")%")
                }
            }
            
            NavigationLink(destination: TrendAnalysisView(viewModel: TrendAnalysisViewModel())) {
                Text("View All Trends")
            }
        }
    }
    
    private func quickActionsSection() -> some View {
        Section(header: Text("Quick Actions")) {
            HStack {
                Button(action: {
                    // Handle New Investment action
                }) {
                    VStack {
                        Image(systemName: "plus.circle")
                        Text("New Investment")
                    }
                }
                
                Spacer()
                
                NavigationLink(destination: SearchDiscoveryView(viewModel: SearchDiscoveryViewModel())) {
                    VStack {
                        Image(systemName: "magnifyingglass")
                        Text("Search")
                    }
                }
                
                Spacer()
                
                Button(action: {
                    // Handle Reports action
                }) {
                    VStack {
                        Image(systemName: "doc.text")
                        Text("Reports")
                    }
                }
            }
        }
    }
}