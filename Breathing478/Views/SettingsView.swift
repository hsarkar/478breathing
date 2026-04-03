import SwiftUI

struct SettingsView: View {
    @ObservedObject var store: SessionStore
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        NavigationStack {
            ZStack {
                Color(red: 0.05, green: 0.05, blue: 0.15)
                    .ignoresSafeArea()

                VStack(spacing: 32) {
                    // Sets configuration
                    VStack(spacing: 20) {
                        Text("Number of Sets")
                            .font(.system(size: 18, weight: .light, design: .rounded))
                            .foregroundStyle(.white.opacity(0.7))

                        HStack(spacing: 24) {
                            Button {
                                if store.numberOfSets > 1 {
                                    store.numberOfSets -= 1
                                }
                            } label: {
                                Image(systemName: "minus.circle.fill")
                                    .font(.system(size: 36))
                                    .foregroundStyle(store.numberOfSets > 1 ? .cyan : .gray.opacity(0.3))
                            }
                            .disabled(store.numberOfSets <= 1)

                            Text("\(store.numberOfSets)")
                                .font(.system(size: 64, weight: .ultraLight, design: .rounded))
                                .foregroundStyle(.white)
                                .frame(width: 80)

                            Button {
                                if store.numberOfSets < 20 {
                                    store.numberOfSets += 1
                                }
                            } label: {
                                Image(systemName: "plus.circle.fill")
                                    .font(.system(size: 36))
                                    .foregroundStyle(store.numberOfSets < 20 ? .cyan : .gray.opacity(0.3))
                            }
                            .disabled(store.numberOfSets >= 20)
                        }

                        // Duration estimate
                        let totalSeconds = store.numberOfSets * 19 // 4+7+8 = 19 per set
                        let minutes = totalSeconds / 60
                        let seconds = totalSeconds % 60
                        Text("≈ \(minutes)m \(seconds)s per session")
                            .font(.system(size: 14, weight: .light))
                            .foregroundStyle(.white.opacity(0.4))
                    }
                    .padding(.top, 40)

                    // Info section
                    VStack(alignment: .leading, spacing: 16) {
                        Text("About 4-7-8 Breathing")
                            .font(.system(size: 16, weight: .medium, design: .rounded))
                            .foregroundStyle(.white.opacity(0.8))

                        VStack(alignment: .leading, spacing: 12) {
                            infoRow(number: "4", text: "Breathe in through your nose", color: .cyan)
                            infoRow(number: "7", text: "Hold your breath", color: .purple)
                            infoRow(number: "8", text: "Exhale slowly through your mouth", color: .indigo)
                        }

                        Text("Developed by Dr. Andrew Weil, this technique helps reduce anxiety, improve sleep, and manage stress.")
                            .font(.system(size: 13, weight: .light))
                            .foregroundStyle(.white.opacity(0.4))
                            .padding(.top, 4)
                    }
                    .padding(20)
                    .background(
                        RoundedRectangle(cornerRadius: 16)
                            .fill(.white.opacity(0.05))
                    )
                    .padding(.horizontal)

                    Spacer()
                }
            }
            .navigationTitle("Settings")
            .navigationBarTitleDisplayMode(.inline)
            .toolbarColorScheme(.dark, for: .navigationBar)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Done") { dismiss() }
                        .foregroundStyle(.cyan)
                }
            }
        }
    }

    private func infoRow(number: String, text: String, color: Color) -> some View {
        HStack(spacing: 12) {
            ZStack {
                Circle()
                    .fill(color.opacity(0.2))
                    .frame(width: 36, height: 36)
                Text(number)
                    .font(.system(size: 16, weight: .medium, design: .rounded))
                    .foregroundStyle(color)
            }
            Text(text)
                .font(.system(size: 15, weight: .light))
                .foregroundStyle(.white.opacity(0.7))
        }
    }
}

#Preview {
    SettingsView(store: SessionStore())
}
