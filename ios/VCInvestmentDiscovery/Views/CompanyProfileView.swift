import SwiftUI
import Combine

struct CompanyProfileView: View {
    @ObservedObject var viewModel: CompanyProfileViewModel
    
    init(viewModel: CompanyProfileViewModel) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                companyOverviewSection()
                financialDataSection()
                socialMetricsSection()
                investmentPerformanceSection()
                
                NavigationLink(destination: TrendAnalysisView(trendId: viewModel.company.id)) {
                    Text("View Related Industry Trends")
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
            }
            .padding()
        }
        .navigationTitle(viewModel.company.name)
    }
    
    private func companyOverviewSection() -> some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                AsyncImage(url: URL(string: viewModel.company.logoUrl)) { image in
                    image.resizable()
                } placeholder: {
                    ProgressView()
                }
                .frame(width: 80, height: 80)
                .cornerRadius(10)
                
                VStack(alignment: .leading) {
                    Text(viewModel.company.name)
                        .font(.title)
                        .fontWeight(.bold)
                    Text(viewModel.company.industry)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
            }
            
            Text("Founded: \(viewModel.company.foundingDate, style: .date)")
            Text("Headquarters: \(viewModel.company.headquarters)")
            Text("CEO: \(viewModel.company.ceo)")
            
            Text(viewModel.company.description)
                .padding(.top, 5)
        }
    }
    
    private func financialDataSection() -> some View {
        Section(header: Text("Financial Data").font(.headline)) {
            VStack(alignment: .leading, spacing: 10) {
                HStack {
                    Text("Revenue:")
                    Spacer()
                    Text("$\(viewModel.financialData.revenue, specifier: "%.2f")M")
                }
                HStack {
                    Text("Profit:")
                    Spacer()
                    Text("$\(viewModel.financialData.profit, specifier: "%.2f")M")
                }
                HStack {
                    Text("Burn Rate:")
                    Spacer()
                    Text("$\(viewModel.financialData.burnRate, specifier: "%.2f")M/month")
                }
                
                // Financial trend chart
                Chart {
                    ForEach(viewModel.financialData.revenueHistory, id: \.date) { dataPoint in
                        LineMark(
                            x: .value("Date", dataPoint.date),
                            y: .value("Revenue", dataPoint.value)
                        )
                    }
                }
                .frame(height: 200)
                .chartXAxis {
                    AxisMarks(values: .automatic(desiredCount: 5))
                }
                .chartYAxis {
                    AxisMarks(position: .leading)
                }
            }
        }
    }
    
    private func socialMetricsSection() -> some View {
        Section(header: Text("Social Metrics").font(.headline)) {
            VStack(alignment: .leading, spacing: 10) {
                HStack {
                    Text("Twitter Followers:")
                    Spacer()
                    Text("\(viewModel.socialData.twitterFollowers)")
                }
                HStack {
                    Text("LinkedIn Followers:")
                    Spacer()
                    Text("\(viewModel.socialData.linkedInFollowers)")
                }
                HStack {
                    Text("Web Traffic:")
                    Spacer()
                    Text("\(viewModel.socialData.webTraffic) visits/month")
                }
                HStack {
                    Text("Sentiment Score:")
                    Spacer()
                    Text("\(viewModel.socialData.sentimentScore, specifier: "%.2f")")
                }
                
                // Sentiment analysis visualization
                // TODO: Implement sentiment analysis visualization
            }
        }
    }
    
    private func investmentPerformanceSection() -> some View {
        Section(header: Text("Investment Performance").font(.headline)) {
            VStack(alignment: .leading, spacing: 10) {
                HStack {
                    Text("Initial Investment:")
                    Spacer()
                    Text("$\(viewModel.investmentPerformance.initialInvestment, specifier: "%.2f")M")
                }
                HStack {
                    Text("Current Valuation:")
                    Spacer()
                    Text("$\(viewModel.investmentPerformance.currentValuation, specifier: "%.2f")M")
                }
                HStack {
                    Text("ROI:")
                    Spacer()
                    Text("\(viewModel.investmentPerformance.roi, specifier: "%.2f")%")
                }
                HStack {
                    Text("IRR:")
                    Spacer()
                    Text("\(viewModel.investmentPerformance.irr, specifier: "%.2f")%")
                }
                
                // Investment value over time chart
                Chart {
                    ForEach(viewModel.investmentPerformance.valueHistory, id: \.date) { dataPoint in
                        LineMark(
                            x: .value("Date", dataPoint.date),
                            y: .value("Value", dataPoint.value)
                        )
                    }
                }
                .frame(height: 200)
                .chartXAxis {
                    AxisMarks(values: .automatic(desiredCount: 5))
                }
                .chartYAxis {
                    AxisMarks(position: .leading)
                }
            }
        }
    }
}