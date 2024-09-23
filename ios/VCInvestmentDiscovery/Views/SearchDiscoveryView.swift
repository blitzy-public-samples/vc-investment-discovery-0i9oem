import SwiftUI
import Combine

struct SearchDiscoveryView: View {
    @ObservedObject var viewModel: SearchDiscoveryViewModel
    @State private var searchText = ""
    @State private var selectedFilters: Set<SearchFilter> = []
    @State private var showAdvancedFilters = false
    @State private var searchMode: SearchMode = .companies

    enum SearchMode {
        case companies, trends
    }

    init(viewModel: SearchDiscoveryViewModel) {
        self.viewModel = viewModel
        _searchText = State(initialValue: "")
        _selectedFilters = State(initialValue: [])
    }

    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                searchBarSection
                
                Picker("Search Mode", selection: $searchMode) {
                    Text("Companies").tag(SearchMode.companies)
                    Text("Trends").tag(SearchMode.trends)
                }
                .pickerStyle(SegmentedPickerStyle())
                .padding()
                
                resultListSection
            }
            .navigationTitle("Search & Discover")
            .navigationBarItems(trailing: filterButton)
        }
        .sheet(isPresented: $showAdvancedFilters) {
            filterView
        }
    }

    private var searchBarSection: some View {
        HStack {
            TextField("Search...", text: $searchText)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .onChange(of: searchText) { newValue in
                    viewModel.updateSearchQuery(newValue)
                }
            
            Button(action: {
                searchText = ""
                viewModel.updateSearchQuery("")
            }) {
                Image(systemName: "xmark.circle.fill")
                    .opacity(searchText.isEmpty ? 0 : 1)
            }
        }
        .padding()
    }

    private var resultListSection: some View {
        List {
            ForEach(viewModel.searchResults) { result in
                NavigationLink(
                    destination: destinationView(for: result)
                ) {
                    SearchResultItemView(result: result)
                }
            }
            if viewModel.isLoading {
                ProgressView()
                    .onAppear {
                        viewModel.loadMoreResults()
                    }
            }
        }
        .listStyle(PlainListStyle())
    }

    private func destinationView(for result: SearchResult) -> some View {
        Group {
            if searchMode == .companies {
                CompanyProfileView(companyId: result.id)
            } else {
                TrendAnalysisView(trendId: result.id)
            }
        }
    }

    private var filterButton: some View {
        Button(action: {
            showAdvancedFilters = true
        }) {
            Image(systemName: "line.horizontal.3.decrease.circle")
        }
    }

    private var filterView: some View {
        NavigationView {
            Form {
                Section(header: Text("Industries")) {
                    // Implement industry selection
                }
                
                Section(header: Text("Funding Stage")) {
                    // Implement funding stage selection
                }
                
                Section(header: Text("Funding Amount")) {
                    // Implement funding amount range slider
                }
                
                Section(header: Text("Date Range")) {
                    // Implement date range picker
                }
            }
            .navigationTitle("Advanced Filters")
            .navigationBarItems(trailing: Button("Apply") {
                // Apply filters and update search results
                showAdvancedFilters = false
            })
        }
    }
}

struct SearchResultItemView: View {
    let result: SearchResult
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(result.title)
                .font(.headline)
            Text(result.description)
                .font(.subheadline)
                .foregroundColor(.secondary)
        }
    }
}