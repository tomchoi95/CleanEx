import Foundation

// 통합 TodoUseCase 프로토콜
public protocol TodoUseCaseProtocol {
    func getAllTodos() async throws -> [Todo]
    func getTodo(id: UUID) async throws -> Todo
    func addTodo(todo: Todo) async throws -> Todo
    func updateTodo(todo: Todo) async throws -> Todo
    func deleteTodo(id: UUID) async throws
}

// 기본 구현
public struct TodoUseCaseImpl: TodoUseCaseProtocol {
    private let repository: TodoRepository
    
    public init(repository: TodoRepository) {
        self.repository = repository
    }
    
    public func getAllTodos() async throws -> [Todo] {
        return try await repository.getAllTodos()
    }
    
    public func getTodo(id: UUID) async throws -> Todo {
        return try await repository.getTodo(id: id)
    }
    
    public func addTodo(todo: Todo) async throws -> Todo {
        return try await repository.addTodo(todo: todo)
    }
    
    public func updateTodo(todo: Todo) async throws -> Todo {
        return try await repository.updateTodo(todo: todo)
    }
    
    public func deleteTodo(id: UUID) async throws {
        try await repository.deleteTodo(id: id)
    }
}
