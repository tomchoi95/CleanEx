import Foundation

@MainActor
final class TodoDetailViewModel: ObservableObject {
    private let getTodoUseCase: GetTodoUseCase
    private let updateTodoUseCase: UpdateTodoUseCase
    
    @Published private(set) var todo: Todo?
    @Published private(set) var error: TodoViewError?
    @Published private(set) var isLoading = false
    
    init(
        getTodoUseCase: GetTodoUseCase,
        updateTodoUseCase: UpdateTodoUseCase
    ) {
        self.getTodoUseCase = getTodoUseCase
        self.updateTodoUseCase = updateTodoUseCase
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
    
    func updateTodo(title: String, description: String?, isCompleted: Bool, priority: TodoPriority) {
        guard let todo = todo else { return }
        
        Task {
            do {
                self.todo = try await updateTodoUseCase.execute(
                    id: todo.id,
                    title: title,
                    description: description,
                    isCompleted: isCompleted,
                    priority: priority
                )
            } catch {
                self.error = .failedToUpdate
            }
        }
    }
}
