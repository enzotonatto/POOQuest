import SwiftUI

// MARK: - Navigation destination
enum AppScreen {
    case home
    case about
    case phase(Int)
    case completion
}

// MARK: - App-wide state
@MainActor
class AppState: ObservableObject {
    @Published var screen: AppScreen = .home
    @Published var isTransitioning = false

    func navigate(to destination: AppScreen) {
        guard !isTransitioning else { return }
        isTransitioning = true
        withAnimation(.easeInOut(duration: 0.4)) {
            screen = destination
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
            self.isTransitioning = false
        }
    }

    func advance(from phase: Int) {
        let next = phase + 1
        if next <= 5 {
            navigate(to: .phase(next))
        } else {
            navigate(to: .completion)
        }
    }

    func restart() {
        navigate(to: .home)
    }
}
