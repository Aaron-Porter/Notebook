import Foundation

public struct Note: Identifiable, Codable, Equatable {
    public let id: UUID
    public var title: String
    public var content: String
    public var createdAt: Date
    public var updatedAt: Date

    public init(
        id: UUID = UUID(),
        title: String,
        content: String,
        createdAt: Date = Date(),
        updatedAt: Date = Date()
    ) {
        self.id = id
        self.title = title
        self.content = content
        self.createdAt = createdAt
        self.updatedAt = updatedAt
    }

    public mutating func apply(title: String? = nil, content: String? = nil) {
        if let title {
            self.title = title
        }
        if let content {
            self.content = content
        }
        updatedAt = Date()
    }
}
