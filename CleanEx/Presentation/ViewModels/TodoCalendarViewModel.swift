import Foundation

@MainActor
final class TodoCalendarViewModel: ObservableObject {
    private let addTodoUseCase: AddTodoUseCase
    private let updateTodoUseCase: UpdateTodoUseCase
    private let deleteTodoUseCase: DeleteTodoUseCase
    private let toggleCompletionUseCase: ToggleTodoCompletionUseCase
    private let searchTodosUseCase: SearchTodosUseCase
    
    @Published var selectedDate: Date = Date()
    @Published var searchText: String = ""
    @Published private(set) var todos: [Todo] = []
    @Published private(set) var isLoading = false
    @Published private(set) var error: TodoViewError?
    
    init(
        addTodoUseCase: AddTodoUseCase,
        updateTodoUseCase: UpdateTodoUseCase,
        deleteTodoUseCase: DeleteTodoUseCase,
        toggleCompletionUseCase: ToggleTodoCompletionUseCase,
        searchTodosUseCase: SearchTodosUseCase
    ) {
        self.addTodoUseCase = addTodoUseCase
        self.updateTodoUseCase = updateTodoUseCase
        self.deleteTodoUseCase = deleteTodoUseCase
        self.toggleCompletionUseCase = toggleCompletionUseCase
        self.searchTodosUseCase = searchTodosUseCase
    }
    
    func load() {
        applyFilters()
    }
    
    func applyFilters() {
        Task {
            isLoading = true
            error = nil
            let criteria = TodoSearchCriteria(
                query: searchText,
                isCompleted: nil,
                priority: nil,
                sortKey: .priority,
                ascending: false,
                dueOn: selectedDate
            )
            do {
                todos = try await searchTodosUseCase.execute(criteria: criteria)
            } catch {
                error = .failedToLoad
            }
            isLoading = false
        }
    }
    
    func createTodo(title: String, description: String? = nil, priority: TodoPriority = .medium) {
        Task {
            do {
                _ = try await addTodoUseCase.execute(title: title, description: description, priority: priority, dueDate: selectedDate)
                applyFilters()
            } catch {
                error = .failedToCreate
            }
        }
    }
    
    func toggleCompletion(id: UUID) {
        Task {
            do {
                _ = try await toggleCompletionUseCase.execute(id: id)
                applyFilters()
            } catch {
                error = .failedToUpdate
            }
        }
    }
    
    func deleteTodo(id: UUID) {
        Task {
            do {
                try await deleteTodoUseCase.execute(id: id)
                applyFilters()
            } catch {
                error = .failedToDelete
            }
        }
    }
}