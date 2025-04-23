//
//  TodoRepository.swift
//  CleanEx
//
//  Created by 최범수 on 2025-04-23.
//

import Foundation

protocol TodoRepository {
    func getAllTodos() async -> [Todo]
    func getTodo(id: UUID) async -> Todo?
    func createTodo(_ todo: Todo) async
    func updateTodo(_ todo: Todo) async
    func deleteTodo(id: UUID) async
}

// 모든 메서드는 비동기 처리를 위해서. async 키워드를 가져야 함.
// The reason is it could be heavy work?
// method name should be neat and clear
