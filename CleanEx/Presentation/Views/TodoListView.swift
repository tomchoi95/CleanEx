import SwiftUI

struct TodoListView: View {
    @StateObject private var viewModel: TodoListViewModel
    @State private var showingAddSheet = false
    @State private var showingStatsSheet = false
    @State private var searchText = ""
    @State private var showCompletedOnly = false
    @State private var selectedPriority: TodoPriority?
    
    init(viewModel: TodoListViewModel) {
        self._viewModel = StateObject(wrappedValue: viewModel)
    }
    
    private var filteredTodos: [Todo] {
        var filtered = viewModel.todos
        
        // 검색 필터
        if !searchText.isEmpty {
            filtered = filtered.filter {
                $0.title.localizedCaseInsensitiveContains(searchText) ||
                ($0.description?.localizedCaseInsensitiveContains(searchText) ?? false)
            }
        }
        
        // 완료 상태 필터
        if showCompletedOnly {
            filtered = filtered.filter { $0.isCompleted }
        }
        
        // 우선순위 필터
        if let selectedPriority = selectedPriority {
            filtered = filtered.filter { $0.priority == selectedPriority }
        }
        
        // 우선순위순으로 정렬 (높음 > 보통 > 낮음), 그 다음 생성일순
        return filtered.sorted { todo1, todo2 in
            if todo1.priority != todo2.priority {
                return todo1.priority.rawValue > todo2.priority.rawValue
            }
            return todo1.createdAt > todo2.createdAt
        }
    }
    
    var body: some View {
        NavigationStack {
            VStack {
                // 검색 및 필터 바
                VStack(spacing: 12) {
                    // 검색 바
                    HStack {
                        Image(systemName: "magnifyingglass")
                            .foregroundColor(.gray)
                        TextField("할 일 검색...", text: $searchText)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                    }
                    
                    // 필터 옵션들
                    VStack(spacing: 8) {
                        // 완료 상태 필터
                        HStack {
                            Toggle("완료된 항목만 보기", isOn: $showCompletedOnly)
                                .toggleStyle(SwitchToggleStyle(tint: .blue))
                            Spacer()
                        }
                        
                        // 우선순위 필터
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 8) {
                                Button("전체") {
                                    selectedPriority = nil
                                }
                                .buttonStyle(FilterButtonStyle(isSelected: selectedPriority == nil))
                                
                                ForEach(TodoPriority.allCases, id: \.self) { priority in
                                    Button(priority.displayName) {
                                        selectedPriority = selectedPriority == priority ? nil : priority
                                    }
                                    .buttonStyle(FilterButtonStyle(isSelected: selectedPriority == priority))
                                }
                            }
                            .padding(.horizontal)
                        }
                    }
                }
                .padding(.horizontal)
                .background(Color(.systemGray6))
                
                // 할 일 목록
                if viewModel.isLoading && viewModel.todos.isEmpty {
                    Spacer()
                    ProgressView("로딩 중...")
                    Spacer()
                } else if filteredTodos.isEmpty {
                    Spacer()
                    VStack(spacing: 16) {
                        Image(systemName: searchText.isEmpty ? "checkmark.circle" : "magnifyingglass")
                            .font(.system(size: 60))
                            .foregroundColor(.gray)
                        Text(searchText.isEmpty ? "할 일이 없습니다" : "검색 결과가 없습니다")
                            .font(.title2)
                            .foregroundColor(.gray)
                        if searchText.isEmpty {
                            Button("첫 번째 할 일 추가하기") {
                                showingAddSheet = true
                            }
                            .buttonStyle(.borderedProminent)
                        }
                    }
                    Spacer()
                } else {
                    List {
                        ForEach(filteredTodos, id: \.id) { todo in
                            TodoRowView(
                                todo: todo,
                                onToggleComplete: { toggleComplete(todo) },
                                onDelete: { deleteTodo(todo) }
                            )
                        }
                        .onDelete(perform: deleteTodos)
                    }
                    .listStyle(PlainListStyle())
                }
            }
            .navigationTitle("할 일 목록")
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItemGroup(placement: .navigationBarTrailing) {
                    if !viewModel.todos.isEmpty {
                        Button {
                            showingStatsSheet = true
                        } label: {
                            Image(systemName: "chart.bar")
                        }
                    }
                    
                    Button {
                        showingAddSheet = true
                    } label: {
                        Image(systemName: "plus")
                    }
                }
                
