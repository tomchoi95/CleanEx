import SwiftUI
import Domain

public struct ContentView: View {
    private let todoListView: TodoListView
    
    public init(todoListView: TodoListView) {
        self.todoListView = todoListView
    }
    
    public var body: some View {
        NavigationStack {
            todoListView
                .navigationTitle("Todos")
        }
    }
}

#Preview {
    ContentView(todoListView: TodoListView(viewModel: TodoListViewModel(todoUseCase: PreviewTodoUseCase())))
}

// Preview용 Mock UseCase
private struct PreviewTodoUseCase: TodoUseCaseProtocol {
    func getAllTodos() async throws -> [Todo] {
        return []
    }
    
    func getTodo(id: UUID) async throws -> Todo {
        return Todo(id: UUID(), title: "Sample")
    }
    
    func addTodo(todo: Todo) async throws -> Todo {
        return todo
    }
    
    func updateTodo(todo: Todo) async throws -> Todo {
        return todo
    }
    
    func deleteTodo(id: UUID) async throws {
        // Do nothing
    }
}