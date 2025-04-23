//
//  TodoDTO.swift
//  CleanEx
//
//  Created by 최범수 on 2025-04-23.
//

import Foundation

protocol TodoDTOConvertible {
    // DTO. 즉 데이터를 받아오는 그릇에서 다시 엔티티 모델로 변환.
    func toEntity() -> Todo
    // 엔티티에서 다시 데이터 송신을 위해 DTO로 변환.
    static func fromEntity(_ todo: Todo) -> Self
}

struct TodoDTO: Codable, TodoDTOConvertible {
    let id: UUID
    let title: String
    let description: String?
    let isCompleted: Bool
    let createdAt: Date
    let updatedAt: Date
    
    static func fromEntity(_ todo: Todo) -> TodoDTO {
        
        return TodoDTO(
            id: todo.id,
            title: todo.title,
            description: todo.description,
            isCompleted: todo.isCompleted,
            createdAt: todo.createdAt,
            updatedAt: todo.updatedAt
        )
    }
    
    func toEntity() -> Todo {
        
        return Todo(
            id: self.id,
            title: self.title,
            description: self.description,
            isCompleted: self.isCompleted,
            createdAt: self.createdAt,
            updatedAt: self.updatedAt
        )
    }

}
