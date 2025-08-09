import SwiftUI

struct TodoDetailView: View {
    @ObservedObject var viewModel: TodoDetailViewModel
    
    @State private var title: String = ""
    @State private var description: String = ""
    @State private var isCompleted: Bool = false
    @State private var priority: TodoPriority = .medium
    @State private var dueDate: Date? = nil
    @State private var showDatePicker = false
    
    var body: some View {
        Form {
            Section("기본 정보") {
                TextField("제목", text: Binding(
                    get: { title },
                    set: { title = $0 }
                ))
                TextField("설명", text: Binding(
                    get: { description },
                    set: { description = $0 }
                ))
                Toggle("완료", isOn: Binding(
                    get: { isCompleted },
                    set: { isCompleted = $0 }
                ))
            }
            Section("우선순위") {
                Picker("우선순위", selection: $priority) {
                    Text("낮음").tag(TodoPriority.low)
                    Text("보통").tag(TodoPriority.medium)
                    Text("높음").tag(TodoPriority.high)
                }
                .pickerStyle(.segmented)
            }
            Section("마감일") {
                Toggle("마감일 설정", isOn: Binding(
                    get: { dueDate != nil },
                    set: { if !$0 { dueDate = nil } else { dueDate = Date() } }
                ))
                if dueDate != nil {
                    DatePicker(
                        "마감일",
                        selection: Binding<Date>(
                            get: { dueDate ?? Date() },
                            set: { dueDate = $0 }
                        ),
                        displayedComponents: .date
                    )
                }
            }
            Section {
                Button("변경사항 저장") {
                    viewModel.updateTodo(
                        title: title,
                        description: description.isEmpty ? nil : description,
                        isCompleted: isCompleted,
                        priority: priority,
                        dueDate: dueDate
                    )
                }
                Button(viewModel.todo?.isCompleted == true ? "미완료로 전환" : "완료로 전환") {
                    viewModel.toggleCompletion()
                }
            }
        }
        .onReceive(viewModel.$todo) { todo in
            guard let todo = todo else { return }
            self.title = todo.title
            self.description = todo.description ?? ""
            self.isCompleted = todo.isCompleted
            self.priority = todo.priority
            self.dueDate = todo.dueDate
        }
        .navigationTitle("할 일 상세")
        .toolbar { ToolbarItem(placement: .principal) { Text(viewModel.todo?.title ?? "상세") } }
        .alert(item: Binding(get: {
            viewModel.error.map { ErrorWrapper(error: $0) }
        }, set: { _ in viewModel.error = nil })) { wrapper in
            Alert(title: Text("오류"), message: Text(wrapper.error.localizedDescription), dismissButton: .default(Text("확인")))
        }
    }
}

private struct ErrorWrapper: Identifiable {
    let id = UUID()
    let error: Error
}

#Preview {
    TodoDetailView(viewModel: TodoDetailViewModel(
        getTodoUseCase: GetTodoUseCaseImpl(repository: DummyRepo()),
        updateTodoUseCase: UpdateTodoUseCaseImpl(repository: DummyRepo()),
        toggleCompletionUseCase: ToggleTodoCompletionUseCaseImpl(repository: DummyRepo())
    ))
}

private struct DummyRepo: TodoRepository {
    func getAllTodos() async throws -> [Todo] { [Todo(title: "샘플", description: "예시", priority: .high)] }
    func getTodo(id: UUID) async throws -> Todo { Todo(title: "샘플") }
    func addTodo(todo: Todo) async throws -> Todo { todo }
    func updateTodo(todo: Todo) async throws -> Todo { todo }
    func deleteTodo(id: UUID) async throws {}
}