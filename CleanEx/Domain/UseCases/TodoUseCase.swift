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
        title: String,
        description: String?,
    ) async throws -> Todo
}

struct AddTodoUseCaseImpl: AddTodoUseCase {
    private let repository: TodoRepository
    
    init(repository: TodoRepository) {
        self.repository = repository
    }
    
    func execute(
        title: String,
        description: String? = nil,
    ) async throws -> Todo {
        let newTodo = Todo(title: title, description: description)
        return try await repository.addTodo(todo: newTodo)
    }
}

protocol UpdateTodoUseCase {
    func execute(
        id: UUID,
        title: String?,
        description: String?,
        isCompleted: Bool?,
    ) async throws -> Todo
}

struct UpdateTodoUseCaseImpl: UpdateTodoUseCase {
    private let repository: TodoRepository
    
    init(repository: TodoRepository) {
        self.repository = repository
    }
    
    func execute(
        id: UUID,
        title: String?,
        description: String?,
        isCompleted: Bool?,
    ) async throws -> Todo {
        let todo = try await repository.getTodo(id: id)
        
        let todoToUpdate = Todo(
            id: todo.id,
            title: title ?? todo.title,
            description: description ?? todo.description,
            isCompleted: isCompleted ?? todo.isCompleted,
            createdAt: todo.createdAt,
            updatedAt: Date()
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
