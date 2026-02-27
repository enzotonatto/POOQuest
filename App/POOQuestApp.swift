import SwiftUI

@main
struct POOQuestApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
                .preferredColorScheme(.light)
                .onAppear {
                        AudioManager.shared.playMusic()
                    }
        }
    }
}
