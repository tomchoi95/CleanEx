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
    func addTodo(title: String, description: String?) async throws
}

struct AddTodoUseCaseImpl: AddTodoUseCase {
    private let todoRepository: TodoRepository
    
    init(todoRepository: TodoRepository) {
        self.todoRepository = todoRepository
    }
    
    func addTodo(title: String, description: String?) async throws {
        let todo = Todo(title: title, description: description)
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

/*
 AddTodo에서 Entity에 description이 있는데, 이를 작성하는 부분이 누락되었음.
 UseCase에서 이 부분에 대한 로직을 추가해야함.
 레파지토리로 보내는 중간에 Todo 객체를 생성하고, 그 생성된 객체를 레파지토리에 보낼거임
 하지만 레파지토리는 그 중간 과정을 모르게 해야 하고. 그 중간 과정은 여기서(UseCase)에서 처리될 것.
 
 */
