import Foundation
import Combine

@MainActor
class AlertCenterViewModel: ObservableObject {
    @Published var alerts: [Alert] = []
    @Published var filteredAlerts: [Alert] = []
    @Published var selectedFilter: AlertFilter = .all
    
    private let dataService: DataService
    private var cancellables = Set<AnyCancellable>()
    
    init(dataService: DataService) {
        self.dataService = dataService
        setupBindings()
        loadAlerts()
    }
    
    private func setupBindings() {
        dataService.$alerts
            .sink { [weak self] alerts in
                self?.alerts = alerts
                self?.applyFilter(self?.selectedFilter ?? .all)
            }
            .store(in: &cancellables)
        
        $selectedFilter
            .sink { [weak self] filter in
                self?.applyFilter(filter)
            }
            .store(in: &cancellables)
    }
    
    func loadAlerts() {
        Task {
            await dataService.fetchAlerts()
        }
    }
    
    func refreshAlerts() {
        loadAlerts()
    }
    
    func markAlertAsRead(_ alertId: UUID) {
        Task {
            await dataService.markAlertAsRead(alertId)
            if let index = alerts.firstIndex(where: { $0.id == alertId }) {
                alerts[index].isRead = true
            }
            applyFilter(selectedFilter)
        }
    }
    
    func deleteAlert(_ alertId: UUID) {
        Task {
            await dataService.deleteAlert(alertId)
            alerts.removeAll { $0.id == alertId }
            applyFilter(selectedFilter)
        }
    }
    
    func applyFilter(_ filter: AlertFilter) {
        selectedFilter = filter
        filteredAlerts = alerts.filter { alert in
            switch filter {
            case .all:
                return true
            case .unread:
                return !alert.isRead
            case .highPriority:
                return alert.priority == .high || alert.priority == .urgent
            }
        }
    }
    
    func sortAlerts(by criteria: AlertSortCriteria) {
        filteredAlerts.sort { alert1, alert2 in
            switch criteria {
            case .date:
                return alert1.createdAt > alert2.createdAt
            case .priority:
                return alert1.priority.rawValue > alert2.priority.rawValue
            case .type:
                return alert1.type.rawValue < alert2.type.rawValue
            }
        }
    }
}