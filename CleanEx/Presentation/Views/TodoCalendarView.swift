import SwiftUI

struct TodoCalendarView: View {
    @ObservedObject var viewModel: TodoCalendarViewModel
    
    @State private var newTitle: String = ""
    @State private var newPriority: TodoPriority = .medium
    
    var body: some View {
        VStack(spacing: 12) {
            DatePicker(
                "날짜",
                selection: $viewModel.selectedDate,
                displayedComponents: .date
            )
            .datePickerStyle(.graphical)
            .onChange(of: viewModel.selectedDate) { _ in viewModel.applyFilters() }
            
            HStack(spacing: 8) {
                TextField("검색", text: $viewModel.searchText)
                    .textFieldStyle(.roundedBorder)
                    .onSubmit { viewModel.applyFilters() }
                Spacer()
                Picker("우선순위", selection: $newPriority) {
                    Text("낮음").tag(TodoPriority.low)
                    Text("보통").tag(TodoPriority.medium)
                    Text("높음").tag(TodoPriority.high)
                }
                .pickerStyle(.segmented)
                TextField("새 할 일", text: $newTitle)
                    .textFieldStyle(.roundedBorder)
                Button("추가") {
                    guard !newTitle.trimmingCharacters(in: .whitespaces).isEmpty else { return }
                    viewModel.createTodo(title: newTitle, priority: newPriority)
                    newTitle = ""
                    newPriority = .medium
                }
            }
            
            if viewModel.isLoading {
                ProgressView()
            }
            
            List {
                ForEach(viewModel.todos, id: \.id) { todo in
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
                .onDelete { indexSet in
                    indexSet.map { viewModel.todos[$0].id }.forEach(viewModel.deleteTodo(id:))
                }
            }
        }
        .padding()
        .onAppear { viewModel.load() }
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
    TodoCalendarView(viewModel: TodoCalendarViewModel(
        addTodoUseCase: AddTodoUseCaseImpl(repository: DummyRepo()),
        updateTodoUseCase: UpdateTodoUseCaseImpl(repository: DummyRepo()),
        deleteTodoUseCase: DeleteTodoUseCaseImpl(repository: DummyRepo()),
        toggleCompletionUseCase: ToggleTodoCompletionUseCaseImpl(repository: DummyRepo()),
        searchTodosUseCase: SearchTodosUseCaseImpl(repository: DummyRepo())
    ))
}

private struct DummyRepo: TodoRepository {
    func getAllTodos() async throws -> [Todo] { [Todo(title: "샘플", description: "예시", priority: .high, dueDate: Date())] }
    func getTodo(id: UUID) async throws -> Todo { Todo(title: "샘플") }
    func addTodo(todo: Todo) async throws -> Todo { todo }
    func updateTodo(todo: Todo) async throws -> Todo { todo }
    func deleteTodo(id: UUID) async throws {}
}