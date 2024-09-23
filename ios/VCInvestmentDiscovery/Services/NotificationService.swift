import Foundation
import UserNotifications
import Combine

enum NotificationError: Error {
    case registrationFailed, deliveryFailed, invalidPayload
}

@MainActor
class NotificationService: ObservableObject {
    private let apiService: APIService
    private let userDefaults: UserDefaults
    @Published private(set) var notifications: [Notification] = []
    private var cancellables = Set<AnyCancellable>()

    init(apiService: APIService, userDefaults: UserDefaults = .standard) {
        self.apiService = apiService
        self.userDefaults = userDefaults
        setupNotifications()
    }

    func setupNotifications() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
            if granted {
                DispatchQueue.main.async {
                    UIApplication.shared.registerForRemoteNotifications()
                }
            } else if let error = error {
                print("Error requesting notification authorization: \(error.localizedDescription)")
            }
        }

        // Configure notification categories and actions here
        // Example:
        // let viewAction = UNNotificationAction(identifier: "VIEW_ACTION", title: "View", options: .foreground)
        // let category = UNNotificationCategory(identifier: "GENERAL", actions: [viewAction], intentIdentifiers: [], options: [])
        // UNUserNotificationCenter.current().setNotificationCategories([category])
    }

    func registerDeviceToken(_ deviceToken: Data) -> AnyPublisher<Void, NotificationError> {
        let tokenString = deviceToken.map { String(format: "%02.2hhx", $0) }.joined()
        
        return apiService.post(endpoint: "notifications/register", body: ["token": tokenString])
            .mapError { _ in NotificationError.registrationFailed }
            .map { _ in () }
            .eraseToAnyPublisher()
    }

    func handleReceivedNotification(userInfo: [AnyHashable: Any]) {
        guard let notificationData = try? JSONSerialization.data(withJSONObject: userInfo),
              let notification = try? JSONDecoder().decode(Notification.self, from: notificationData) else {
            print("Failed to parse notification data")
            return
        }

        DispatchQueue.main.async {
            self.notifications.append(notification)
        }

        if UIApplication.shared.applicationState == .background {
            let content = UNMutableNotificationContent()
            content.title = notification.title
            content.body = notification.message
            
            let request = UNNotificationRequest(identifier: notification.id, content: content, trigger: nil)
            UNUserNotificationCenter.current().add(request)
        }

        // Update server that notification has been received
        apiService.post(endpoint: "notifications/received", body: ["id": notification.id])
            .sink(receiveCompletion: { _ in }, receiveValue: { _ in })
            .store(in: &cancellables)
    }

    func scheduleLocalNotification(notification: Notification, deliveryDate: Date) -> AnyPublisher<Void, NotificationError> {
        return Future<Void, NotificationError> { promise in
            let content = UNMutableNotificationContent()
            content.title = notification.title
            content.body = notification.message

            let triggerDate = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute, .second], from: deliveryDate)
            let trigger = UNCalendarNotificationTrigger(dateMatching: triggerDate, repeats: false)

            let request = UNNotificationRequest(identifier: notification.id, content: content, trigger: trigger)

            UNUserNotificationCenter.current().add(request) { error in
                if let error = error {
                    promise(.failure(.deliveryFailed))
                } else {
                    promise(.success(()))
                }
            }
        }.eraseToAnyPublisher()
    }

    func cancelNotification(notificationId: String) {
        notifications.removeAll { $0.id == notificationId }
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [notificationId])
        
        apiService.post(endpoint: "notifications/cancel", body: ["id": notificationId])
            .sink(receiveCompletion: { _ in }, receiveValue: { _ in })
            .store(in: &cancellables)
    }

    func markNotificationAsRead(notificationId: String) -> AnyPublisher<Void, NotificationError> {
        if let index = notifications.firstIndex(where: { $0.id == notificationId }) {
            notifications[index].isRead = true
        }

        return apiService.post(endpoint: "notifications/read", body: ["id": notificationId])
            .mapError { _ in NotificationError.deliveryFailed }
            .map { _ in () }
            .eraseToAnyPublisher()
    }
}