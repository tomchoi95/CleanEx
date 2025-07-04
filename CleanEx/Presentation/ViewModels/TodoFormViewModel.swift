import Foundation

@MainActor
final class TodoFormViewModel: ObservableObject {
    private let addTodoUseCase: AddTodoUseCase
    private let updateTodoUseCase: UpdateTodoUseCase
    
    @Published var title: String = ""
    @Published var description: String = ""
    @Published var isCompleted: Bool = false
    @Published var priority: TodoPriority = .medium
    @Published private(set) var error: TodoViewError?
    @Published private(set) var isLoading = false
    @Published private(set) var isSuccess = false
    
    private var editingTodo: Todo?
    
    var isEditing: Bool {
        editingTodo != nil
    }
    
    var submitButtonTitle: String {
        isEditing ? "수정" : "추가"
    }
    
    init(
        addTodoUseCase: AddTodoUseCase,
        updateTodoUseCase: UpdateTodoUseCase
    ) {
        self.addTodoUseCase = addTodoUseCase
        self.updateTodoUseCase = updateTodoUseCase
    }
    
    func setupForEditing(_ todo: Todo) {
        editingTodo = todo
        title = todo.title
        description = todo.description ?? ""
        isCompleted = todo.isCompleted
        priority = todo.priority
    }
    
    func resetForm() {
        title = ""
        description = ""
        isCompleted = false
        priority = .medium
        error = nil
        isSuccess = false
        editingTodo = nil
    }
    
    func submitTodo() {
        guard !title.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
            error = .failedToCreate
            return
        }
        
        Task {
            isLoading = true
            error = nil
            
            do {
                if let editingTodo = editingTodo {
                    // 편집 모드
                    _ = try await updateTodoUseCase.execute(
                        id: editingTodo.id,
                        title: title.trimmingCharacters(in: .whitespacesAndNewlines),
                        description: description.isEmpty ? nil : description,
                        isCompleted: isCompleted,
                        priority: priority
                    )
                } else {
                    // 추가 모드
                    _ = try await addTodoUseCase.execute(
                        title: title.trimmingCharacters(in: .whitespacesAndNewlines),
                        description: description.isEmpty ? nil : description,
                        priority: priority
                    )
                }
                isSuccess = true
            } catch {
                self.error = isEditing ? .failedToUpdate : .failedToCreate
            }
            
            isLoading = false
        }
    }
    
    var isFormValid: Bool {
        !title.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }
}