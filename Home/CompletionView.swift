import SwiftUI

struct CompletionView: View {
    @EnvironmentObject private var appState: AppState
    @State private var appeared = false
    @State private var ringProgress: CGFloat = 0

    private let concepts = [
        "Classes & Objetos",
        "Atributos & Métodos",
        "Encapsulamento",
        "Herança",
        "Polimorfismo"
    ]

    var body: some View {
        ZStack {
            Color(uiColor: .systemBackground).ignoresSafeArea()

            VStack(spacing: 0) {
                Spacer()

                // Ring
                ZStack {
                    Circle()
                        .stroke(Color(uiColor: .systemFill), lineWidth: 6)
                        .frame(width: 88, height: 88)

                    Circle()
                        .trim(from: 0, to: ringProgress)
                        .stroke(Color.accentColor, style: StrokeStyle(lineWidth: 6, lineCap: .round))
                        .frame(width: 88, height: 88)
                        .rotationEffect(.degrees(-90))
                        .animation(.easeOut(duration: 1.0).delay(0.3), value: ringProgress)

                    Text("🎉")
                        .font(.system(size: 34))
                        .scaleEffect(appeared ? 1 : 0.3)
                        .animation(.spring(response: 0.5, dampingFraction: 0.55).delay(0.2), value: appeared)
                }
                .opacity(appeared ? 1 : 0)
                .animation(.easeOut(duration: 0.4), value: appeared)

                Spacer().frame(height: 24)

                Text("Você completou!")
                    .font(.system(size: 36, weight: .bold))
                    .foregroundStyle(.primary)
                    .tracking(-0.5)
                    .opacity(appeared ? 1 : 0)
                    .offset(y: appeared ? 0 : 12)
                    .animation(.easeOut(duration: 0.4).delay(0.15), value: appeared)

                Spacer().frame(height: 8)

                Text("Você aprendeu os pilares da POO em menos de 3 minutos.")
                    .font(.system(size: 16, weight: .regular))
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(.center)
                    .opacity(appeared ? 1 : 0)
                    .animation(.easeOut(duration: 0.4).delay(0.2), value: appeared)

                Spacer().frame(height: 28)

                // Concept pills
                HStack(spacing: 8) {
                    ForEach(Array(concepts.enumerated()), id: \.offset) { index, concept in
                        Text(concept)
                            .font(.system(size: 13, weight: .semibold))
                            .foregroundStyle(.primary)
                            .padding(.horizontal, 14)
                            .padding(.vertical, 6)
                            .background(Color(uiColor: .secondarySystemFill), in: Capsule())
                            .opacity(appeared ? 1 : 0)
                            .offset(y: appeared ? 0 : 10)
                            .animation(.easeOut(duration: 0.4).delay(0.25 + Double(index) * 0.06), value: appeared)
                    }
                }

                Spacer().frame(height: 36)

                Button {
                    appState.restart()
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
                .animation(.spring(response: 0.5, dampingFraction: 0.7).delay(0.55), value: appeared)

                Spacer()
            }
            .padding(.horizontal, 40)
        }
        .onAppear {
            appeared = true
            ringProgress = 1.0
        }
        .onDisappear {
            appeared = false
            ringProgress = 0
        }
    }
}

#Preview {
    CompletionView()
        .environmentObject(AppState())
        .frame(width: 1024, height: 768)
}
