import SwiftUI
import Domain

public struct TodoListView: View {
    @ObservedObject public var viewModel: TodoListViewModel
    
    public init(viewModel: TodoListViewModel) {
        self.viewModel = viewModel
    }
    
    @State private var newTitle: String = ""
    
    public var body: some View {
        VStack(spacing: 12) {
            // Create new todo
            HStack {
                TextField("할 일을 입력하세요", text: $newTitle)
                    .textFieldStyle(.roundedBorder)
                Button("추가") {
                    guard !newTitle.trimmingCharacters(in: .whitespaces).isEmpty else { return }
                    Task {
                        let todo = Todo(title: newTitle)
                        _ = try? await viewModel.todoUseCase.addTodo(todo: todo)
                        viewModel.loadTodos()
                        newTitle = ""
                    }
                }
                .buttonStyle(.borderedProminent)
            }
            .padding(.horizontal)
            
            // Search bar
            TextField("검색", text: $viewModel.searchText)
                .textFieldStyle(.roundedBorder)
                .padding(.horizontal)
            
            // Filter buttons
            HStack {
                Button("전체") { viewModel.filterCompleted = nil }
                    .buttonStyle(.bordered)
                    .tint(viewModel.filterCompleted == nil ? .blue : .gray)
                
                Button("진행중") { viewModel.filterCompleted = false }
                    .buttonStyle(.bordered)
                    .tint(viewModel.filterCompleted == false ? .blue : .gray)
                
                Button("완료") { viewModel.filterCompleted = true }
                    .buttonStyle(.bordered)
                    .tint(viewModel.filterCompleted == true ? .blue : .gray)
            }
            .padding(.horizontal)
            
            // Todo list
            if viewModel.isLoading {
                ProgressView()
                    .frame(maxHeight: .infinity)
            } else if viewModel.todos.isEmpty {
                Text("할 일이 없습니다")
                    .foregroundColor(.secondary)
                    .frame(maxHeight: .infinity)
            } else {
                List {
                    ForEach(viewModel.todos) { todo in
                        TodoRowView(todo: todo) {
                            viewModel.toggleCompletion(id: todo.id)
                        } onDelete: {
                            viewModel.deleteTodo(id: todo.id)
                        }
                    }
                    .onDelete { indexSet in
                        for index in indexSet {
                            viewModel.deleteTodo(id: viewModel.todos[index].id)
                        }
                    }
                }
                .listStyle(.plain)
            }
        }
        .onAppear {
            viewModel.loadTodos()
        }
        .alert("오류", isPresented: .constant(viewModel.error != nil)) {
            Button("확인") {
                viewModel.error = nil
            }
        } message: {
            Text(viewModel.error?.localizedDescription ?? "")
        }
    }
}

struct TodoRowView: View {
    let todo: Todo
    let onToggle: () -> Void
    let onDelete: () -> Void
    
    var body: some View {
        HStack {
            Button(action: onToggle) {
                Image(systemName: todo.isCompleted ? "checkmark.circle.fill" : "circle")
                    .foregroundColor(todo.isCompleted ? .green : .gray)
            }
            .buttonStyle(.plain)
            
            VStack(alignment: .leading) {
                Text(todo.title)
                    .strikethrough(todo.isCompleted)
                    .foregroundColor(todo.isCompleted ? .gray : .primary)
                
                if let description = todo.description {
                    Text(description)
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            }
            
            Spacer()
            
            // Priority indicator
            Circle()
                .fill(priorityColor(todo.priority))
                .frame(width: 8, height: 8)
            
            Button(action: onDelete) {
                Image(systemName: "trash")
                    .foregroundColor(.red)
            }
            .buttonStyle(.plain)
        }
        .padding(.vertical, 4)
    }
    
    func priorityColor(_ priority: TodoPriority) -> Color {
        switch priority {
        case .low: return .green
        case .medium: return .orange
        case .high: return .red
        }
    }
}