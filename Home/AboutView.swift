import SwiftUI

struct AboutView: View {
    @EnvironmentObject private var appState: AppState
    @State private var appeared = false

    var body: some View {
        ZStack {
            Color(uiColor: .systemBackground).ignoresSafeArea()

            VStack {
                HStack {
                    Button {
                        appState.navigate(to: .home)
                    } label: {
                        HStack(spacing: 4) {
                            Image(systemName: "chevron.left")
                                .font(.appLabel)
                            Text("Back")
                                .font(.appBody)
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

            VStack(spacing: 0) {
                Spacer()

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

                Text("Enzo Augusto Tonatto")
                    .font(.appTitle)
                    .foregroundStyle(.primary)
                    .opacity(appeared ? 1 : 0)
                    .offset(y: appeared ? 0 : 8)
                    .animation(.easeOut(duration: 0.4).delay(0.2), value: appeared)

                Spacer().frame(height: 4)

                Text("iOS Developer at Apple Developer Academy · Brazil")
                    .font(.appBodyMd)
                    .foregroundStyle(.secondary)
                    .opacity(appeared ? 1 : 0)
                    .animation(.easeOut(duration: 0.4).delay(0.25), value: appeared)

                Spacer().frame(height: 24)

                Text("I created OOP Quest for the Swift Student Challenge inspired by my own college experience. During my Object-Oriented Programming course, I noticed how tricky it can be for beginners to wrap their heads around abstract concepts. I wanted to build the tool I wish I had back then! This app takes the complex, foundational pillars of OOP and turns them into an engaging, visual, and interactive journey for everyone.")
                    .font(.appSubheadline)
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(.center)
                    .frame(maxWidth: 700)
                    .opacity(appeared ? 1 : 0)
                    .animation(.easeOut(duration: 0.4).delay(0.3), value: appeared)

                Spacer().frame(height: 36)

                Button {
                    appState.navigate(to: .home)
                } label: {
                    Text("Back to Home")
                        .font(.appBodyMd)
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
