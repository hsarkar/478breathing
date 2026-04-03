import Foundation
import Combine
import SwiftUI

class BreathingViewModel: ObservableObject {
    @Published var phase: BreathingPhase = .ready
    @Published var countdown: Int = 0
    @Published var currentSet: Int = 0
    @Published var isActive: Bool = false
    @Published var circleScale: CGFloat = 0.4

    private let audioService = AudioService()
    private var timer: Timer?
    private var sessionStartDate: Date?
    private var totalSets: Int = 4

    var progress: Double {
        guard totalSets > 0 else { return 0 }
        return Double(currentSet) / Double(totalSets)
    }

    var setLabel: String {
        if phase == .finished {
            return "\(totalSets) / \(totalSets) sets"
        }
        return "\(currentSet + 1) / \(totalSets) sets"
    }

    func start(sets: Int) {
        totalSets = sets
        currentSet = 0
        isActive = true
        sessionStartDate = Date()
        beginPhase(.ready)
    }

    func stop() -> BreathingSession? {
        timer?.invalidate()
        timer = nil
        audioService.stop()

        let session = createSession(completed: false)
        reset()
        return session
    }

    private func reset() {
        isActive = false
        phase = .ready
        countdown = 0
        currentSet = 0
        withAnimation(.easeInOut(duration: 0.5)) {
            circleScale = 0.4
        }
    }

    private func beginPhase(_ newPhase: BreathingPhase) {
        phase = newPhase
        countdown = newPhase.duration

        // Animate the circle
        let animDuration: Double
        switch newPhase {
        case .inhale: animDuration = Double(newPhase.duration)
        case .exhale: animDuration = Double(newPhase.duration)
        case .hold: animDuration = 0.3
        case .ready: animDuration = 0.5
        case .finished: animDuration = 0.8
        }

        withAnimation(.easeInOut(duration: animDuration)) {
            circleScale = newPhase.circleScale
        }

        audioService.speak(newPhase.voicePrompt)

        guard newPhase != .finished else {
            isActive = false
            return
        }

        startCountdown()
    }

    private func startCountdown() {
        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] _ in
            self?.tick()
        }
    }

    private func tick() {
        guard countdown > 1 else {
            timer?.invalidate()
            advancePhase()
            return
        }

        countdown -= 1
    }

    private func advancePhase() {
        switch phase {
        case .ready:
            beginPhase(.inhale)
        case .inhale:
            beginPhase(.hold)
        case .hold:
            beginPhase(.exhale)
        case .exhale:
            currentSet += 1
            if currentSet >= totalSets {
                beginPhase(.finished)
            } else {
                beginPhase(.inhale)
            }
        case .finished:
            break
        }
    }

    func createCompletedSession() -> BreathingSession {
        return createSession(completed: true)
    }

    private func createSession(completed: Bool) -> BreathingSession {
        let duration = Int(Date().timeIntervalSince(sessionStartDate ?? Date()))
        return BreathingSession(
            sets: completed ? totalSets : currentSet,
            durationSeconds: duration,
            completed: completed
        )
    }
}
