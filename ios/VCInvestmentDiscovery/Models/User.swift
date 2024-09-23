import Foundation

struct User: Codable {
    let id: UUID
    let email: String
    let firstName: String
    let lastName: String
    let dateJoined: Date
    let preferences: UserPreferences
    let portfolios: [Portfolio]
    
    init(id: UUID, email: String, firstName: String, lastName: String, dateJoined: Date, preferences: UserPreferences, portfolios: [Portfolio]) {
        self.id = id
        self.email = email
        self.firstName = firstName
        self.lastName = lastName
        self.dateJoined = dateJoined
        self.preferences = preferences
        self.portfolios = portfolios
    }
    
    var fullName: String {
        return "\(firstName) \(lastName)"
    }
    
    func totalPortfolioValue() -> Double {
        return portfolios.reduce(0) { $0 + $1.totalValue }
    }
}

extension User {
    enum CodingKeys: String, CodingKey {
        case id, email, firstName, lastName, dateJoined, preferences, portfolios
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(email, forKey: .email)
        try container.encode(firstName, forKey: .firstName)
        try container.encode(lastName, forKey: .lastName)
        try container.encode(dateJoined, forKey: .dateJoined)
        try container.encode(preferences, forKey: .preferences)
        try container.encode(portfolios, forKey: .portfolios)
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(UUID.self, forKey: .id)
        email = try container.decode(String.self, forKey: .email)
        firstName = try container.decode(String.self, forKey: .firstName)
        lastName = try container.decode(String.self, forKey: .lastName)
        dateJoined = try container.decode(Date.self, forKey: .dateJoined)
        preferences = try container.decode(UserPreferences.self, forKey: .preferences)
        portfolios = try container.decode([Portfolio].self, forKey: .portfolios)
    }
}