import SwiftUI
import Combine

struct TrendAnalysisView: View {
    @ObservedObject var viewModel: TrendAnalysisViewModel
    
    init(viewModel: TrendAnalysisViewModel) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 20) {
                    SearchBar(text: $viewModel.searchQuery)
                    
                    trendingSectorsSection()
                    emergingTechnologiesSection()
                    marketSentimentSection()
                    predictiveAnalyticsSection()
                }
                .padding()
            }
            .navigationTitle("Trend Analysis")
        }
        .onAppear {
            viewModel.loadTrendData()
        }
    }
    
    private func trendingSectorsSection() -> some View {
        Section(header: Text("Trending Sectors").font(.headline)) {
            ForEach(viewModel.trendingSectors) { sector in
                VStack(alignment: .leading) {
                    Text(sector.name).font(.subheadline)
                    HStack {
                        Text("Growth Rate: \(sector.growthRate, specifier: "%.2f")%")
                        Spacer()
                        Text("Investment Volume: $\(sector.investmentVolume, specifier: "%.2f")M")
                    }
                    .font(.caption)
                    
                    // Add a simple bar chart for sector performance
                    Chart {
                        BarMark(
                            x: .value("Month", sector.performanceData.map { $0.month }),
                            y: .value("Performance", sector.performanceData.map { $0.performance })
                        )
                    }
                    .frame(height: 100)
                }
                .padding()
                .background(Color.secondary.opacity(0.1))
                .cornerRadius(10)
            }
        }
    }
    
    private func emergingTechnologiesSection() -> some View {
        Section(header: Text("Emerging Technologies").font(.headline)) {
            ForEach(viewModel.emergingTechnologies) { tech in
                VStack(alignment: .leading) {
                    Text(tech.name).font(.subheadline)
                    Text("Adoption Rate: \(tech.adoptionRate, specifier: "%.2f")%")
                    Text("Potential Market Impact: \(tech.potentialMarketImpact)")
                    
                    if !tech.relatedCompanies.isEmpty {
                        Text("Related Companies:").font(.caption)
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack {
                                ForEach(tech.relatedCompanies, id: \.self) { company in
                                    Text(company)
                                        .padding(5)
                                        .background(Color.blue.opacity(0.1))
                                        .cornerRadius(5)
                                }
                            }
                        }
                    }
                }
                .padding()
                .background(Color.secondary.opacity(0.1))
                .cornerRadius(10)
            }
        }
    }
    
    private func marketSentimentSection() -> some View {
        Section(header: Text("Market Sentiment").font(.headline)) {
            VStack(alignment: .leading) {
                Text("Overall Sentiment: \(viewModel.overallSentiment)")
                    .font(.subheadline)
                
                Chart {
                    LineMark(
                        x: .value("Date", viewModel.sentimentTrend.map { $0.date }),
                        y: .value("Sentiment", viewModel.sentimentTrend.map { $0.sentiment })
                    )
                }
                .frame(height: 200)
                
                Text("Top Positive Sectors:")
                ForEach(viewModel.topPositiveSectors, id: \.self) { sector in
                    Text("• \(sector)")
                }
                
                Text("Top Negative Sectors:")
                ForEach(viewModel.topNegativeSectors, id: \.self) { sector in
                    Text("• \(sector)")
                }
            }
            .padding()
            .background(Color.secondary.opacity(0.1))
            .cornerRadius(10)
        }
    }
    
    private func predictiveAnalyticsSection() -> some View {
        Section(header: Text("Predictive Analytics").font(.headline)) {
            ForEach(viewModel.predictions) { prediction in
                VStack(alignment: .leading) {
                    Text(prediction.name).font(.subheadline)
                    Text("Forecasted Growth: \(prediction.forecastedGrowth, specifier: "%.2f")%")
                    Text("Confidence Interval: \(prediction.confidenceInterval)")
                    
                    Chart {
                        LineMark(
                            x: .value("Month", prediction.forecastData.map { $0.month }),
                            y: .value("Value", prediction.forecastData.map { $0.value })
                        )
                    }
                    .frame(height: 150)
                }
                .padding()
                .background(Color.secondary.opacity(0.1))
                .cornerRadius(10)
            }
        }
    }
}

struct SearchBar: View {
    @Binding var text: String
    
    var body: some View {
        HStack {
            TextField("Search trends...", text: $text)
                .padding(7)
                .padding(.horizontal, 25)
                .background(Color(.systemGray6))
                .cornerRadius(8)
                .overlay(
                    HStack {
                        Image(systemName: "magnifyingglass")
                            .foregroundColor(.gray)
                            .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
                            .padding(.leading, 8)
                        
                        if !text.isEmpty {
                            Button(action: {
                                self.text = ""
                            }) {
                                Image(systemName: "multiply.circle.fill")
                                    .foregroundColor(.gray)
                                    .padding(.trailing, 8)
                            }
                        }
                    }
                )
        }
    }
}