import SwiftUI

struct TodoFormView: View {
    @StateObject private var viewModel: TodoFormViewModel
    @Environment(\.dismiss) private var dismiss
    @FocusState private var isTitleFocused: Bool
    
    init(viewModel: TodoFormViewModel, todo: Todo? = nil) {
        self._viewModel = StateObject(wrappedValue: viewModel)
        if let todo = todo {
            viewModel.setupForEditing(todo)
        }
    }
    
    var body: some View {
        Form {
            Section {
                // 제목 입력
                VStack(alignment: .leading, spacing: 8) {
                    Label("제목", systemImage: "text.cursor")
                        .font(.headline)
                        .foregroundColor(.primary)
                    
                    TextField("할 일 제목을 입력하세요", text: $viewModel.title)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .focused($isTitleFocused)
                        .submitLabel(.next)
                        .onSubmit {
                            isTitleFocused = false
                        }
                }
                
                // 설명 입력
                VStack(alignment: .leading, spacing: 8) {
                    Label("설명", systemImage: "text.alignleft")
                        .font(.headline)
                        .foregroundColor(.primary)
                    
                    TextField(
                        "할 일에 대한 자세한 설명 (선택사항)",
                        text: $viewModel.description,
                        axis: .vertical
                    )
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .lineLimit(3...6)
                }
                
                // 우선순위 선택
                VStack(alignment: .leading, spacing: 8) {
                    Label("우선순위", systemImage: "flag")
                        .font(.headline)
                        .foregroundColor(.primary)
                    
                    Picker("우선순위", selection: $viewModel.priority) {
                        ForEach(TodoPriority.allCases, id: \.self) { priority in
                            Label {
                                Text(priority.displayName)
                            } icon: {
                                Image(systemName: priority.icon)
                                    .foregroundColor(Color(priority.color))
                            }
                            .tag(priority)
                        }
                    }
                    .pickerStyle(SegmentedPickerStyle())
                }
                
            } header: {
                Text("할 일 정보")
            } footer: {
                Text("제목은 필수 항목입니다.")
                    .foregroundColor(.secondary)
            }
            
            // 완료 상태 (편집 모드에서만 표시)
            if viewModel.isEditing {
                Section {
                    Toggle(isOn: $viewModel.isCompleted) {
                        Label("완료 상태", systemImage: "checkmark.circle")
                            .font(.headline)
                    }
                    .toggleStyle(SwitchToggleStyle(tint: .green))
                } header: {
                    Text("상태")
                } footer: {
                    Text("완료된 할 일로 표시할지 선택하세요.")
                        .foregroundColor(.secondary)
                }
            }
            
            // 액션 버튼들
            Section {
                VStack(spacing: 12) {
                    // 저장 버튼
                    Button {
                        viewModel.submitTodo()
                    } label: {
                        HStack {
                            if viewModel.isLoading {
                                ProgressView()
                                    .scaleEffect(0.8)
                            } else {
                                Image(systemName: viewModel.isEditing ? "square.and.pencil" : "plus.circle.fill")
                            }
                            Text(viewModel.submitButtonTitle)
                                .font(.headline)
                        }
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(viewModel.isFormValid ? Color.blue : Color.gray)
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                    }
                    .disabled(!viewModel.isFormValid || viewModel.isLoading)
                    
                    // 리셋 버튼 (추가 모드에서만)
                    if !viewModel.isEditing {
                        Button {
                            viewModel.resetForm()
                            isTitleFocused = true
                        } label: {
                            HStack {
                                Image(systemName: "arrow.clockwise")
                                Text("초기화")
                                    .font(.headline)
                            }
                            .foregroundColor(.orange)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.orange.opacity(0.1))
                            .clipShape(RoundedRectangle(cornerRadius: 12))
                        }
                        .disabled(viewModel.isLoading)
                    }
                }
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button("저장") {
                    viewModel.submitTodo()
                }
                .disabled(!viewModel.isFormValid || viewModel.isLoading)
            }
        }
        .onAppear {
            if !viewModel.isEditing {
                isTitleFocused = true
            }
        }
        .onChange(of: viewModel.isSuccess) { success in
            if success {
                dismiss()
            }
        }
        .alert("오류", isPresented: .constant(viewModel.error != nil)) {
            Button("확인") {
                // Reset error handled by viewModel
            }
        } message: {
            Text(viewModel.error?.localizedDescription ?? "")
        }
    }
}

#Preview("추가 모드") {
    NavigationStack {
        TodoFormView(viewModel: DIContainer.shared.makeTodoFormViewModel())
            .navigationTitle("새 할 일")
    }
}

#Preview("편집 모드") {
    NavigationStack {
        TodoFormView(
            viewModel: DIContainer.shared.makeTodoFormViewModel(),
            todo: Todo(title: "샘플 할 일", description: "이것은 샘플 설명입니다.")
        )
        .navigationTitle("할 일 편집")
    }
}