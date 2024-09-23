import Foundation
import Combine

@MainActor
class SearchDiscoveryViewModel: ObservableObject {
    @Published var searchResults: [SearchResult] = []
    @Published var isLoading: Bool = false
    @Published var searchQuery: String = ""
    @Published var selectedFilters: Set<SearchFilter> = []
    @Published var sortOption: SortOption = .relevance // Assuming a default sort option
    
    private let dataService: DataService
    private var cancellables = Set<AnyCancellable>()
    
    init(dataService: DataService) {
        self.dataService = dataService
        setupBindings()
    }
    
    private func setupBindings() {
        $searchQuery
            .debounce(for: .milliseconds(300), scheduler: RunLoop.main)
            .removeDuplicates()
            .sink { [weak self] _ in
                self?.performSearch()
            }
            .store(in: &cancellables)
        
        $selectedFilters
            .sink { [weak self] _ in
                self?.performSearch()
            }
            .store(in: &cancellables)
        
        $sortOption
            .sink { [weak self] _ in
                self?.performSearch()
            }
            .store(in: &cancellables)
    }
    
    func performSearch() {
        isLoading = true
        
        Task {
            do {
                let results = try await dataService.search(query: searchQuery, filters: selectedFilters, sortOption: sortOption)
                searchResults = results
                isLoading = false
            } catch {
                // Handle error
                print("Search error: \(error)")
                isLoading = false
            }
        }
    }
    
    func updateFilters(_ filters: Set<SearchFilter>) {
        selectedFilters = filters
        // performSearch() will be called automatically due to the binding
    }
    
    func updateSortOption(_ option: SortOption) {
        sortOption = option
        // performSearch() will be called automatically due to the binding
    }
    
    func loadMoreResults() {
        isLoading = true
        
        Task {
            do {
                let newResults = try await dataService.loadMoreSearchResults()
                searchResults.append(contentsOf: newResults)
                isLoading = false
            } catch {
                // Handle error
                print("Load more results error: \(error)")
                isLoading = false
            }
        }
    }
    
    func getSuggestions() -> [String] {
        // This could be made asynchronous if needed
        return dataService.getSearchSuggestions(query: searchQuery)
    }
}