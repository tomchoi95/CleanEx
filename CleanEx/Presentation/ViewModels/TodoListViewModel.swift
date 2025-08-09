import Foundation

@MainActor
final class TodoListViewModel: ObservableObject {
    private let getAllTodosUseCase: GetAllTodosUseCase
    private let deleteTodoUseCase: DeleteTodoUseCase
    private let addTodoUseCase: AddTodoUseCase
    private let toggleCompletionUseCase: ToggleTodoCompletionUseCase
    private let searchTodosUseCase: SearchTodosUseCase
    
    @Published private(set) var todos: [Todo] = []
    @Published private(set) var error: TodoViewError?
    @Published private(set) var isLoading = false
    
    @Published var searchText: String = ""
    @Published var filterCompleted: Bool? = nil // nil: all, true: completed, false: active
    @Published var selectedPriority: TodoPriority? = nil
    
    init(
        getAllTodosUseCase: GetAllTodosUseCase,
        deleteTodoUseCase: DeleteTodoUseCase,
        addTodoUseCase: AddTodoUseCase,
        toggleCompletionUseCase: ToggleTodoCompletionUseCase,
        searchTodosUseCase: SearchTodosUseCase
    ) {
        self.getAllTodosUseCase = getAllTodosUseCase
        self.deleteTodoUseCase = deleteTodoUseCase
        self.addTodoUseCase = addTodoUseCase
        self.toggleCompletionUseCase = toggleCompletionUseCase
        self.searchTodosUseCase = searchTodosUseCase
    }
    
    func loadTodos() {
        Task {
            isLoading = true
            error = nil
            
            do {
                todos = try await getAllTodosUseCase.execute()
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
                priority: priority ?? selectedPriority
            )
            do {
                todos = try await searchTodosUseCase.execute(criteria: criteria)
            } catch {
                self.error = .failedToLoad
            }
        }
    }
    
    private func refreshWithCurrentFilters() async {
        let criteria = TodoSearchCriteria(
            query: searchText,
            isCompleted: filterCompleted,
            priority: selectedPriority
        )
        do {
            todos = try await searchTodosUseCase.execute(criteria: criteria)
        } catch {
            self.error = .failedToLoad
        }
    }
}
