import SwiftUI

struct BreathingView: View {
    @StateObject private var viewModel = BreathingViewModel()
    @EnvironmentObject private var store: SessionStore
    @State private var showSettings = false

    var body: some View {
        NavigationStack {
            ZStack {
                // Background gradient
                LinearGradient(
                    colors: [
                        Color(red: 0.05, green: 0.05, blue: 0.15),
                        Color(red: 0.1, green: 0.05, blue: 0.2)
                    ],
                    startPoint: .top,
                    endPoint: .bottom
                )
                .ignoresSafeArea()

                VStack(spacing: 30) {
                    if viewModel.isActive || viewModel.phase == .finished {
                        activeSessionView
                    } else {
                        startView
                    }
                }
                .padding()
            }
            .navigationTitle("")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        showSettings = true
                    } label: {
                        Image(systemName: "gear")
                            .foregroundStyle(.white.opacity(0.7))
                    }
                }
            }
            .sheet(isPresented: $showSettings) {
                SettingsView(store: store)
            }
        }
    }

    // MARK: - Start View

    private var startView: some View {
        VStack(spacing: 40) {
            Spacer()

            VStack(spacing: 12) {
                Text("4-7-8")
                    .font(.system(size: 56, weight: .ultraLight, design: .rounded))
                    .foregroundStyle(.white)

                Text("Breathing")
                    .font(.system(size: 28, weight: .light, design: .rounded))
                    .foregroundStyle(.white.opacity(0.7))
            }

            // Decorative circle
            ZStack {
                Circle()
                    .fill(
                        RadialGradient(
                            colors: [.cyan.opacity(0.3), .purple.opacity(0.1), .clear],
                            center: .center,
                            startRadius: 20,
                            endRadius: 120
                        )
                    )
                    .frame(width: 240, height: 240)

                Circle()
                    .stroke(.cyan.opacity(0.3), lineWidth: 2)
                    .frame(width: 180, height: 180)

                VStack(spacing: 4) {
                    Text("\(store.numberOfSets)")
                        .font(.system(size: 48, weight: .light, design: .rounded))
                        .foregroundStyle(.white)
                    Text("sets")
                        .font(.system(size: 16, weight: .light))
                        .foregroundStyle(.white.opacity(0.5))
                }
            }

            Spacer()

            Button {
                viewModel.start(sets: store.numberOfSets)
            } label: {
                Text("Begin")
                    .font(.system(size: 22, weight: .medium, design: .rounded))
                    .foregroundStyle(.white)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 18)
                    .background(
                        Capsule()
                            .fill(.cyan.opacity(0.3))
                            .overlay(
                                Capsule()
                                    .stroke(.cyan.opacity(0.5), lineWidth: 1)
                            )
                    )
            }
            .padding(.horizontal, 40)
            .padding(.bottom, 40)
        }
    }

    // MARK: - Active Session View

    private var activeSessionView: some View {
        VStack(spacing: 24) {
            Spacer()

            // Phase label
            Text(viewModel.phase.rawValue)
                .font(.system(size: 28, weight: .light, design: .rounded))
                .foregroundStyle(viewModel.phase.color)
                .animation(.easeInOut, value: viewModel.phase)

            // Animated breathing circle
            ZStack {
                // Outer glow
                Circle()
                    .fill(
                        RadialGradient(
                            colors: [
                                viewModel.phase.color.opacity(0.2),
                                viewModel.phase.color.opacity(0.05),
                                .clear
                            ],
                            center: .center,
                            startRadius: 40,
                            endRadius: 160
                        )
                    )
                    .frame(width: 320, height: 320)
                    .scaleEffect(viewModel.circleScale)

                // Main circle
                Circle()
                    .fill(
                        RadialGradient(
                            colors: [
                                viewModel.phase.color.opacity(0.4),
                                viewModel.phase.color.opacity(0.15)
                            ],
                            center: .center,
                            startRadius: 20,
                            endRadius: 100
                        )
                    )
                    .frame(width: 200, height: 200)
                    .scaleEffect(viewModel.circleScale)

                // Inner ring
                Circle()
                    .stroke(viewModel.phase.color.opacity(0.5), lineWidth: 2)
                    .frame(width: 200, height: 200)
                    .scaleEffect(viewModel.circleScale)

                // Countdown
                if viewModel.phase != .finished {
                    Text("\(viewModel.countdown)")
                        .font(.system(size: 64, weight: .ultraLight, design: .rounded))
                        .foregroundStyle(.white)
                        .contentTransition(.numericText())
                        .animation(.easeInOut(duration: 0.3), value: viewModel.countdown)
                } else {
                    Image(systemName: "checkmark")
                        .font(.system(size: 48, weight: .light))
                        .foregroundStyle(.green)
                }
            }

            // Set progress
            VStack(spacing: 8) {
                Text(viewModel.setLabel)
                    .font(.system(size: 16, weight: .light, design: .rounded))
                    .foregroundStyle(.white.opacity(0.6))

                // Progress dots
                HStack(spacing: 8) {
                    ForEach(0..<store.numberOfSets, id: \.self) { index in
                        Circle()
                            .fill(index < viewModel.currentSet || viewModel.phase == .finished
                                  ? viewModel.phase.color
                                  : .white.opacity(0.2))
                            .frame(width: 8, height: 8)
                            .animation(.easeInOut(duration: 0.3), value: viewModel.currentSet)
                    }
                }
            }

            Spacer()

            // Stop / Done button
            if viewModel.phase == .finished {
                Button {
                    _ = viewModel.stop()
                } label: {
                    Text("Done")
                        .font(.system(size: 22, weight: .medium, design: .rounded))
                        .foregroundStyle(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 18)
                        .background(
                            Capsule()
                                .fill(.green.opacity(0.3))
                                .overlay(
                                    Capsule()
                                        .stroke(.green.opacity(0.5), lineWidth: 1)
                                )
                        )
                }
                .padding(.horizontal, 40)
                .padding(.bottom, 40)
                .onAppear {
                    let session = viewModel.createCompletedSession()
                    store.save(session: session)
                }
            } else {
                Button {
                    if let session = viewModel.stop() {
                        store.save(session: session)
                    }
                } label: {
                    Text("Stop")
                        .font(.system(size: 22, weight: .medium, design: .rounded))
                        .foregroundStyle(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 18)
                        .background(
                            Capsule()
                                .fill(.red.opacity(0.2))
                                .overlay(
                                    Capsule()
                                        .stroke(.red.opacity(0.4), lineWidth: 1)
                                )
                        )
                }
                .padding(.horizontal, 40)
                .padding(.bottom, 40)
            }
        }
    }
}

#Preview {
    BreathingView()
}
