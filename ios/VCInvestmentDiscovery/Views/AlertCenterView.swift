import SwiftUI
import Combine

struct AlertCenterView: View {
    @ObservedObject var viewModel: AlertCenterViewModel
    
    init(viewModel: AlertCenterViewModel) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        NavigationView {
            VStack {
                alertFilterSection()
                alertListSection()
            }
            .navigationTitle("Alert Center")
            .onAppear {
                viewModel.loadAlerts()
            }
        }
    }
    
    private func alertListSection() -> some View {
        List {
            ForEach(viewModel.filteredAlerts) { alert in
                AlertItemView(alert: alert)
                    .swipeActions(edge: .trailing) {
                        Button(role: .destructive) {
                            viewModel.deleteAlert(alert)
                        } label: {
                            Label("Delete", systemImage: "trash")
                        }
                        Button {
                            viewModel.markAlertAsRead(alert)
                        } label: {
                            Label("Mark as Read", systemImage: "checkmark")
                        }
                        .tint(.blue)
                    }
            }
        }
        .listStyle(PlainListStyle())
    }
    
    private func alertFilterSection() -> some View {
        VStack {
            Picker("Filter", selection: $viewModel.selectedFilter) {
                ForEach(AlertFilter.allCases, id: \.self) { filter in
                    Text(filter.rawValue).tag(filter)
                }
            }
            .pickerStyle(SegmentedPickerStyle())
            .padding()
            
            HStack {
                Image(systemName: "magnifyingglass")
                TextField("Search alerts", text: $viewModel.searchQuery)
            }
            .padding()
            .background(Color(.systemGray6))
            .cornerRadius(10)
            .padding(.horizontal)
        }
    }
}

struct AlertItemView: View {
    let alert: Alert
    
    var body: some View {
        NavigationLink(destination: alertDetailView(alert: alert)) {
            HStack {
                Image(systemName: alertTypeIcon(for: alert.type))
                    .foregroundColor(alertTypeColor(for: alert.type))
                VStack(alignment: .leading) {
                    Text(alert.title)
                        .font(.headline)
                    Text(alert.message)
                        .font(.subheadline)
                        .lineLimit(2)
                }
                Spacer()
                Text(formattedDate(alert.createdAt))
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
        }
    }
    
    private func alertTypeIcon(for type: AlertType) -> String {
        switch type {
        case .investmentOpportunity:
            return "dollarsign.circle"
        case .portfolioUpdate:
            return "chart.pie"
        case .marketNews:
            return "newspaper"
        case .companyMilestone:
            return "flag"
        case .trendAlert:
            return "chart.line.uptrend.xyaxis"
        }
    }
    
    private func alertTypeColor(for type: AlertType) -> Color {
        switch type {
        case .investmentOpportunity:
            return .green
        case .portfolioUpdate:
            return .blue
        case .marketNews:
            return .orange
        case .companyMilestone:
            return .purple
        case .trendAlert:
            return .red
        }
    }
    
    private func formattedDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .short
        return formatter.string(from: date)
    }
}

private func alertDetailView(alert: Alert) -> some View {
    ScrollView {
        VStack(alignment: .leading, spacing: 16) {
            Text(alert.title)
                .font(.title)
                .fontWeight(.bold)
            
            Text(alert.message)
                .font(.body)
            
            HStack {
                Image(systemName: "calendar")
                Text(formattedDate(alert.createdAt))
            }
            .font(.caption)
            .foregroundColor(.secondary)
            
            Divider()
            
            actionButtons(for: alert)
        }
        .padding()
    }
    .navigationTitle("Alert Details")
}

private func actionButtons(for alert: Alert) -> some View {
    VStack(spacing: 12) {
        switch alert.type {
        case .investmentOpportunity, .companyMilestone:
            NavigationLink(destination: CompanyProfileView(companyId: alert.relatedEntityId)) {
                Text("View Company Profile")
                    .frame(maxWidth: .infinity)
            }
            .buttonStyle(.borderedProminent)
        case .trendAlert:
            NavigationLink(destination: TrendAnalysisView(trendId: alert.relatedEntityId)) {
                Text("Analyze Trend")
                    .frame(maxWidth: .infinity)
            }
            .buttonStyle(.borderedProminent)
        default:
            EmptyView()
        }
        
        Button(action: {
            // Implement snooze functionality
        }) {
            Text("Snooze Alert")
                .frame(maxWidth: .infinity)
        }
        .buttonStyle(.bordered)
        
        Button(action: {
            // Implement dismiss functionality
        }) {
            Text("Dismiss")
                .frame(maxWidth: .infinity)
        }
        .buttonStyle(.bordered)
    }
}

private func formattedDate(_ date: Date) -> String {
    let formatter = DateFormatter()
    formatter.dateStyle = .medium
    formatter.timeStyle = .short
    return formatter.string(from: date)
}