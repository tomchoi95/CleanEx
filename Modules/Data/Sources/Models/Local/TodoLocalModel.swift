import Foundation
import SwiftData
import Domain

@Model
public final class TodoLocalModel {
    public var id: UUID
    public var title: String
    public var todoDescription: String?
    public var isCompleted: Bool
    public var priority: Int
    public var dueDate: Date?
    public var createdAt: Date
    public var updatedAt: Date
    
    public init(
        id: UUID = UUID(),
        title: String,
        todoDescription: String? = nil,
        isCompleted: Bool = false,
        priority: Int = TodoPriority.medium.rawValue,
        dueDate: Date? = nil,
        createdAt: Date = Date(),
        updatedAt: Date = Date()
    ) {
        self.id = id
        self.title = title
        self.todoDescription = todoDescription
        self.isCompleted = isCompleted
        self.priority = priority
        self.dueDate = dueDate
        self.createdAt = createdAt
        self.updatedAt = updatedAt
    }
}
