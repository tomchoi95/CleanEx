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
        priority: TodoPriority,
        dueDate: Date?
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
        priority: TodoPriority = .medium,
        dueDate: Date? = nil
    ) async throws -> Todo {
        let newTodo = Todo(title: title, description: description, isCompleted: false, priority: priority, dueDate: dueDate)
        return try await repository.addTodo(todo: newTodo)
    }
}

protocol UpdateTodoUseCase {
    func execute(
        id: UUID,
        title: String?,
        description: String?,
        isCompleted: Bool?,
        priority: TodoPriority?,
        dueDate: Date?
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
        priority: TodoPriority?,
        dueDate: Date?
    ) async throws -> Todo {
        let todo = try await repository.getTodo(id: id)
        
        let todoToUpdate = Todo(
            id: todo.id,
            title: title ?? todo.title,
            description: description ?? todo.description,
            isCompleted: isCompleted ?? todo.isCompleted,
            priority: priority ?? todo.priority,
            dueDate: dueDate ?? todo.dueDate,
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

protocol ToggleTodoCompletionUseCase {
    func execute(id: UUID) async throws -> Todo
}

struct ToggleTodoCompletionUseCaseImpl: ToggleTodoCompletionUseCase {
    private let repository: TodoRepository
    
    init(repository: TodoRepository) {
        self.repository = repository
    }
    
    func execute(id: UUID) async throws -> Todo {
        let todo = try await repository.getTodo(id: id)
        let toggled = Todo(
            id: todo.id,
            title: todo.title,
            description: todo.description,
            isCompleted: !todo.isCompleted,
            priority: todo.priority,
            dueDate: todo.dueDate,
            createdAt: todo.createdAt,
            updatedAt: Date()
        )
        return try await repository.updateTodo(todo: toggled)
    }
}

struct TodoSearchCriteria {
    let query: String?
    let isCompleted: Bool?
    let priority: TodoPriority?
}

protocol SearchTodosUseCase {
    func execute(criteria: TodoSearchCriteria) async throws -> [Todo]
}

struct SearchTodosUseCaseImpl: SearchTodosUseCase {
    private let repository: TodoRepository
    
    init(repository: TodoRepository) {
        self.repository = repository
    }
    
    func execute(criteria: TodoSearchCriteria) async throws -> [Todo] {
        let all = try await repository.getAllTodos()
        let filteredByQuery = all.filter { todo in
            guard let query = criteria.query, !query.isEmpty else { return true }
            let inTitle = todo.title.localizedCaseInsensitiveContains(query)
            let inDescription = (todo.description ?? "").localizedCaseInsensitiveContains(query)
            return inTitle || inDescription
        }
        let filteredByStatus = filteredByQuery.filter { todo in
            guard let isCompleted = criteria.isCompleted else { return true }
            return todo.isCompleted == isCompleted
        }
        let filteredByPriority = filteredByStatus.filter { todo in
            guard let priority = criteria.priority else { return true }
            return todo.priority == priority
        }
        return filteredByPriority
    }
}
