import AVFoundation

class AudioService: NSObject, ObservableObject, AVSpeechSynthesizerDelegate, @unchecked Sendable {
    private let synthesizer = AVSpeechSynthesizer()
    private var femaleVoice: AVSpeechSynthesisVoice?

    override init() {
        super.init()
        synthesizer.delegate = self
        configureAudioSession()
        selectFemaleVoice()
    }

    private func configureAudioSession() {
        do {
            let session = AVAudioSession.sharedInstance()
            try session.setCategory(.playback, mode: .default, options: [.duckOthers])
            try session.setActive(true)
        } catch {
            print("Audio session configuration failed: \(error)")
        }
    }

    private func selectFemaleVoice() {
        // Prefer Samantha (US English female) — the classic iOS female voice
        let preferredVoiceIDs = [
            "com.apple.voice.enhanced.en-US.Samantha",
            "com.apple.voice.premium.en-US.Samantha",
            "com.apple.ttsbundle.Samantha-compact",
            "com.apple.voice.compact.en-US.Samantha",
            "com.apple.voice.enhanced.en-GB.Kate",
            "com.apple.voice.compact.en-GB.Kate",
            "com.apple.voice.enhanced.en-AU.Karen",
            "com.apple.voice.compact.en-AU.Karen"
        ]

        for voiceID in preferredVoiceIDs {
            if let voice = AVSpeechSynthesisVoice(identifier: voiceID) {
                femaleVoice = voice
                return
            }
        }

        // Fallback: find any English female voice
        let englishVoices = AVSpeechSynthesisVoice.speechVoices().filter {
            $0.language.hasPrefix("en")
        }
        femaleVoice = englishVoices.first ?? AVSpeechSynthesisVoice(language: "en-US")
    }

    func speak(_ text: String) {
        synthesizer.stopSpeaking(at: .immediate)

        let utterance = AVSpeechUtterance(string: text)
        utterance.voice = femaleVoice
        utterance.rate = AVSpeechUtteranceDefaultSpeechRate * 0.9
        utterance.pitchMultiplier = 1.1
        utterance.volume = 1.0
        utterance.preUtteranceDelay = 0.1
        utterance.postUtteranceDelay = 0.1

        synthesizer.speak(utterance)
    }

    func speakCount(_ count: Int) {
        let utterance = AVSpeechUtterance(string: "\(count)")
        utterance.voice = femaleVoice
        utterance.rate = AVSpeechUtteranceDefaultSpeechRate * 0.85
        utterance.pitchMultiplier = 1.05
        utterance.volume = 0.7
        utterance.preUtteranceDelay = 0
        utterance.postUtteranceDelay = 0

        synthesizer.speak(utterance)
    }

    func stop() {
        synthesizer.stopSpeaking(at: .immediate)
    }
}
