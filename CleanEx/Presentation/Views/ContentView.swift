import SwiftUI
import SwiftData

struct ContentView: View {
    @Environment(\.modelContext) private var modelContext
    
    var body: some View {
        NavigationStack {
            DIContainer.make(modelContext: modelContext).makeTodoListView()
                .navigationTitle("Todos")
        }
    }
}

#Preview {
    ContentView()
        .modelContainer(for: [TodoLocalModel.self])
}