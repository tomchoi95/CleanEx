import SwiftUI

struct TodoDetailView: View {
    @StateObject private var viewModel: TodoDetailViewModel
    @State private var showingEditSheet = false
    @Environment(\.dismiss) private var dismiss
    
    private let todoId: UUID
    
    init(viewModel: TodoDetailViewModel, todoId: UUID) {
        self._viewModel = StateObject(wrappedValue: viewModel)
        self.todoId = todoId
    }
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                if viewModel.isLoading {
                    VStack {
                        ProgressView("로딩 중...")
                        Spacer()
                    }
                    .frame(maxWidth: .infinity, minHeight: 300)
                } else if let todo = viewModel.todo {
                    // 헤더 섹션
                    VStack(alignment: .leading, spacing: 16) {
                        HStack {
                            Text(todo.title)
                                .font(.largeTitle)
                                .fontWeight(.bold)
                                .strikethrough(todo.isCompleted)
                                .foregroundColor(todo.isCompleted ? .secondary : .primary)
                            
                            Spacer()
                            
                            Button {
                                toggleComplete()
                            } label: {
                                Image(systemName: todo.isCompleted ? "checkmark.circle.fill" : "circle")
                                    .foregroundColor(todo.isCompleted ? .green : .gray)
                                    .font(.title)
                            }
                        }
                        
                        // 상태 배지
                        HStack {
                            Label(
                                todo.isCompleted ? "완료됨" : "진행 중",
                                systemImage: todo.isCompleted ? "checkmark.seal.fill" : "clock"
                            )
                            .font(.caption)
                            .padding(.horizontal, 12)
                            .padding(.vertical, 6)
                            .background(
                                (todo.isCompleted ? Color.green : Color.orange)
                                    .opacity(0.2)
                            )
                            .foregroundColor(todo.isCompleted ? .green : .orange)
                            .clipShape(Capsule())
                            
                            // 우선순위 배지
                            Label(todo.priority.displayName, systemImage: todo.priority.icon)
                                .font(.caption)
                                .padding(.horizontal, 12)
                                .padding(.vertical, 6)
                                .background(Color(todo.priority.color).opacity(0.2))
                                .foregroundColor(Color(todo.priority.color))
                                .clipShape(Capsule())
                            
                            Spacer()
                        }
                    }
                    .padding(.horizontal)
                    
                    Divider()
                    
                    // 설명 섹션
                    VStack(alignment: .leading, spacing: 12) {
                        Label("설명", systemImage: "text.alignleft")
                            .font(.headline)
                            .foregroundColor(.primary)
                        
                        if let description = todo.description, !description.isEmpty {
                            Text(description)
                                .font(.body)
                                .foregroundColor(.secondary)
                                .padding()
                                .background(Color(.systemGray6))
                                .clipShape(RoundedRectangle(cornerRadius: 12))
                        } else {
                            Text("설명이 없습니다.")
                                .font(.body)
                                .foregroundColor(.tertiary)
                                .italic()
                                .padding()
                                .background(Color(.systemGray6))
                                .clipShape(RoundedRectangle(cornerRadius: 12))
                        }
                    }
                    .padding(.horizontal)
                    
                    Divider()
                    
                    // 정보 섹션
                    VStack(alignment: .leading, spacing: 16) {
                        Label("정보", systemImage: "info.circle")
                            .font(.headline)
                            .foregroundColor(.primary)
                        
                        VStack(spacing: 12) {
                            InfoRow(
                                title: "생성일",
                                value: todo.createdAt.formatted(date: .complete, time: .shortened),
                                icon: "calendar"
                            )
                            
                            InfoRow(
                                title: "수정일",
                                value: todo.updatedAt.formatted(date: .complete, time: .shortened),
                                icon: "calendar.badge.clock"
                            )
                            
                            InfoRow(
                                title: "ID",
                                value: todo.id.uuidString,
                                icon: "number"
                            )
                        }
                    }
                    .padding(.horizontal)
                    
                    Spacer(minLength: 100)
                } else {
                    VStack(spacing: 16) {
                        Image(systemName: "exclamationmark.triangle")
                            .font(.system(size: 60))
                            .foregroundColor(.orange)
                        Text("할 일을 찾을 수 없습니다")
                            .font(.title2)
                            .foregroundColor(.secondary)
                        Button("목록으로 돌아가기") {
                            dismiss()
                        }
                        .buttonStyle(.borderedProminent)
                    }
                    .frame(maxWidth: .infinity, minHeight: 300)
                }
            }
            .padding(.vertical)
        }
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                if viewModel.todo != nil {
                    Button("편집") {
                        showingEditSheet = true
                    }
                }
            }
        }
        .onAppear {
            viewModel.loadTodo(id: todoId)
        }
        .refreshable {
            viewModel.loadTodo(id: todoId)
        }
        .sheet(isPresented: $showingEditSheet) {
            if let todo = viewModel.todo {
                NavigationStack {
                    TodoFormView(
                        viewModel: DIContainer.shared.makeTodoFormViewModel(),
                        todo: todo
                    )
                    .navigationTitle("할 일 편집")
                    .navigationBarTitleDisplayMode(.inline)
                    .toolbar {
                        ToolbarItem(placement: .navigationBarLeading) {
                            Button("취소") {
                                showingEditSheet = false
                            }
                        }
                    }
                }
                .onDisappear {
                    viewModel.loadTodo(id: todoId)
                }
            }
        }
        .alert("오류", isPresented: .constant(viewModel.error != nil)) {
            Button("확인") {
                // Reset error
            }
        } message: {
            Text(viewModel.error?.localizedDescription ?? "")
        }
    }
    
    private func toggleComplete() {
        guard let todo = viewModel.todo else { return }
        viewModel.updateTodo(
            title: todo.title,
            description: todo.description,
            isCompleted: !todo.isCompleted,
            priority: todo.priority
        )
    }
}

struct InfoRow: View {
    let title: String
    let value: String
    let icon: String
    
    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: icon)
                .foregroundColor(.blue)
                .frame(width: 20)
            
            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(.caption)
                    .foregroundColor(.secondary)
                Text(value)
                    .font(.body)
                    .foregroundColor(.primary)
            }
            
            Spacer()
        }
        .padding()
        .background(Color(.systemGray6))
        .clipShape(RoundedRectangle(cornerRadius: 10))
    }
}

#Preview {
    NavigationStack {
        TodoDetailView(
            viewModel: DIContainer.shared.makeTodoDetailViewModel(),
            todoId: UUID()
        )
    }
}