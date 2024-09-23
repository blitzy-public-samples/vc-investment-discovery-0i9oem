import SwiftUI
import Combine

struct PortfolioView: View {
    @ObservedObject var viewModel: PortfolioViewModel
    
    init(viewModel: PortfolioViewModel) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 20) {
                    portfolioSummarySection()
                    assetAllocationSection()
                    investmentListSection()
                    performanceMetricsSection()
                }
                .padding()
            }
            .navigationTitle("Portfolio")
            .refreshable {
                await viewModel.refreshPortfolio()
            }
        }
    }
    
    private func portfolioSummarySection() -> some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Portfolio Summary")
                .font(.headline)
            
            Text("Total Value: \(viewModel.portfolio.totalValue.formatted(.currency(code: "USD")))")
                .font(.title2)
            
            Text("Total Return: \(viewModel.portfolio.totalReturn.formatted(.percent))")
            Text("IRR: \(viewModel.portfolio.irr.formatted(.percent))")
            
            // TODO: Implement custom chart for portfolio value over time
            Text("Portfolio Value Chart Placeholder")
        }
        .padding()
        .background(Color.secondary.opacity(0.1))
        .cornerRadius(10)
    }
    
    private func assetAllocationSection() -> some View {
        Section(header: Text("Asset Allocation")) {
            // TODO: Implement interactive pie chart
            Text("Asset Allocation Pie Chart Placeholder")
            
            // TODO: Add legend with allocation percentages
            Text("Allocation Legend Placeholder")
            
            // TODO: Add option to switch allocation views
            Picker("Allocation View", selection: $viewModel.selectedAllocationView) {
                Text("Sector").tag(AllocationView.sector)
                Text("Stage").tag(AllocationView.stage)
                Text("Geography").tag(AllocationView.geography)
            }
            .pickerStyle(SegmentedPickerStyle())
        }
    }
    
    private func investmentListSection() -> some View {
        Section(header: Text("Investments")) {
            List {
                ForEach(viewModel.portfolio.investments) { investment in
                    NavigationLink(destination: CompanyProfileView(viewModel: CompanyProfileViewModel(companyId: investment.companyId))) {
                        InvestmentRow(investment: investment)
                    }
                }
            }
            .listStyle(PlainListStyle())
            
            // TODO: Implement search and sorting
            HStack {
                TextField("Search investments", text: $viewModel.searchQuery)
                Menu {
                    Button("Sort by Value") { viewModel.sortInvestments(by: .value) }
                    Button("Sort by Return") { viewModel.sortInvestments(by: .return) }
                    Button("Sort by Date") { viewModel.sortInvestments(by: .date) }
                } label: {
                    Image(systemName: "arrow.up.arrow.down")
                }
            }
        }
    }
    
    private func performanceMetricsSection() -> some View {
        Section(header: Text("Performance Metrics")) {
            VStack(alignment: .leading, spacing: 10) {
                MetricRow(label: "TVPI", value: viewModel.portfolio.tvpi)
                MetricRow(label: "DPI", value: viewModel.portfolio.dpi)
                MetricRow(label: "RVPI", value: viewModel.portfolio.rvpi)
                
                // TODO: Implement performance over time chart
                Text("Performance Chart Placeholder")
                
                // TODO: Add comparison against benchmarks
                Text("Benchmark Comparison Placeholder")
            }
        }
    }
}

struct InvestmentRow: View {
    let investment: Investment
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(investment.companyName)
                .font(.headline)
            HStack {
                Text("Invested: \(investment.investedAmount.formatted(.currency(code: "USD")))")
                Spacer()
                Text("Current: \(investment.currentValue.formatted(.currency(code: "USD")))")
            }
            Text("Return: \(investment.returnPercentage.formatted(.percent))")
        }
    }
}

struct MetricRow: View {
    let label: String
    let value: Double
    
    var body: some View {
        HStack {
            Text(label)
            Spacer()
            Text(value.formatted(.number.precision(.fractionLength(2))))
        }
    }
}

// TODO: Implement custom charts and graphs for portfolio visualization
// TODO: Add tooltips or info buttons to explain financial metrics