import SwiftUI

struct HistoryView: View {
    @EnvironmentObject private var store: SessionStore

    var body: some View {
        NavigationStack {
            ZStack {
                Color(red: 0.05, green: 0.05, blue: 0.15)
                    .ignoresSafeArea()

                if store.sessions.isEmpty {
                    emptyState
                } else {
                    sessionList
                }
            }
            .navigationTitle("History")
            .toolbarColorScheme(.dark, for: .navigationBar)
            .toolbar {
                if !store.sessions.isEmpty {
                    ToolbarItem(placement: .topBarTrailing) {
                        Button("Clear") {
                            store.clearHistory()
                        }
                        .foregroundStyle(.red.opacity(0.8))
                    }
                }
            }
        }
    }

    private var emptyState: some View {
        VStack(spacing: 16) {
            Image(systemName: "wind")
                .font(.system(size: 48))
                .foregroundStyle(.white.opacity(0.3))
            Text("No sessions yet")
                .font(.system(size: 20, weight: .light, design: .rounded))
                .foregroundStyle(.white.opacity(0.5))
            Text("Complete a breathing session to see it here")
                .font(.system(size: 14, weight: .light))
                .foregroundStyle(.white.opacity(0.3))
        }
    }

    private var sessionList: some View {
        List {
            ForEach(store.sessions) { session in
                SessionRow(session: session)
                    .listRowBackground(Color.white.opacity(0.05))
            }
            .onDelete(perform: store.deleteSession)
        }
        .scrollContentBackground(.hidden)
    }
}

struct SessionRow: View {
    let session: BreathingSession

    var body: some View {
        HStack(spacing: 16) {
            // Status icon
            ZStack {
                Circle()
                    .fill(session.completed ? .green.opacity(0.2) : .orange.opacity(0.2))
                    .frame(width: 44, height: 44)
                Image(systemName: session.completed ? "checkmark.circle.fill" : "xmark.circle")
                    .foregroundStyle(session.completed ? .green : .orange)
                    .font(.system(size: 20))
            }

            VStack(alignment: .leading, spacing: 4) {
                Text("\(session.sets) \(session.sets == 1 ? "set" : "sets")")
                    .font(.system(size: 17, weight: .medium, design: .rounded))
                    .foregroundStyle(.white)

                Text(session.formattedDate)
                    .font(.system(size: 13, weight: .light))
                    .foregroundStyle(.white.opacity(0.5))
            }

            Spacer()

            VStack(alignment: .trailing, spacing: 4) {
                Text(session.formattedDuration)
                    .font(.system(size: 15, weight: .light, design: .monospaced))
                    .foregroundStyle(.cyan)

                Text(session.completed ? "Completed" : "Stopped")
                    .font(.system(size: 12, weight: .light))
                    .foregroundStyle(session.completed ? .green.opacity(0.7) : .orange.opacity(0.7))
            }
        }
        .padding(.vertical, 4)
    }
}

#Preview {
    HistoryView()
}
