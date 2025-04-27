import Foundation

@MainActor
final class TodoListViewModel: ObservableObject {
    private let getAllTodosUseCase: GetAllTodosUseCase
    private let deleteTodoUseCase: DeleteTodoUseCase
    
    @Published private(set) var todos: [Todo] = []
    @Published private(set) var error: TodoViewError?
    @Published private(set) var isLoading = false
    
    init(
        getAllTodosUseCase: GetAllTodosUseCase,
        deleteTodoUseCase: DeleteTodoUseCase
    ) {
        self.getAllTodosUseCase = getAllTodosUseCase
        self.deleteTodoUseCase = deleteTodoUseCase
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
                loadTodos()  // 목록 새로고침
            } catch {
                self.error = .failedToDelete
            }
        }
    }
}
