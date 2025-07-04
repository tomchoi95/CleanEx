import SwiftUI

struct ContentView: View {
    var body: some View {
        DIContainer.shared.makeTodoListView()
    }
}

#Preview {
    ContentView()
}