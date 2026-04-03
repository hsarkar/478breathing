import Foundation

struct BreathingSession: Codable, Identifiable {
    let id: UUID
    let date: Date
    let sets: Int
    let durationSeconds: Int
    let completed: Bool

    init(id: UUID = UUID(), date: Date = Date(), sets: Int, durationSeconds: Int, completed: Bool) {
        self.id = id
        self.date = date
        self.sets = sets
        self.durationSeconds = durationSeconds
        self.completed = completed
    }

    var formattedDuration: String {
        let minutes = durationSeconds / 60
        let seconds = durationSeconds % 60
        if minutes > 0 {
            return "\(minutes)m \(seconds)s"
        }
        return "\(seconds)s"
    }

    var formattedDate: String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        return formatter.string(from: date)
    }
}
