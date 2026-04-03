# 478 Breathing

A 4-7-8 breathing exercise app for iOS with voice-guided audio and animated visuals.

The 4-7-8 technique, developed by Dr. Andrew Weil, helps reduce anxiety, improve sleep, and manage stress:

- **4 seconds** — Breathe in through your nose
- **7 seconds** — Hold your breath
- **8 seconds** — Exhale slowly through your mouth

## Features

- Animated breathing circle that expands and contracts with each phase
- Voice guidance using a female English voice (AVSpeechSynthesizer)
- Configurable number of sets (1–20)
- Session history with duration tracking and completion status

## Install on iPhone

### Prerequisites

- A Mac with [Xcode](https://developer.apple.com/xcode/) installed (15.0+)
- An Apple ID (free — no paid developer account required for personal devices)
- Your iPhone connected via USB cable

### Steps

1. Open `Breathing478.xcodeproj` in Xcode
2. In the project navigator, select the **Breathing478** target
3. Go to **Signing & Capabilities** tab
4. Check **Automatically manage signing**
5. Select your **Team** (your Apple ID — add one via Xcode > Settings > Accounts if needed)
6. Change the **Bundle Identifier** to something unique, e.g. `com.yourname.breathing478`
7. Connect your iPhone via USB and unlock it
8. Select your iPhone from the device dropdown in the Xcode toolbar (top left)
9. Press **Cmd + R** to build and run

### First time setup on iPhone

The first time you install from Xcode with a free Apple ID, you need to trust the developer profile on your device:

1. On your iPhone, go to **Settings > General > VPN & Device Management**
2. Tap your Apple ID under "Developer App"
3. Tap **Trust** and confirm

The app will then launch normally. You only need to do this once.

> **Note:** Apps installed with a free Apple ID expire after 7 days. Just re-run from Xcode to reinstall.

## Project Structure

```
Breathing478.xcodeproj
Breathing478/
├── Breathing478App.swift       # App entry point
├── ContentView.swift           # Tab bar (Breathe / History)
├── Models/
│   ├── BreathingPhase.swift    # Inhale/Hold/Exhale phases
│   └── BreathingSession.swift  # Session data model
├── ViewModels/
│   └── BreathingViewModel.swift # Timer and phase logic
├── Views/
│   ├── BreathingView.swift     # Main breathing UI with animation
│   ├── HistoryView.swift       # Past sessions list
│   └── SettingsView.swift      # Configure number of sets
├── Services/
│   ├── AudioService.swift      # Voice guidance (AVSpeechSynthesizer)
│   └── SessionStore.swift      # Persistence (UserDefaults/JSON)
└── Assets.xcassets/
```

## Requirements

- iOS 17.0+
- Xcode 15.0+
