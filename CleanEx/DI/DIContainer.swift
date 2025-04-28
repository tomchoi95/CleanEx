//
//  DIContainer.swift
//  CleanEx
//
//  Created by 최범수 on 2025-04-27.
//

import Foundation
import SwiftUI

final class DIContainer {
    static let shared = DIContainer()
    
    private init() {}
    
    // MARK: - Repositories
    private lazy var todoRepository: TodoRepository = {
        return TodoRepositoryImpl(
            localDataSource: TodoLocalDataSource()
        )
    }()
    
    // MARK: - UseCases
    private lazy var todoUseCase: TodoUseCase = {
        return TodoUseCaseImpl(repository: todoRepository)
    }()
    
    // MARK: - ViewModels
    func makeTodoListViewModel() -> TodoListViewModel {
        return TodoListViewModel(useCase: todoUseCase)
    }
    
    func makeTodoDetailViewModel(todo: Todo) -> TodoDetailViewModel {
        return TodoDetailViewModel(useCase: todoUseCase, todo: todo)
    }
    
    // MARK: - Views
    func makeTodoListView() -> some View {
        TodoListView(viewModel: makeTodoListViewModel())
    }
    
    func makeTodoDetailView(todo: Todo) -> some View {
        TodoDetailView(viewModel: makeTodoDetailViewModel(todo: todo))
    }
}
