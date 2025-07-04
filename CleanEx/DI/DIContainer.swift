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
    static let shared = DIContainer()
    
    private let modelContainer: ModelContainer
    
    private init() {
        do {
            modelContainer = try ModelContainer(for: TodoLocalModel.self)
        } catch {
            fatalError("Failed to create ModelContainer: \(error)")
        }
    }
    
    // MARK: - Data Sources
    private lazy var todoLocalDataSource: TodoLocalDataSource = {
        return TodoLocalDataSourceImpl(modelContext: modelContainer.mainContext)
    }()
    
    // MARK: - Repositories
    private lazy var todoRepository: TodoRepository = {
        return TodoRepositoryImpl(dataSource: todoLocalDataSource)
    }()
    
    // MARK: - UseCases
    private lazy var getAllTodosUseCase: GetAllTodosUseCase = {
        return GetAllTodosUseCaseImpl(repository: todoRepository)
    }()
    
    private lazy var getTodoUseCase: GetTodoUseCase = {
        return GetTodoUseCaseImpl(repository: todoRepository)
    }()
    
    private lazy var addTodoUseCase: AddTodoUseCase = {
        return AddTodoUseCaseImpl(repository: todoRepository)
    }()
    
    private lazy var updateTodoUseCase: UpdateTodoUseCase = {
        return UpdateTodoUseCaseImpl(repository: todoRepository)
    }()
    
    private lazy var deleteTodoUseCase: DeleteTodoUseCase = {
        return DeleteTodoUseCaseImpl(repository: todoRepository)
    }()
    
    // MARK: - ViewModels
    func makeTodoListViewModel() -> TodoListViewModel {
        return TodoListViewModel(
            getAllTodosUseCase: getAllTodosUseCase,
            deleteTodoUseCase: deleteTodoUseCase
        )
    }
    
    func makeTodoDetailViewModel() -> TodoDetailViewModel {
        return TodoDetailViewModel(
            getTodoUseCase: getTodoUseCase,
            updateTodoUseCase: updateTodoUseCase
        )
    }
    
    func makeTodoFormViewModel() -> TodoFormViewModel {
        return TodoFormViewModel(
            addTodoUseCase: addTodoUseCase,
            updateTodoUseCase: updateTodoUseCase
        )
    }
    
    // MARK: - Views
    func makeTodoListView() -> some View {
        TodoListView(viewModel: makeTodoListViewModel())
    }
    
    func makeTodoDetailView(todoId: UUID) -> some View {
        TodoDetailView(viewModel: makeTodoDetailViewModel(), todoId: todoId)
    }
    
    func makeTodoFormView(todo: Todo? = nil) -> some View {
        TodoFormView(viewModel: makeTodoFormViewModel(), todo: todo)
    }
}
