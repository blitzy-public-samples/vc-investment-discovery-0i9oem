import Foundation
import Combine

enum SyncError: Error {
    case networkError, serverError, localStorageError, conflictError
}

class DataSyncService: ObservableObject {
    private let apiService: APIService
    private let localStorageService: LocalStorageService
    private var cancellables = Set<AnyCancellable>()
    
    @Published private(set) var isSyncing: Bool = false
    
    init(apiService: APIService, localStorageService: LocalStorageService) {
        self.apiService = apiService
        self.localStorageService = localStorageService
    }
    
    func syncData() -> AnyPublisher<Void, SyncError> {
        return Future<Void, SyncError> { [weak self] promise in
            guard let self = self else {
                promise(.failure(.localStorageError))
                return
            }
            
            self.isSyncing = true
            
            // Fetch local changes
            let localChanges = self.localStorageService.fetchLocalChanges()
            
            // Send local changes to server
            self.apiService.sendChanges(localChanges)
                .flatMap { _ in
                    // Fetch remote changes
                    self.apiService.fetchRemoteChanges()
                }
                .flatMap { remoteChanges in
                    // Apply remote changes to local storage
                    self.localStorageService.applyRemoteChanges(remoteChanges)
                }
                .flatMap { conflictingData -> AnyPublisher<Void, SyncError> in
                    if !conflictingData.isEmpty {
                        // Resolve conflicts
                        let resolvedData = self.resolveConflicts(localData: conflictingData.0, remoteData: conflictingData.1)
                        return self.localStorageService.updateWithResolvedData(resolvedData)
                    } else {
                        return Just(()).setFailureType(to: SyncError.self).eraseToAnyPublisher()
                    }
                }
                .sink(
                    receiveCompletion: { completion in
                        self.isSyncing = false
                        switch completion {
                        case .finished:
                            promise(.success(()))
                        case .failure(let error):
                            promise(.failure(error))
                        }
                    },
                    receiveValue: { _ in }
                )
                .store(in: &self.cancellables)
        }
        .eraseToAnyPublisher()
    }
    
    func schedulePeriodicSync(interval: TimeInterval) {
        Timer.publish(every: interval, on: .main, in: .common)
            .autoconnect()
            .sink { [weak self] _ in
                self?.syncData()
                    .sink(receiveCompletion: { _ in }, receiveValue: { _ in })
                    .store(in: &self!.cancellables)
            }
            .store(in: &cancellables)
    }
    
    func cancelPeriodicSync() {
        cancellables.removeAll()
    }
    
    private func resolveConflicts(localData: [String: Any], remoteData: [String: Any]) -> [String: Any] {
        var resolvedData = [String: Any]()
        
        for (key, localValue) in localData {
            if let remoteValue = remoteData[key] {
                if let localDate = localValue as? Date, let remoteDate = remoteValue as? Date {
                    // Latest wins strategy for dates
                    resolvedData[key] = max(localDate, remoteDate)
                } else {
                    // For other types, prefer remote data (server wins)
                    resolvedData[key] = remoteValue
                }
            } else {
                // If the key doesn't exist in remote data, keep local value
                resolvedData[key] = localValue
            }
        }
        
        // Add any keys from remote data that don't exist in local data
        for (key, remoteValue) in remoteData where localData[key] == nil {
            resolvedData[key] = remoteValue
        }
        
        return resolvedData
    }
}