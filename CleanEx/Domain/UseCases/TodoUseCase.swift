//
//  TodoUseCase.swift
//  CleanEx
//
//  Created by 최범수 on 2025-04-23.
//

import Foundation

// Read
protocol GetAllTodoUseCase {
    func getAllTodo() async throws -> [Todo]
}

struct GetAllTodoUseCaseImpl: GetAllTodoUseCase {
    private let todoRepository: TodoRepository
    
    init(todoRepository: TodoRepository) {
        self.todoRepository = todoRepository
    }
    
    func getAllTodo() async throws -> [Todo] {
        
        return try await todoRepository.getAllTodos()
    }
}

protocol GetTodoUseCase {
    func getTodo(id: UUID) async throws -> Todo
}

struct GetTodoUseCaseImpl: GetTodoUseCase {
    private let todoRepository: TodoRepository
    
    init(todoRepository: TodoRepository) {
        self.todoRepository = todoRepository
    }
    
    func getTodo(id: UUID) async throws -> Todo {
        return try await todoRepository.getTodo(id: id)
    }
}

// Create
protocol AddTodoUseCase {
    func addTodo(_ todo: Todo) async throws
}

struct AddTodoUseCaseImpl: AddTodoUseCase {
    private let todoRepository: TodoRepository
    
    init(todoRepository: TodoRepository) {
        self.todoRepository = todoRepository
    }
    
    func addTodo(_ todo: Todo) async throws {
        try await todoRepository.createTodo(todo)
    }
}

// Update
protocol UpdateTodoUseCase {
    func updateTodo(_ todo: Todo) async throws
}

struct UpdateTodoUseCaseImpl: UpdateTodoUseCase {
    private let todoRepository: TodoRepository
    
    init(todoRepository: TodoRepository) {
        self.todoRepository = todoRepository
    }
    
    func updateTodo(_ todo: Todo) async throws {
        try await todoRepository.updateTodo(todo)
    }
}

// Delete
protocol DeleteTodoUseCase {
    func deleteTodo(id: UUID) async throws
}

struct DeleteTodoUseCaseImpl: DeleteTodoUseCase {
    let todoRepository: TodoRepository
    
    init(todoRepository: TodoRepository) {
        self.todoRepository = todoRepository
    }
    
    func deleteTodo(id: UUID) async throws {
        try await todoRepository.deleteTodo(id: id)
    }
}
