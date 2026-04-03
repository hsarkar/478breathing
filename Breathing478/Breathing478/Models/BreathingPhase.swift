import SwiftUI

enum BreathingPhase: String {
    case ready = "Get Ready"
    case inhale = "Breathe In"
    case hold = "Hold"
    case exhale = "Breathe Out"
    case finished = "Well Done"

    var duration: Int {
        switch self {
        case .ready: return 3
        case .inhale: return 4
        case .hold: return 7
        case .exhale: return 8
        case .finished: return 0
        }
    }

    var color: Color {
        switch self {
        case .ready: return .gray
        case .inhale: return .cyan
        case .hold: return .purple
        case .exhale: return .indigo
        case .finished: return .green
        }
    }

    var voicePrompt: String {
        switch self {
        case .ready: return "Get ready"
        case .inhale: return "Breathe in"
        case .hold: return "Hold"
        case .exhale: return "Breathe out slowly"
        case .finished: return "Well done. Great session."
        }
    }

    /// Scale factor for the breathing circle animation
    var circleScale: CGFloat {
        switch self {
        case .ready: return 0.4
        case .inhale: return 1.0
        case .hold: return 1.0
        case .exhale: return 0.4
        case .finished: return 0.6
        }
    }
}