                if !viewModel.todos.isEmpty {
                    ToolbarItem(placement: .navigationBarLeading) {
                        Button {
                            viewModel.loadTodos()
                        } label: {
                            Image(systemName: "arrow.clockwise")
                        }
                        .disabled(viewModel.isLoading)
                    }
                }
            }
            .onAppear {
                viewModel.loadTodos()
            }
            .refreshable {
                viewModel.loadTodos()
            }
            .sheet(isPresented: $showingAddSheet) {
                NavigationStack {
                    TodoFormView(
                        viewModel: DIContainer.shared.makeTodoFormViewModel()
                    )
                    .navigationTitle("새 할 일")
                    .navigationBarTitleDisplayMode(.inline)
                    .toolbar {
                        ToolbarItem(placement: .navigationBarLeading) {
                            Button("취소") {
                                showingAddSheet = false
                            }
                        }
                    }
                }
                .onDisappear {
                    viewModel.loadTodos()
                }
            }
            .sheet(isPresented: $showingStatsSheet) {
                TodoStatisticsView(
                    statistics: TodoStatistics.calculate(from: viewModel.todos)
                )
            }
            .alert("오류", isPresented: .constant(viewModel.error != nil)) {
                Button("확인") {
                    // Reset error
                }
            } message: {
                Text(viewModel.error?.localizedDescription ?? "")
            }
        }
    }
    
    private func toggleComplete(_ todo: Todo) {
        // 완료 상태 토글 로직은 TodoDetailView에서 처리
    }
    
    private func deleteTodo(_ todo: Todo) {
        viewModel.deleteTodo(id: todo.id)
    }
    
    private func deleteTodos(offsets: IndexSet) {
        offsets.forEach { index in
            let todo = filteredTodos[index]
            viewModel.deleteTodo(id: todo.id)
        }
    }
}

struct TodoRowView: View {
    let todo: Todo
    let onToggleComplete: () -> Void
    let onDelete: () -> Void
    
    var body: some View {
        NavigationLink(destination: TodoDetailView(
            viewModel: DIContainer.shared.makeTodoDetailViewModel(),
            todoId: todo.id
        )) {
            HStack(spacing: 12) {
                // 완료 버튼
                Button(action: onToggleComplete) {
                    Image(systemName: todo.isCompleted ? "checkmark.circle.fill" : "circle")
                        .foregroundColor(todo.isCompleted ? .green : .gray)
                        .font(.title2)
                }
                .buttonStyle(PlainButtonStyle())
                
                // 할 일 내용
                VStack(alignment: .leading, spacing: 4) {
                    HStack {
                        Text(todo.title)
                            .font(.headline)
                            .strikethrough(todo.isCompleted)
                            .foregroundColor(todo.isCompleted ? .gray : .primary)
                        
                        Spacer()
                        
                        // 우선순위 표시
                        Label(todo.priority.displayName, systemImage: todo.priority.icon)
                            .font(.caption2)
                            .foregroundColor(Color(todo.priority.color))
                            .padding(.horizontal, 6)
                            .padding(.vertical, 2)
                            .background(Color(todo.priority.color).opacity(0.1))
                            .clipShape(Capsule())
                    }
                    
                    if let description = todo.description, !description.isEmpty {
                        Text(description)
                            .font(.caption)
                            .foregroundColor(.secondary)
                            .lineLimit(2)
                    }
                    
                    Text(todo.createdAt.formatted(date: .abbreviated, time: .shortened))
                        .font(.caption2)
                        .foregroundColor(.secondary)
                }
                
                Spacer()
                
                // 상태 표시
                if todo.isCompleted {
                    Image(systemName: "checkmark.seal.fill")
                        .foregroundColor(.green)
                        .font(.caption)
                }
            }
            .padding(.vertical, 4)
        }
        .swipeActions(edge: .trailing, allowsFullSwipe: true) {
            Button(role: .destructive) {
                onDelete()
            } label: {
                Label("삭제", systemImage: "trash")
            }
        }
    }
}

struct FilterButtonStyle: ButtonStyle {
    let isSelected: Bool
    
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.caption)
            .fontWeight(.medium)
            .padding(.horizontal, 12)
            .padding(.vertical, 6)
            .background(isSelected ? Color.blue : Color(.systemGray5))
            .foregroundColor(isSelected ? .white : .primary)
            .clipShape(Capsule())
            .scaleEffect(configuration.isPressed ? 0.95 : 1.0)
            .animation(.easeInOut(duration: 0.1), value: configuration.isPressed)
    }
}

#Preview {
    TodoListView(viewModel: DIContainer.shared.makeTodoListViewModel())
}