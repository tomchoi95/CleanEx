import SwiftUI
import SwiftData
import Presentation
import Domain
import Data

@main
struct CleanExApp: App {
    let container: ModelContainer
    
    init() {
        do {
            container = try ModelContainer(for: TodoLocalModel.self)
        } catch {
            fatalError("Failed to create ModelContainer: \(error)")
        }
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView(todoListView: makeTodoListView())
                .modelContainer(container)
        }
    }
    
    private func makeTodoListView() -> TodoListView {
        let context = container.mainContext
        let dataSource = TodoLocalDataSourceImpl(modelContext: context)
        let repository = TodoRepositoryImpl(dataSource: dataSource)
        let useCase = Domain.TodoUseCaseImpl(repository: repository)
        let viewModel = TodoListViewModel(todoUseCase: useCase)
        return TodoListView(viewModel: viewModel)
    }
}