import Foundation

class SessionStore: ObservableObject {
    private static let key = "breathing_sessions"
    private static let setsKey = "breathing_sets"

    @Published var sessions: [BreathingSession] = []
    @Published var numberOfSets: Int {
        didSet {
            UserDefaults.standard.set(numberOfSets, forKey: Self.setsKey)
        }
    }

    init() {
        let savedSets = UserDefaults.standard.integer(forKey: Self.setsKey)
        self.numberOfSets = savedSets > 0 ? savedSets : 4
        self.sessions = Self.loadSessions()
    }

    func save(session: BreathingSession) {
        sessions.insert(session, at: 0)
        persistSessions()
    }

    func deleteSession(at offsets: IndexSet) {
        sessions.remove(atOffsets: offsets)
        persistSessions()
    }

    func clearHistory() {
        sessions.removeAll()
        persistSessions()
    }

    private func persistSessions() {
        if let data = try? JSONEncoder().encode(sessions) {
            UserDefaults.standard.set(data, forKey: Self.key)
        }
    }

    private static func loadSessions() -> [BreathingSession] {
        guard let data = UserDefaults.standard.data(forKey: key),
              let sessions = try? JSONDecoder().decode([BreathingSession].self, from: data) else {
            return []
        }
        return sessions
    }
}
