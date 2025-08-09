import Foundation

public enum TodoPriority: Int, CaseIterable {
    case low = 0
    case medium = 1
    case high = 2
}

public struct Todo {
    public let id: UUID
    public var title: String
    public var description: String?
    public var isCompleted: Bool
    public var priority: TodoPriority
    public var dueDate: Date?
    public let createdAt: Date
    public var updatedAt: Date

    public init(
        id: UUID = UUID(),
        title: String,
        description: String? = nil,
        isCompleted: Bool = false,
        priority: TodoPriority = .medium,
        dueDate: Date? = nil,
        createdAt: Date = Date(),
        updatedAt: Date = Date()
    ) {
        self.id = id
        self.title = title
        self.description = description
        self.isCompleted = isCompleted
        self.priority = priority
        self.dueDate = dueDate
        self.createdAt = createdAt
        self.updatedAt = updatedAt
    }
}
