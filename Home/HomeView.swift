import SwiftUI

struct HomeView: View {
    @EnvironmentObject private var appState: AppState
    @State private var appeared = false

    var body: some View {
        ZStack {
            Color(uiColor: .systemBackground).ignoresSafeArea()

            VStack(spacing: 0) {
                Spacer()

                Text("Swift Student Challenge")
                    .font(.appLabel)
                    .foregroundStyle(.secondary)
                    .kerning(1.5)
                    .textCase(.uppercase)
                    .opacity(appeared ? 1 : 0)
                    .offset(y: appeared ? 0 : 10)
                    .animation(.easeOut(duration: 0.5).delay(0.1), value: appeared)

                Spacer().frame(height: 16)

                Text("OOP Quest.")
                    .font(.appDisplay)
                    .foregroundStyle(.primary)
                    .tracking(-1.5)
                    .opacity(appeared ? 1 : 0)
                    .offset(y: appeared ? 0 : 16)
                    .animation(.easeOut(duration: 0.5).delay(0.2), value: appeared)

                Spacer().frame(height: 10)

                Text("Learn object-oriented programming in minutes.")
                    .font(.appSubheadline)
                    .foregroundStyle(.secondary)
                    .opacity(appeared ? 1 : 0)
                    .offset(y: appeared ? 0 : 10)
                    .animation(.easeOut(duration: 0.5).delay(0.3), value: appeared)

                Spacer().frame(height: 48)

                Button {
                    appState.navigate(to: .phase(1))
                } label: {
                    Text("Get Started")
                        .font(.appBodyMd)
                        .foregroundStyle(.white)
                        .frame(width: 200, height: 50)
                        .background(Color.accentColor, in: RoundedRectangle(cornerRadius: 14, style: .continuous))
                }
                .buttonStyle(.plain)
                .opacity(appeared ? 1 : 0)
                .scaleEffect(appeared ? 1 : 0.9)
                .animation(.spring(response: 0.5, dampingFraction: 0.7).delay(0.4), value: appeared)

                Spacer().frame(height: 16)

                Button {
                    appState.navigate(to: .about)
                } label: {
                    Text("About")
                        .font(.appBody)
                        .foregroundStyle(.blue)
                }
                .buttonStyle(.plain)
                .opacity(appeared ? 1 : 0)
                .animation(.easeOut(duration: 0.4).delay(0.5), value: appeared)

                Spacer()
            }
        }
        .onAppear { appeared = true }
        .onDisappear { appeared = false }
    }
}
