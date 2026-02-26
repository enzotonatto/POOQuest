import SwiftUI

struct HomeView: View {
    @EnvironmentObject private var appState: AppState
    @State private var appeared = false

    var body: some View {
        ZStack {
            Color(uiColor: .systemBackground).ignoresSafeArea()

            VStack(spacing: 0) {
                Spacer()

                // Eyebrow
                Text("Swift Student Challenge")
                    .font(.system(size: 13, weight: .semibold))
                    .foregroundStyle(.secondary)
                    .kerning(1.5)
                    .textCase(.uppercase)
                    .opacity(appeared ? 1 : 0)
                    .offset(y: appeared ? 0 : 10)
                    .animation(.easeOut(duration: 0.5).delay(0.1), value: appeared)

                Spacer().frame(height: 16)

                // Title
                Text("POO Quest.")
                    .font(.system(size: 64, weight: .bold, design: .default))
                    .foregroundStyle(.primary)
                    .tracking(-1.5)
                    .opacity(appeared ? 1 : 0)
                    .offset(y: appeared ? 0 : 16)
                    .animation(.easeOut(duration: 0.5).delay(0.2), value: appeared)

                Spacer().frame(height: 10)

                // Subtitle
                Text("Aprenda orientação a objetos em minutos.")
                    .font(.system(size: 18, weight: .regular))
                    .foregroundStyle(.secondary)
                    .opacity(appeared ? 1 : 0)
                    .offset(y: appeared ? 0 : 10)
                    .animation(.easeOut(duration: 0.5).delay(0.3), value: appeared)

                Spacer().frame(height: 48)

                // Primary CTA
                Button {
                    appState.navigate(to: .phase(1))
                } label: {
                    Text("Iniciar")
                        .font(.system(size: 17, weight: .semibold))
                        .foregroundStyle(.white)
                        .frame(width: 200, height: 50)
                        .background(Color.accentColor, in: RoundedRectangle(cornerRadius: 14, style: .continuous))
                }
                .buttonStyle(.plain)
                .opacity(appeared ? 1 : 0)
                .scaleEffect(appeared ? 1 : 0.9)
                .animation(.spring(response: 0.5, dampingFraction: 0.7).delay(0.4), value: appeared)

                Spacer().frame(height: 16)

                // Secondary CTA
                Button {
                    appState.navigate(to: .about)
                } label: {
                    Text("Sobre mim")
                        .font(.system(size: 15, weight: .medium))
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

#Preview {
    HomeView()
        .environmentObject(AppState())
        .frame(width: 1024, height: 768)
}
