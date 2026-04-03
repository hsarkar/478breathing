import SwiftUI

struct ContentView: View {
    var body: some View {
        TabView {
            BreathingView()
                .tabItem {
                    Label("Breathe", systemImage: "wind")
                }

            HistoryView()
                .tabItem {
                    Label("History", systemImage: "clock.arrow.circlepath")
                }
        }
        .tint(.cyan)
    }
}

#Preview {
    ContentView()
}
