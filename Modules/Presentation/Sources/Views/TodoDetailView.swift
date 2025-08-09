import SwiftUI
import Domain

public struct TodoDetailView: View {
    @ObservedObject public var viewModel: TodoDetailViewModel
    
    @State private var title: String = ""
    @State private var description: String = ""
    @State private var isCompleted: Bool = false
    @State private var priority: TodoPriority = .medium
    @State private var dueDate: Date? = nil
    @State private var showDatePicker: Bool = false
    
    public init(viewModel: TodoDetailViewModel) {
        self.viewModel = viewModel
    }
    
    public var body: some View {
        Group {
            if viewModel.isLoading {
                ProgressView()
            } else if let todo = viewModel.todo {
                Form {
                    Section("기본 정보") {
                        TextField("제목", text: $title)
                        TextField("설명", text: $description, axis: .vertical)
                            .lineLimit(3...6)
                        Toggle("완료", isOn: $isCompleted)
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
                        Toggle("마감일 설정", isOn: $showDatePicker)
                        if showDatePicker {
                            DatePicker("마감일", selection: Binding(
                                get: { dueDate ?? Date() },
                                set: { dueDate = $0 }
                            ), displayedComponents: [.date, .hourAndMinute])
                        }
                    }
                    
                    Section("정보") {
                        LabeledContent("생성일", value: todo.createdAt.formatted())
                        LabeledContent("수정일", value: todo.updatedAt.formatted())
                    }
                }
                .navigationTitle("할 일 상세")
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button("저장") {
                            viewModel.updateTodo(
                                title: title,
                                description: description.isEmpty ? nil : description,
                                isCompleted: isCompleted,
                                priority: priority,
                                dueDate: showDatePicker ? dueDate : nil
                            )
                        }
                    }
                }
                .onAppear {
                    // Initialize state from todo
                    title = todo.title
                    description = todo.description ?? ""
                    isCompleted = todo.isCompleted
                    priority = todo.priority
                    dueDate = todo.dueDate
                    showDatePicker = todo.dueDate != nil
                }
            } else {
                Text("할 일을 찾을 수 없습니다")
            }
        }
        .onAppear {
            viewModel.loadTodo()
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

#Preview {
    NavigationStack {
        TodoDetailView(viewModel: TodoDetailViewModel(
            todoId: UUID(),
            todoUseCase: PreviewTodoUseCase()
        ))
    }
}

private struct PreviewTodoUseCase: TodoUseCaseProtocol {
    func getAllTodos() async throws -> [Todo] {
        return [Todo(title: "샘플", description: "예시", priority: .high)]
    }
    
    func getTodo(id: UUID) async throws -> Todo {
        return Todo(id: id, title: "샘플 할 일", description: "상세 설명", priority: .medium)
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