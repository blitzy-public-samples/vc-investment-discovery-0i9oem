import Foundation

struct Alert: Codable, Identifiable {
    let id: UUID
    let userId: UUID
    let type: AlertType
    let title: String
    let message: String
    let createdAt: Date
    var isRead: Bool
    let relatedEntityId: UUID?
    let priority: AlertPriority
    
    init(id: UUID, userId: UUID, type: AlertType, title: String, message: String, createdAt: Date, isRead: Bool, relatedEntityId: UUID?, priority: AlertPriority) {
        self.id = id
        self.userId = userId
        self.type = type
        self.title = title
        self.message = message
        self.createdAt = createdAt
        self.isRead = isRead
        self.relatedEntityId = relatedEntityId
        self.priority = priority
    }
    
    mutating func markAsRead() {
        isRead = true
    }
    
    func isExpired(expirationInterval: TimeInterval) -> Bool {
        let timeDifference = Date().timeIntervalSince(createdAt)
        return timeDifference > expirationInterval
    }
}

extension Alert {
    enum CodingKeys: String, CodingKey {
        case id, userId, type, title, message, createdAt, isRead, relatedEntityId, priority
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(userId, forKey: .userId)
        try container.encode(type, forKey: .type)
        try container.encode(title, forKey: .title)
        try container.encode(message, forKey: .message)
        try container.encode(createdAt, forKey: .createdAt)
        try container.encode(isRead, forKey: .isRead)
        try container.encode(relatedEntityId, forKey: .relatedEntityId)
        try container.encode(priority, forKey: .priority)
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(UUID.self, forKey: .id)
        userId = try container.decode(UUID.self, forKey: .userId)
        type = try container.decode(AlertType.self, forKey: .type)
        title = try container.decode(String.self, forKey: .title)
        message = try container.decode(String.self, forKey: .message)
        createdAt = try container.decode(Date.self, forKey: .createdAt)
        isRead = try container.decode(Bool.self, forKey: .isRead)
        relatedEntityId = try container.decodeIfPresent(UUID.self, forKey: .relatedEntityId)
        priority = try container.decode(AlertPriority.self, forKey: .priority)
    }
}