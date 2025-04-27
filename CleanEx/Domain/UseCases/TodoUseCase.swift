import Foundation

protocol GetAllTodosUseCase {
    func execute() async throws -> [Todo]
}

struct GetAllTodosUseCaseImpl: GetAllTodosUseCase {
    private let repository: TodoRepository
    
    init(repository: TodoRepository) {
        self.repository = repository
    }
    
    func execute() async throws -> [Todo] {
        return try await repository.getAllTodos()
    }
}

protocol GetTodoUseCase {
    func execute(id: UUID) async throws -> Todo
}

struct GetTodoUseCaseImpl: GetTodoUseCase {
    private let repository: TodoRepository
    
    init(repository: TodoRepository) {
        self.repository = repository
    }
    
    func execute(id: UUID) async throws -> Todo {
        return try await repository.getTodo(id: id)
    }
}

protocol AddTodoUseCase {
    func execute(
        id: UUID,
        title: String,
        description: String?,
        isCompleted: Bool,
        createdAt: Date,
        updatedAt: Date
    ) async throws -> Todo
}

struct AddTodoUseCaseImpl: AddTodoUseCase {
    private let repository: TodoRepository
    
    init(repository: TodoRepository) {
        self.repository = repository
    }
    
    func execute(
        id: UUID = UUID(),
        title: String,
        description: String? = nil,
        isCompleted: Bool = false,
        createdAt: Date = Date(),
        updatedAt: Date = Date()
    ) async throws -> Todo {
        let newTodo = Todo(
            id: id,
            title: title,
            description: description,
            isCompleted: isCompleted,
            createdAt: createdAt,
            updatedAt: updatedAt
        )
        return try await repository.addTodo(todo: newTodo)
    }
}

protocol UpdateTodoUseCase {
    func execute(
        id: UUID,
        title: String,
        description: String?,
        isCompleted: Bool,
        createdAt: Date,
        updatedAt: Date
    ) async throws -> Todo
}

struct UpdateTodoUseCaseImpl: UpdateTodoUseCase {
    private let repository: TodoRepository
    
    init(repository: TodoRepository) {
        self.repository = repository
    }
    
    func execute(
        id: UUID,
        title: String,
        description: String?,
        isCompleted: Bool,
        createdAt: Date,
        updatedAt: Date
    ) async throws -> Todo {
        let todoToUpdate = Todo(
            id: id,
            title: title,
            description: description,
            isCompleted: isCompleted,
            createdAt: createdAt,
            updatedAt: updatedAt
        )
        return try await repository.updateTodo(todo: todoToUpdate)
    }
}

protocol DeleteTodoUseCase {
    func execute(id: UUID) async throws
}

struct DeleteTodoUseCaseImpl: DeleteTodoUseCase {
    private let repository: TodoRepository
    
    init(repository: TodoRepository) {
        self.repository = repository
    }
    
    func execute(id: UUID) async throws {
        try await repository.deleteTodo(id: id)
    }
}
