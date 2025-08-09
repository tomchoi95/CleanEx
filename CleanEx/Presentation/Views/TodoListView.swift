import SwiftUI

struct TodoListView: View {
    @ObservedObject var viewModel: TodoListViewModel
    let container: DIContainer
    
    @State private var newTitle: String = ""
    @State private var newPriority: TodoPriority = .medium
    
    var body: some View {
        VStack(spacing: 12) {
            // Create new
            HStack {
                TextField("할 일을 입력하세요", text: $newTitle)
                    .textFieldStyle(.roundedBorder)
                Picker("우선순위", selection: $newPriority) {
                    Text("낮음").tag(TodoPriority.low)
                    Text("보통").tag(TodoPriority.medium)
                    Text("높음").tag(TodoPriority.high)
                }
                .pickerStyle(.segmented)
                Button("추가") {
                    guard !newTitle.trimmingCharacters(in: .whitespaces).isEmpty else { return }
                    viewModel.createTodo(title: newTitle, priority: newPriority)
                    newTitle = ""
                    newPriority = .medium
                }
            }
            
            // Search & Filters
            HStack {
                TextField("검색", text: $viewModel.searchText)
                    .textFieldStyle(.roundedBorder)
                    .onSubmit { viewModel.applyFilters() }
                Menu {
                    Button("전체") { viewModel.filterCompleted = nil; viewModel.applyFilters() }
                    Button("진행중") { viewModel.filterCompleted = false; viewModel.applyFilters() }
                    Button("완료") { viewModel.filterCompleted = true; viewModel.applyFilters() }
                } label: {
                    Label("상태", systemImage: "line.3.horizontal.decrease.circle")
                }
                Menu {
                    Button("모두") { viewModel.selectedPriority = nil; viewModel.applyFilters() }
                    Button("낮음") { viewModel.selectedPriority = .low; viewModel.applyFilters() }
                    Button("보통") { viewModel.selectedPriority = .medium; viewModel.applyFilters() }
                    Button("높음") { viewModel.selectedPriority = .high; viewModel.applyFilters() }
                } label: {
                    Label("우선순위", systemImage: "flag")
                }
            }
            
            if viewModel.isLoading {
                ProgressView()
            }
            
            List {
                ForEach(viewModel.todos, id: \.id) { todo in
                    NavigationLink(destination: container.makeTodoDetailView(todoId: todo.id)) {
                        HStack {
                            Button(action: { viewModel.toggleCompletion(id: todo.id) }) {
                                Image(systemName: todo.isCompleted ? "checkmark.circle.fill" : "circle")
                                    .foregroundStyle(todo.isCompleted ? .green : .gray)
                            }
                            .buttonStyle(.plain)
                            VStack(alignment: .leading, spacing: 4) {
                                Text(todo.title)
                                    .strikethrough(todo.isCompleted)
                                if let description = todo.description, !description.isEmpty {
                                    Text(description)
                                        .font(.subheadline)
                                        .foregroundStyle(.secondary)
                                }
                                if let date = todo.dueDate {
                                    Text(date, style: .date)
                                        .font(.caption)
                                        .foregroundStyle(.secondary)
                                }
                            }
                            Spacer()
                            Text(priorityLabel(todo.priority))
                                .font(.caption)
                                .padding(6)
                                .background(priorityColor(todo.priority).opacity(0.15))
                                .foregroundStyle(priorityColor(todo.priority))
                                .clipShape(RoundedRectangle(cornerRadius: 6))
                        }
                    }
                }
                .onDelete { indexSet in
                    indexSet.map { viewModel.todos[$0].id }.forEach(viewModel.deleteTodo(id:))
                }
            }
        }
        .padding()
        .onAppear { viewModel.loadTodos() }
        .alert(item: Binding(get: {
            viewModel.error.map { ErrorWrapper(error: $0) }
        }, set: { _ in viewModel.error = nil })) { wrapper in
            Alert(title: Text("오류"), message: Text(wrapper.error.localizedDescription), dismissButton: .default(Text("확인")))
        }
    }
    
    private func priorityLabel(_ p: TodoPriority) -> String {
        switch p {
        case .low: return "낮음"
        case .medium: return "보통"
        case .high: return "높음"
        }
    }
    private func priorityColor(_ p: TodoPriority) -> Color {
        switch p {
        case .low: return .blue
        case .medium: return .orange
        case .high: return .red
        }
    }
}

private struct ErrorWrapper: Identifiable {
    let id = UUID()
    let error: Error
}

#Preview {
    let container = DIContainer.make(modelContext: try! ModelContainer(for: TodoLocalModel.self).mainContext)
    return TodoListView(viewModel: TodoListViewModel(
        getAllTodosUseCase: GetAllTodosUseCaseImpl(repository: DummyRepo()),
        deleteTodoUseCase: DeleteTodoUseCaseImpl(repository: DummyRepo()),
        addTodoUseCase: AddTodoUseCaseImpl(repository: DummyRepo()),
        toggleCompletionUseCase: ToggleTodoCompletionUseCaseImpl(repository: DummyRepo()),
        searchTodosUseCase: SearchTodosUseCaseImpl(repository: DummyRepo())
    ), container: container)
}

private struct DummyRepo: TodoRepository {
    func getAllTodos() async throws -> [Todo] { [Todo(title: "샘플", description: "예시", priority: .high)] }
    func getTodo(id: UUID) async throws -> Todo { Todo(title: "샘플") }
    func addTodo(todo: Todo) async throws -> Todo { todo }
    func updateTodo(todo: Todo) async throws -> Todo { todo }
    func deleteTodo(id: UUID) async throws {}
}