import Foundation

struct TodoDTO: Codable {
    let id: UUID
    let title: String
    let description: String?
    let isCompleted: Bool
    let priority: Int
    let dueDate: Date?
    let createdAt: Date
    let updatedAt: Date
}

extension TodoDTO {
    func toDomain() -> Todo {
        let mappedPriority = TodoPriority(rawValue: priority) ?? .medium
        return Todo(
            id: id,
            title: title,
            description: description,
            isCompleted: isCompleted,
            priority: mappedPriority,
            dueDate: dueDate,
            createdAt: createdAt,
            updatedAt: updatedAt
        )
    }
    
    static func fromEntity(_ entity: Todo) -> TodoDTO {
        return TodoDTO(
            id: entity.id,
            title: entity.title,
            description: entity.description,
            isCompleted: entity.isCompleted,
            priority: entity.priority.rawValue,
            dueDate: entity.dueDate,
            createdAt: entity.createdAt,
            updatedAt: entity.updatedAt
        )
    }
}
