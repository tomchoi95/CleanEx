import SwiftUI
import SwiftData

struct ContentView: View {
    @Environment(\.modelContext) private var modelContext
    
    var body: some View {
        let container = DIContainer.make(modelContext: modelContext)
        TabView {
            NavigationStack {
                container.makeTodoListView()
                    .navigationTitle("Todos")
            }
            .tabItem {
                Label("목록", systemImage: "list.bullet")
            }
            
            NavigationStack {
                container.makeTodoCalendarView()
                    .navigationTitle("캘린더")
            }
            .tabItem {
                Label("캘린더", systemImage: "calendar")
            }
        }
    }
}

#Preview {
    ContentView()
        .modelContainer(for: [TodoLocalModel.self])
}