import SwiftUI

struct ContentView: View {
    var body: some View {
        NavigationStack {
            ContentUnavailableView(
                "Welcome to Immich",
                systemImage: "photo.on.rectangle.angled",
                description: Text("Connect to your Immich server to get started.")
            )
            .navigationTitle("Photos")
        }
    }
}

#Preview {
    ContentView()
}
