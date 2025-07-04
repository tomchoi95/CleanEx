import Foundation
import SwiftData

protocol TodoLocalDataSource {
    func getAllTodos() async throws -> [TodoDTO]
    func getTodo(id: UUID) async throws -> TodoDTO
    func addTodo(_ todo: TodoDTO) async throws -> TodoDTO
    func updateTodo(_ todo: TodoDTO) async throws -> TodoDTO
    func deleteTodo(id: UUID) async throws
}

struct TodoLocalDataSourceImpl: TodoLocalDataSource {
    private let modelContext: ModelContext
    
    init(modelContext: ModelContext) {
        self.modelContext = modelContext
    }
    
    func getAllTodos() async throws -> [TodoDTO] {
        let descriptor = FetchDescriptor<TodoLocalModel>(
            sortBy: [SortDescriptor<TodoLocalModel>(\.createdAt, order: .reverse)]
        )
        let todos = try modelContext.fetch(descriptor)
        return todos.map {
            TodoDTO(
                id: $0.id,
                title: $0.title ,
                description: $0.todoDescription,
                isCompleted: $0.isCompleted,
                categoryId: $0.categoryId,
                priority: $0.priority,
                createdAt: $0.createdAt,
                updatedAt: $0.updatedAt
            )
        }
    }
    
    func getTodo(id: UUID) async throws -> TodoDTO {
        let descriptor = FetchDescriptor<TodoLocalModel>(
            predicate: #Predicate { $0.id == id }
        )
        guard let todo = try modelContext.fetch(descriptor).first else { throw LocalDataSourceError.notFound }
        return TodoDTO(
            id: todo.id,
            title: todo.title,
            description: todo.todoDescription,
            isCompleted: todo.isCompleted,
            categoryId: todo.categoryId,
            priority: todo.priority,
            createdAt: todo.createdAt,
            updatedAt: todo.updatedAt
        )
    }
    
    func addTodo(_ todo: TodoDTO) async throws -> TodoDTO {
        let model = TodoLocalModel(
            id: todo.id,
            title: todo.title,
            todoDescription: todo.description,
            isCompleted: todo.isCompleted,
            categoryId: todo.categoryId,
            priority: todo.priority,
            createdAt: todo.createdAt,
            updatedAt: todo.updatedAt
        )
        modelContext.insert(model)
        do {
            try modelContext.save()
        } catch {
            throw LocalDataSourceError.saveFailed
        }
        return todo
    }
    
    func updateTodo(_ todo: TodoDTO) async throws -> TodoDTO {
        let descriptor = FetchDescriptor<TodoLocalModel>(
            predicate: #Predicate { $0.id == todo.id }
        )
        guard let todoModel = try modelContext.fetch(descriptor).first else { throw LocalDataSourceError.notFound }
        todoModel.title = todo.title
        todoModel.todoDescription = todo.description
        todoModel.isCompleted = todo.isCompleted
        todoModel.categoryId = todo.categoryId
        todoModel.priority = todo.priority
        todoModel.updatedAt = Date()
        do {
            try modelContext.save()
        } catch {
            throw LocalDataSourceError.saveFailed
        }
        return TodoDTO(
            id: todoModel.id,
            title: todoModel.title,
            description: todoModel.todoDescription,
            isCompleted: todoModel.isCompleted,
            createdAt: todoModel.createdAt,
            updatedAt: todoModel.updatedAt
        )
    }
    
    func deleteTodo(id: UUID) async throws {
        let descriptor = FetchDescriptor<TodoLocalModel>(
            predicate: #Predicate { $0.id == id }
        )
        guard let todoModel = try modelContext.fetch(descriptor).first else { throw LocalDataSourceError.notFound }
        modelContext.delete(todoModel)
        do {
            try modelContext.save()
        } catch {
            throw LocalDataSourceError.deleteFailed
        }
    }
}

enum LocalDataSourceError: Error {
    case notFound
    case saveFailed
    case deleteFailed
}
