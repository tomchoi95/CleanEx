//
//  DIContainer.swift
//  CleanEx
//
//  Created by 최범수 on 2025-04-27.
//

import Foundation
import SwiftUI
import SwiftData

final class DIContainer {
    static func make(modelContext: ModelContext) -> DIContainer {
        return DIContainer(modelContext: modelContext)
    }
    
    private let modelContext: ModelContext
    
    private init(modelContext: ModelContext) {
        self.modelContext = modelContext
    }
    
    // MARK: - DataSources
    private lazy var todoLocalDataSource: TodoLocalDataSource = {
        TodoLocalDataSourceImpl(modelContext: modelContext)
    }()
    
    // MARK: - Repositories
    private lazy var todoRepository: TodoRepository = {
        TodoRepositoryImpl(dataSource: todoLocalDataSource)
    }()
    
    // MARK: - UseCases
    private lazy var getAllTodosUseCase: GetAllTodosUseCase = {
        GetAllTodosUseCaseImpl(repository: todoRepository)
    }()
    private lazy var getTodoUseCase: GetTodoUseCase = {
        GetTodoUseCaseImpl(repository: todoRepository)
    }()
    private lazy var addTodoUseCase: AddTodoUseCase = {
        AddTodoUseCaseImpl(repository: todoRepository)
    }()
    private lazy var updateTodoUseCase: UpdateTodoUseCase = {
        UpdateTodoUseCaseImpl(repository: todoRepository)
    }()
    private lazy var deleteTodoUseCase: DeleteTodoUseCase = {
        DeleteTodoUseCaseImpl(repository: todoRepository)
    }()
    private lazy var toggleTodoCompletionUseCase: ToggleTodoCompletionUseCase = {
        ToggleTodoCompletionUseCaseImpl(repository: todoRepository)
    }()
    private lazy var searchTodosUseCase: SearchTodosUseCase = {
        SearchTodosUseCaseImpl(repository: todoRepository)
    }()
    
    // MARK: - ViewModels
    func makeTodoListViewModel() -> TodoListViewModel {
        return TodoListViewModel(
            getAllTodosUseCase: getAllTodosUseCase,
            deleteTodoUseCase: deleteTodoUseCase,
            addTodoUseCase: addTodoUseCase,
            toggleCompletionUseCase: toggleTodoCompletionUseCase,
            searchTodosUseCase: searchTodosUseCase
        )
    }
    
    func makeTodoDetailViewModel(todoId: UUID) -> TodoDetailViewModel {
        let vm = TodoDetailViewModel(
            getTodoUseCase: getTodoUseCase,
            updateTodoUseCase: updateTodoUseCase,
            toggleCompletionUseCase: toggleTodoCompletionUseCase
        )
        vm.loadTodo(id: todoId)
        return vm
    }
    
    // MARK: - Views
    func makeTodoListView() -> some View {
        TodoListView(viewModel: makeTodoListViewModel(), container: self)
    }
    
    func makeTodoDetailView(todoId: UUID) -> some View {
        TodoDetailView(viewModel: makeTodoDetailViewModel(todoId: todoId))
    }
}
