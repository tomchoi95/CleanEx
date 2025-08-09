import Foundation

enum TodoPriority: Int, CaseIterable {
    case low = 0
    case medium = 1
    case high = 2
}

struct Todo {
    let id: UUID
    var title: String
    var description: String?
    var isCompleted: Bool
    var priority: TodoPriority
    var dueDate: Date?
    let createdAt: Date
    var updatedAt: Date

    init(
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
