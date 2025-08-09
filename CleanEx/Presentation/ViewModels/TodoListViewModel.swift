import Foundation

@MainActor
final class TodoListViewModel: ObservableObject {
    private let getAllTodosUseCase: GetAllTodosUseCase
    private let deleteTodoUseCase: DeleteTodoUseCase
    private let addTodoUseCase: AddTodoUseCase
    private let toggleCompletionUseCase: ToggleTodoCompletionUseCase
    private let searchTodosUseCase: SearchTodosUseCase
    private let markAllCompletedUseCase: MarkAllCompletedUseCase
    private let deleteCompletedTodosUseCase: DeleteCompletedTodosUseCase
    
    @Published private(set) var todos: [Todo] = []
    @Published private(set) var error: TodoViewError?
    @Published private(set) var isLoading = false
    
    @Published var searchText: String = ""
    @Published var filterCompleted: Bool? = nil // nil: all, true: completed, false: active
    @Published var selectedPriority: TodoPriority? = nil
    @Published var sortKey: TodoSortKey? = .createdAt
    @Published var sortAscending: Bool = false
    
    @Published private(set) var totalCount: Int = 0
    @Published private(set) var completedCount: Int = 0
    @Published private(set) var activeCount: Int = 0
    
    init(
        getAllTodosUseCase: GetAllTodosUseCase,
        deleteTodoUseCase: DeleteTodoUseCase,
        addTodoUseCase: AddTodoUseCase,
        toggleCompletionUseCase: ToggleTodoCompletionUseCase,
        searchTodosUseCase: SearchTodosUseCase,
        markAllCompletedUseCase: MarkAllCompletedUseCase,
        deleteCompletedTodosUseCase: DeleteCompletedTodosUseCase
    ) {
        self.getAllTodosUseCase = getAllTodosUseCase
        self.deleteTodoUseCase = deleteTodoUseCase
        self.addTodoUseCase = addTodoUseCase
        self.toggleCompletionUseCase = toggleCompletionUseCase
        self.searchTodosUseCase = searchTodosUseCase
        self.markAllCompletedUseCase = markAllCompletedUseCase
        self.deleteCompletedTodosUseCase = deleteCompletedTodosUseCase
    }
    
    func loadTodos() {
        Task {
            isLoading = true
            error = nil
            
            do {
                todos = try await getAllTodosUseCase.execute()
                recalcStats(all: todos)
            } catch {
                self.error = .failedToLoad
            }
            
            isLoading = false
        }
    }
    
    func deleteTodo(id: UUID) {
        Task {
            do {
                try await deleteTodoUseCase.execute(id: id)
                await refreshWithCurrentFilters()
            } catch {
                self.error = .failedToDelete
            }
        }
    }
    
    func createTodo(title: String, description: String? = nil, priority: TodoPriority = .medium, dueDate: Date? = nil) {
        Task {
            do {
                _ = try await addTodoUseCase.execute(title: title, description: description, priority: priority, dueDate: dueDate)
                await refreshWithCurrentFilters()
            } catch {
                self.error = .failedToCreate
            }
        }
    }
    
    func toggleCompletion(id: UUID) {
        Task {
            do {
                _ = try await toggleCompletionUseCase.execute(id: id)
                await refreshWithCurrentFilters()
            } catch {
                self.error = .failedToUpdate
            }
        }
    }
    
    func applyFilters(query: String? = nil, isCompleted: Bool? = nil, priority: TodoPriority? = nil) {
        Task {
            let criteria = TodoSearchCriteria(
                query: query ?? searchText,
                isCompleted: isCompleted ?? filterCompleted,
                priority: priority ?? selectedPriority,
                sortKey: sortKey,
                ascending: sortAscending
            )
            do {
                let result = try await searchTodosUseCase.execute(criteria: criteria)
                todos = result
                recalcStats(all: try await getAllTodosUseCase.execute())
            } catch {
                self.error = .failedToLoad
            }
        }
    }
    
    func setSort(key: TodoSortKey?, ascending: Bool) {
        sortKey = key
        sortAscending = ascending
        applyFilters()
    }
    
    func markAllAsCompleted() {
        Task {
            let criteria = TodoSearchCriteria(
                query: searchText,
                isCompleted: false,
                priority: selectedPriority
            )
            do {
                try await markAllCompletedUseCase.execute(criteria: criteria)
                await refreshWithCurrentFilters()
            } catch {
                self.error = .failedToUpdate
            }
        }
    }
    
    func deleteCompleted() {
        Task {
            let criteria = TodoSearchCriteria(
                query: searchText,
                isCompleted: true,
                priority: selectedPriority
            )
            do {
                try await deleteCompletedTodosUseCase.execute(criteria: criteria)
                await refreshWithCurrentFilters()
            } catch {
                self.error = .failedToDelete
            }
        }
    }
    
    private func refreshWithCurrentFilters() async {
        let criteria = TodoSearchCriteria(
            query: searchText,
            isCompleted: filterCompleted,
            priority: selectedPriority,
            sortKey: sortKey,
            ascending: sortAscending
        )
        do {
            let result = try await searchTodosUseCase.execute(criteria: criteria)
            todos = result
            recalcStats(all: try await getAllTodosUseCase.execute())
        } catch {
            self.error = .failedToLoad
        }
    }
    
    private func recalcStats(all: [Todo]) {
        totalCount = all.count
        completedCount = all.filter { $0.isCompleted }.count
        activeCount = totalCount - completedCount
    }
}
