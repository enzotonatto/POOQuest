import SwiftUI

@main
struct POOQuestApp: App {
    var body: some Scene {
        WindowGroup {
            SplashView()
                .preferredColorScheme(.light)
                .onAppear {
                        AudioManager.shared.playMusic()
                    }
        }
    }
}
