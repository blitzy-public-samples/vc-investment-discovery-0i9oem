import Foundation
import SwiftUI
import Combine

struct Helpers {
    static func formatCurrency(_ value: Double, currencyCode: String = "USD") -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.currencyCode = currencyCode
        return formatter.string(from: NSNumber(value: value)) ?? "$0.00"
    }
    
    static func calculateROI(initialInvestment: Double, currentValue: Double) -> Double {
        let gain = currentValue - initialInvestment
        return (gain / initialInvestment) * 100
    }
    
    static func generateRandomColor() -> Color {
        let red = Double.random(in: 0...1)
        let green = Double.random(in: 0...1)
        let blue = Double.random(in: 0...1)
        return Color(red: red, green: green, blue: blue)
    }
    
    static func debounce(delay: TimeInterval, action: @escaping () -> Void) -> () -> Void {
        var workItem: DispatchWorkItem?
        return {
            workItem?.cancel()
            workItem = DispatchWorkItem { action() }
            DispatchQueue.main.asyncAfter(deadline: .now() + delay, execute: workItem!)
        }
    }
    
    static func loadJSONFromFile<T: Decodable>(_ filename: String) -> T? {
        guard let url = Bundle.main.url(forResource: filename, withExtension: "json") else {
            print("Failed to locate \(filename) in bundle.")
            return nil
        }
        
        do {
            let data = try Data(contentsOf: url)
            let decoder = JSONDecoder()
            return try decoder.decode(T.self, from: data)
        } catch {
            print("Error decoding JSON: \(error)")
            return nil
        }
    }
}