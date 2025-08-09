import Foundation

@MainActor
final class TodoDetailViewModel: ObservableObject {
    private let getTodoUseCase: GetTodoUseCase
    private let updateTodoUseCase: UpdateTodoUseCase
    private let toggleCompletionUseCase: ToggleTodoCompletionUseCase
    
    @Published private(set) var todo: Todo?
    @Published private(set) var error: TodoViewError?
    @Published private(set) var isLoading = false
    
    init(
        getTodoUseCase: GetTodoUseCase,
        updateTodoUseCase: UpdateTodoUseCase,
        toggleCompletionUseCase: ToggleTodoCompletionUseCase
    ) {
        self.getTodoUseCase = getTodoUseCase
        self.updateTodoUseCase = updateTodoUseCase
        self.toggleCompletionUseCase = toggleCompletionUseCase
    }
    
    func loadTodo(id: UUID) {
        Task {
            isLoading = true
            error = nil
            
            do {
                todo = try await getTodoUseCase.execute(id: id)
            } catch {
                self.error = .failedToLoad
            }
            
            isLoading = false
        }
    }
    
    func updateTodo(title: String, description: String?, isCompleted: Bool, priority: TodoPriority, dueDate: Date?) {
        guard let todo = todo else { return }
        
        Task {
            do {
                self.todo = try await updateTodoUseCase.execute(
                    id: todo.id,
                    title: title,
                    description: description,
                    isCompleted: isCompleted,
                    priority: priority,
                    dueDate: dueDate
                )
            } catch {
                self.error = .failedToUpdate
            }
        }
    }
    
    func toggleCompletion() {
        guard let todo = todo else { return }
        Task {
            do {
                self.todo = try await toggleCompletionUseCase.execute(id: todo.id)
            } catch {
                self.error = .failedToUpdate
            }
        }
    }
}
