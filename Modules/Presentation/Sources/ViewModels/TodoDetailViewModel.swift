import Foundation
import Domain

@MainActor
public final class TodoDetailViewModel: ObservableObject {
    private let todoUseCase: TodoUseCaseProtocol
    private let todoId: UUID
    
    @Published public private(set) var todo: Todo?
    @Published public private(set) var error: TodoViewError?
    @Published public private(set) var isLoading = false
    
    public init(todoId: UUID, todoUseCase: TodoUseCaseProtocol) {
        self.todoId = todoId
        self.todoUseCase = todoUseCase
    }
    
    public func loadTodo() {
        Task {
            isLoading = true
            error = nil
            
            do {
                todo = try await todoUseCase.getTodo(id: todoId)
            } catch {
                self.error = .failedToLoad
            }
            
            isLoading = false
        }
    }
    
    public func updateTodo(title: String, description: String?, isCompleted: Bool, priority: TodoPriority, dueDate: Date?) {
        guard var currentTodo = todo else { return }
        
        Task {
            do {
                currentTodo.title = title
                currentTodo.description = description
                currentTodo.isCompleted = isCompleted
                currentTodo.priority = priority
                currentTodo.dueDate = dueDate
                currentTodo.updatedAt = Date()
                
                todo = try await todoUseCase.updateTodo(todo: currentTodo)
            } catch {
                self.error = .failedToUpdate
            }
        }
    }
    
    public func toggleCompletion() {
        guard var currentTodo = todo else { return }
        
        Task {
            do {
                currentTodo.isCompleted.toggle()
                currentTodo.updatedAt = Date()
                todo = try await todoUseCase.updateTodo(todo: currentTodo)
            } catch {
                self.error = .failedToUpdate
            }
        }
    }
}