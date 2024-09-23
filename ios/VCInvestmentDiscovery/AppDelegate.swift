import UIKit
import UserNotifications

@main
class AppDelegate: UIResponder, UIApplicationDelegate, UNUserNotificationCenterDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Set up the UNUserNotificationCenter delegate
        UNUserNotificationCenter.current().delegate = self
        
        // Request authorization for push notifications
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
            if let error = error {
                // TODO: Implement proper error handling for notification authorization
                print("Error requesting notification authorization: \(error.localizedDescription)")
            }
            
            if granted {
                DispatchQueue.main.async {
                    // Register for remote notifications
                    UIApplication.shared.registerForRemoteNotifications()
                }
            }
        }
        
        // Set up any necessary app configurations
        // TODO: Add any app-specific configurations or third-party SDK initializations
        
        return true
    }

    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        // Convert device token to a string
        let tokenParts = deviceToken.map { data in String(format: "%02.2hhx", data) }
        let token = tokenParts.joined()
        
        // TODO: Implement the logic to send the device token to the backend server
        print("Device Token: \(token)")
    }

    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        // Log the error
        print("Failed to register for remote notifications: \(error.localizedDescription)")
        
        // TODO: Implement proper error logging mechanism
        
        // Handle the failure gracefully
        // TODO: Define a strategy for handling push notification registration failures
    }
}