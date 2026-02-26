import SwiftUI

struct AboutView: View {
    @EnvironmentObject private var appState: AppState
    @State private var appeared = false

    var body: some View {
        ZStack {
            Color(uiColor: .systemBackground).ignoresSafeArea()

            // Back button
            VStack {
                HStack {
                    Button {
                        appState.navigate(to: .home)
                    } label: {
                        HStack(spacing: 4) {
                            Image(systemName: "chevron.left")
                                .font(.system(size: 14, weight: .semibold))
                            Text("Voltar")
                                .font(.system(size: 15, weight: .medium))
                        }
                        .foregroundStyle(.blue)
                        .padding(.horizontal, 14)
                        .padding(.vertical, 8)
                        .background(Color(uiColor: .secondarySystemFill), in: RoundedRectangle(cornerRadius: 10, style: .continuous))
                    }
                    .buttonStyle(.plain)
                    Spacer()
                }
                .padding(24)
                Spacer()
            }

            // Content
            VStack(spacing: 0) {
                Spacer()

                // Avatar
                Circle()
                    .fill(
                        LinearGradient(
                            colors: [.blue, Color(uiColor: .systemTeal)],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .frame(width: 80, height: 80)
                    .overlay {
                        Text("👨‍💻")
                            .font(.system(size: 36))
                    }
                    .scaleEffect(appeared ? 1 : 0.5)
                    .opacity(appeared ? 1 : 0)
                    .animation(.spring(response: 0.5, dampingFraction: 0.65).delay(0.1), value: appeared)

                Spacer().frame(height: 20)

                // Name — substitua pelo seu nome
                Text("Seu Nome")
                    .font(.system(size: 22, weight: .bold))
                    .foregroundStyle(.primary)
                    .opacity(appeared ? 1 : 0)
                    .offset(y: appeared ? 0 : 8)
                    .animation(.easeOut(duration: 0.4).delay(0.2), value: appeared)

                Spacer().frame(height: 4)

                Text("Estudante de Desenvolvimento · Brasil")
                    .font(.system(size: 14, weight: .regular))
                    .foregroundStyle(.secondary)
                    .opacity(appeared ? 1 : 0)
                    .animation(.easeOut(duration: 0.4).delay(0.25), value: appeared)

                Spacer().frame(height: 24)

                // Bio — substitua pelo seu texto
                Text("Criei o POO Quest para o Swift Student Challenge para transformar conceitos abstratos de Programação Orientada a Objetos em algo visual, interativo e acessível para qualquer um.")
                    .font(.system(size: 15, weight: .regular))
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(.center)
                    .frame(maxWidth: 500)
                    .opacity(appeared ? 1 : 0)
                    .animation(.easeOut(duration: 0.4).delay(0.3), value: appeared)

                Spacer().frame(height: 36)

                Button {
                    appState.navigate(to: .home)
                } label: {
                    Text("Voltar ao início")
                        .font(.system(size: 17, weight: .semibold))
                        .foregroundStyle(.white)
                        .frame(width: 200, height: 50)
                        .background(Color.accentColor, in: RoundedRectangle(cornerRadius: 14, style: .continuous))
                }
                .buttonStyle(.plain)
                .opacity(appeared ? 1 : 0)
                .scaleEffect(appeared ? 1 : 0.9)
                .animation(.spring(response: 0.5, dampingFraction: 0.7).delay(0.4), value: appeared)

                Spacer()
            }
            .padding(.horizontal, 40)
        }
        .onAppear { appeared = true }
        .onDisappear { appeared = false }
    }
}

#Preview {
    AboutView()
        .environmentObject(AppState())
        .frame(width: 1024, height: 768)
}
