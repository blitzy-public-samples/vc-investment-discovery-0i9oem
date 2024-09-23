import Foundation
import SwiftUI
import Combine

// MARK: - String Extensions
extension String {
    func isValidEmail() -> Bool {
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPredicate = NSPredicate(format: "SELF MATCHES %@", emailRegex)
        return emailPredicate.evaluate(with: self)
    }
    
    func truncate(length: Int, suffix: String = "...") -> String {
        if self.count > length {
            return String(self.prefix(length)) + suffix
        } else {
            return self
        }
    }
}

// MARK: - Date Extensions
extension Date {
    func formattedString(format: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        return dateFormatter.string(from: self)
    }
    
    func timeAgoString() -> String {
        let calendar = Calendar.current
        let now = Date()
        let components = calendar.dateComponents([.year, .month, .day, .hour, .minute, .second], from: self, to: now)
        
        if let years = components.year, years > 0 {
            return "\(years) year\(years == 1 ? "" : "s") ago"
        } else if let months = components.month, months > 0 {
            return "\(months) month\(months == 1 ? "" : "s") ago"
        } else if let days = components.day, days > 0 {
            return "\(days) day\(days == 1 ? "" : "s") ago"
        } else if let hours = components.hour, hours > 0 {
            return "\(hours) hour\(hours == 1 ? "" : "s") ago"
        } else if let minutes = components.minute, minutes > 0 {
            return "\(minutes) minute\(minutes == 1 ? "" : "s") ago"
        } else {
            return "Just now"
        }
    }
}

// MARK: - Double Extensions
extension Double {
    func currencyFormatted() -> String {
        return Constants.NumberFormats.currencyFormatter.string(from: NSNumber(value: self)) ?? ""
    }
    
    func percentFormatted() -> String {
        return Constants.NumberFormats.percentFormatter.string(from: NSNumber(value: self)) ?? ""
    }
}

// MARK: - View Extensions
extension View {
    func cornerRadius(_ radius: CGFloat, corners: UIRectCorner = .allCorners) -> some View {
        clipShape(RoundedCorner(radius: radius, corners: corners))
    }
    
    func placeholder<Content: View>(
        when shouldShow: Bool,
        alignment: Alignment = .leading,
        @ViewBuilder placeholder: () -> Content) -> some View {
        
        ZStack(alignment: alignment) {
            placeholder().opacity(shouldShow ? 1 : 0)
            self
        }
    }
}

// MARK: - Publisher Extensions
extension Publisher {
    func sinkToResult(_ completion: @escaping (Result<Output, Failure>) -> Void) -> AnyCancellable {
        return sink(
            receiveCompletion: { subscriptionCompletion in
                switch subscriptionCompletion {
                case .finished:
                    break
                case .failure(let error):
                    completion(.failure(error))
                }
            },
            receiveValue: { value in
                completion(.success(value))
            }
        )
    }
}

// MARK: - Helper Structs
struct RoundedCorner: Shape {
    var radius: CGFloat = .infinity
    var corners: UIRectCorner = .allCorners

    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(roundedRect: rect, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        return Path(path.cgPath)
    }
}