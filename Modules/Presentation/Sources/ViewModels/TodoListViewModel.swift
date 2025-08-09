import Foundation
import Domain

@MainActor
public final class TodoListViewModel: ObservableObject {
    public let todoUseCase: TodoUseCaseProtocol
    
    @Published public private(set) var todos: [Todo] = []
    @Published public var error: TodoViewError?
    @Published public private(set) var isLoading = false
    
    @Published var searchText: String = "" {
        didSet {
            filterTodos()
        }
    }
    @Published var filterCompleted: Bool? = nil {
        didSet {
            filterTodos()
        }
    }
    
    private var allTodos: [Todo] = []
    
    public init(todoUseCase: TodoUseCaseProtocol) {
        self.todoUseCase = todoUseCase
    }
    
    public func loadTodos() {
        Task {
            isLoading = true
            error = nil
            
            do {
                allTodos = try await todoUseCase.getAllTodos()
                filterTodos()
            } catch {
                self.error = .failedToLoad
            }
            
            isLoading = false
        }
    }
    
    public func deleteTodo(id: UUID) {
        Task {
            do {
                try await todoUseCase.deleteTodo(id: id)
                await loadTodos()
            } catch {
                self.error = .failedToDelete
            }
        }
    }
    
    public func toggleCompletion(id: UUID) {
        Task {
            do {
                guard let todo = todos.first(where: { $0.id == id }) else { return }
                var updatedTodo = todo
                updatedTodo.isCompleted.toggle()
                _ = try await todoUseCase.updateTodo(todo: updatedTodo)
                await loadTodos()
            } catch {
                self.error = .failedToUpdate
            }
        }
    }
    
    private func filterTodos() {
        var filtered = allTodos
        
        // Apply search filter
        if !searchText.isEmpty {
            filtered = filtered.filter { todo in
                todo.title.localizedCaseInsensitiveContains(searchText) ||
                (todo.description ?? "").localizedCaseInsensitiveContains(searchText)
            }
        }
        
        // Apply completion filter
        if let isCompleted = filterCompleted {
            filtered = filtered.filter { $0.isCompleted == isCompleted }
        }
        
        // Sort by created date (newest first)
        filtered.sort { $0.createdAt > $1.createdAt }
        
        todos = filtered
    }
}
