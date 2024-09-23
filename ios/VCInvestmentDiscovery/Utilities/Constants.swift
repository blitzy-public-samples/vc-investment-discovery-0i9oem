import Foundation

struct Constants {
    struct API {
        static let baseURL = "https://api.vcinvestmentdiscovery.com"
        static let version = "v1"
        static let timeout: TimeInterval = 30
    }
    
    struct UserDefaults {
        static let userToken = "userToken"
        static let lastSyncTimestamp = "lastSyncTimestamp"
        static let userPreferences = "userPreferences"
    }
    
    struct Notifications {
        static let newInvestmentOpportunity = "newInvestmentOpportunityNotification"
        static let portfolioUpdate = "portfolioUpdateNotification"
        static let marketAlert = "marketAlertNotification"
    }
    
    struct DateFormats {
        static let iso8601 = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        static let displayDate = "MMM d, yyyy"
        static let displayDateTime = "MMM d, yyyy HH:mm"
    }
    
    struct NumberFormats {
        static let currencyFormatter: NumberFormatter = {
            let formatter = NumberFormatter()
            formatter.numberStyle = .currency
            formatter.currencyCode = "USD"
            return formatter
        }()
        
        static let percentFormatter: NumberFormatter = {
            let formatter = NumberFormatter()
            formatter.numberStyle = .percent
            formatter.minimumFractionDigits = 2
            formatter.maximumFractionDigits = 2
            return formatter
        }()
    }
    
    struct UI {
        static let cornerRadius: CGFloat = 8
        static let animationDuration: TimeInterval = 0.3
        static let defaultPadding: CGFloat = 16
    }
    
    struct ErrorMessages {
        static let networkError = "Network error. Please check your connection and try again."
        static let authenticationFailed = "Authentication failed. Please log in again."
        static let dataLoadFailed = "Failed to load data. Please try again."
    }
}