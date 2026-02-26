import SwiftUI

struct ContentView: View {
    @StateObject private var appState = AppState()

    var body: some View {
        ZStack {
            switch appState.screen {
            case .home:
                HomeView()
                    .transition(.asymmetric(
                        insertion: .move(edge: .leading),
                        removal: .move(edge: .leading).combined(with: .opacity)
                    ))

            case .about:
                AboutView()
                    .transition(.move(edge: .bottom).combined(with: .opacity))

            case .phase(let number):
                PhaseContainerView(phaseNumber: number)
                    .id(number) // forces rebuild on phase change
                    .transition(.asymmetric(
                        insertion: .move(edge: .trailing).combined(with: .opacity),
                        removal: .move(edge: .leading).combined(with: .opacity)
                    ))

            case .completion:
                CompletionView()
                    .transition(.asymmetric(
                        insertion: .scale(scale: 0.95).combined(with: .opacity),
                        removal: .opacity
                    ))
            }
        }
        .environmentObject(appState)
        .animation(.easeInOut(duration: 0.4), value: appState.screen.id)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color(uiColor: .systemBackground))
        // Lock to landscape on iPad
        .onAppear {
            AppDelegate.lockLandscape()
        }
    }
}

// MARK: - Screen equatable ID for animation
extension AppScreen {
    var id: String {
        switch self {
        case .home:       return "home"
        case .about:      return "about"
        case .phase(let n): return "phase\(n)"
        case .completion: return "completion"
        }
    }
}
