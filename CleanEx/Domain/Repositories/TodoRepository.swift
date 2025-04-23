//
//  TodoRepository.swift
//  CleanEx
//
//  Created by 최범수 on 2025-04-23.
//

import Foundation

protocol TodoRepository {
    func getAllTodos() -> [Todo]
    func getTodo(id: UUID) -> Todo?
    func createTodo(_ todo: Todo)
    func updateTodo(_ todo: Todo)
    func deleteTodo(id: UUID)
}
