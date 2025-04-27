import Foundation

struct TodoDTO: Codable {
    let id: UUID
    let title: String
    let description: String?
    let isCompleted: Bool
    let createdAt: Date
    let updatedAt: Date
}

extension TodoDTO {
    func toDomain() -> Todo {
        return Todo(
            id: id,
            title: title,
            description: description,
            isCompleted: isCompleted,
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
            createdAt: entity.createdAt,
            updatedAt: entity.updatedAt
        )
    }
}
