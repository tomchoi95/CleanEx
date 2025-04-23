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
    func updateTodo(id: UUID, title: String?, description: String?, isCompleted: Bool?) async throws
}

struct UpdateTodoUseCaseImpl: UpdateTodoUseCase {
    private let todoRepository: TodoRepository
    
    init(todoRepository: TodoRepository) {
        self.todoRepository = todoRepository
    }
    
    func updateTodo(id: UUID, title: String?, description: String?, isCompleted: Bool?) async throws {
        let existingTodo = try await todoRepository.getTodo(id: id)
        let updatedTodo = Todo(
            title: title ?? existingTodo.title,
            description: description ?? existingTodo.description,
            isCompleted: isCompleted ?? existingTodo.isCompleted,
            createdAt: existingTodo.createdAt,
            updatedAt: Date()
        )
        try await todoRepository.updateTodo(updatedTodo)
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
 MARK: AddTodo 로직의 피드백
 
 AddTodo에서 Entity에 description이 있는데, 이를 작성하는 부분이 누락되었음.
 UseCase에서 이 부분에 대한 로직을 추가해야함.
 레파지토리로 보내는 중간에 Todo 객체를 생성하고, 그 생성된 객체를 레파지토리에 보낼거임
 하지만 레파지토리는 그 중간 과정을 모르게 해야 하고. 그 중간 과정은 여기서(UseCase)에서 처리될 것.
 
 MARK: Update 로직의 피드백
 
 중간 과정의 로직이 생략됨.
 레파지토리에서 id로 불러오기 -> 불러온 Todo의 내용 고치지 -> 다시 레파지토리에서 저장하기.
 중간에 변환하는? 교환하는? 로직이 중요한 것 같다.
 업데이트하지 않을 시, 이미 존재하는 데이터를 그대로 사용하는 부분.
 */
