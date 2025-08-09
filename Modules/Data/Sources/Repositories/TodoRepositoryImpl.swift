import Foundation
import Domain

public struct TodoRepositoryImpl: TodoRepository {
    private let dataSource: TodoLocalDataSource
    
    public init(dataSource: TodoLocalDataSource) {
        self.dataSource = dataSource
    }
    
    public func getAllTodos() async throws -> [Todo] {
        let dtos = try await dataSource.getAllTodos()
        return dtos.map { $0.toDomain() }
    }
    
    public func getTodo(id: UUID) async throws -> Todo {
        let dto = try await dataSource.getTodo(id: id)
        return dto.toDomain()
    }
    
    public func addTodo(todo: Todo) async throws -> Todo {
        let dto = TodoDTO.fromEntity(todo)
        let createdDto = try await dataSource.addTodo(dto)
        return createdDto.toDomain()
    }
    
    public func updateTodo(todo: Todo) async throws -> Todo {
        let dto = TodoDTO.fromEntity(todo)
        let updatedTodo = try await dataSource.updateTodo(dto)
        return updatedTodo.toDomain()
    }
    
    public func deleteTodo(id: UUID) async throws {
        try await dataSource.deleteTodo(id: id)
    }
}
