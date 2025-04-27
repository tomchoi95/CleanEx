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
    func execute(with todo: Todo) async throws -> Todo
}

struct AddTodoUseCaseImpl: AddTodoUseCase {
    private let repository: TodoRepository
    
    init(repository: TodoRepository) {
        self.repository = repository
    }
    
    func execute(with todo: Todo) async throws -> Todo {
        return try await repository.addTodo(todo: todo)
    }
}

protocol UpdateTodoUseCase {
    func execute(with todo: Todo) async throws -> Todo
}

struct UpdateTodoUseCaseImpl: UpdateTodoUseCase {
    private let repository: TodoRepository
    
    init(repository: TodoRepository) {
        self.repository = repository
    }
    
    func execute(with todo: Todo) async throws -> Todo {
        return try await repository.updateTodo(todo: todo)
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
