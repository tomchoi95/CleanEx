import Foundation
import SwiftData

@Model
final class TodoLocalModel {
    var id: UUID
    var title: String
    var todoDescription: String?
    var isCompleted: Bool
    var createdAt: Date
    var updatedAt: Date
    
    init(
        id: UUID = UUID(),
        title: String,
        todoDescription: String? = nil,
        isCompleted: Bool = false,
        createdAt: Date = Date(),
        updatedAt: Date = Date()
    ) {
        self.id = id
        self.title = title
        self.todoDescription = todoDescription
        self.isCompleted = isCompleted
        self.createdAt = createdAt
        self.updatedAt = updatedAt
    }
}
