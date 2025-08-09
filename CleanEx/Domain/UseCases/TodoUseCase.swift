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

enum TodoSortKey {
    case createdAt
    case updatedAt
    case dueDate
    case priority
    case title
}

struct TodoSearchCriteria {
    let query: String?
    let isCompleted: Bool?
    let priority: TodoPriority?
    let sortKey: TodoSortKey?
    let ascending: Bool
    let dueOn: Date?
    
    init(
        query: String? = nil,
        isCompleted: Bool? = nil,
        priority: TodoPriority? = nil,
        sortKey: TodoSortKey? = nil,
        ascending: Bool = true,
        dueOn: Date? = nil
    ) {
        self.query = query
        self.isCompleted = isCompleted
        self.priority = priority
        self.sortKey = sortKey
        self.ascending = ascending
        self.dueOn = dueOn
    }
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
        let filteredByDueDate = filteredByPriority.filter { todo in
            guard let targetDate = criteria.dueOn else { return true }
            guard let due = todo.dueDate else { return false }
            return Calendar.current.isDate(due, inSameDayAs: targetDate)
        }
        let sorted: [Todo]
        if let sortKey = criteria.sortKey {
            sorted = filteredByDueDate.sorted { lhs, rhs in
                switch sortKey {
                case .createdAt:
                    return criteria.ascending ? lhs.createdAt < rhs.createdAt : lhs.createdAt > rhs.createdAt
                case .updatedAt:
                    return criteria.ascending ? lhs.updatedAt < rhs.updatedAt : lhs.updatedAt > rhs.updatedAt
                case .dueDate:
                    let l = lhs.dueDate ?? Date.distantFuture
                    let r = rhs.dueDate ?? Date.distantFuture
                    return criteria.ascending ? l < r : l > r
                case .priority:
                    return criteria.ascending ? lhs.priority.rawValue < rhs.priority.rawValue : lhs.priority.rawValue > rhs.priority.rawValue
                case .title:
                    return criteria.ascending ? lhs.title.localizedCompare(rhs.title) == .orderedAscending : lhs.title.localizedCompare(rhs.title) == .orderedDescending
                }
            }
        } else {
            sorted = filteredByDueDate
        }
        return sorted
    }
}

protocol MarkAllCompletedUseCase {
    func execute(criteria: TodoSearchCriteria) async throws
}

struct MarkAllCompletedUseCaseImpl: MarkAllCompletedUseCase {
    private let repository: TodoRepository
    
    init(repository: TodoRepository) {
        self.repository = repository
    }
    
    func execute(criteria: TodoSearchCriteria) async throws {
        // Mark all matching todos as completed
        let search = SearchTodosUseCaseImpl(repository: repository)
        let todos = try await search.execute(criteria: criteria)
        for todo in todos where todo.isCompleted == false {
            let updated = Todo(
                id: todo.id,
                title: todo.title,
                description: todo.description,
                isCompleted: true,
                priority: todo.priority,
                dueDate: todo.dueDate,
                createdAt: todo.createdAt,
                updatedAt: Date()
            )
            _ = try await repository.updateTodo(todo: updated)
        }
    }
}

protocol DeleteCompletedTodosUseCase {
    func execute(criteria: TodoSearchCriteria) async throws
}

struct DeleteCompletedTodosUseCaseImpl: DeleteCompletedTodosUseCase {
    private let repository: TodoRepository
    
    init(repository: TodoRepository) {
        self.repository = repository
    }
    
    func execute(criteria: TodoSearchCriteria) async throws {
        let search = SearchTodosUseCaseImpl(repository: repository)
        let todos = try await search.execute(criteria: criteria)
        for todo in todos where todo.isCompleted {
            try await repository.deleteTodo(id: todo.id)
        }
    }
}
