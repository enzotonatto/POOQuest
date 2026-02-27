import AVFoundation

@MainActor
class AudioManager: ObservableObject {
    static let shared = AudioManager()

    private var effectPlayer: AVAudioPlayer?
    private var musicPlayer: AVAudioPlayer?

    private init() {
        try? AVAudioSession.sharedInstance().setCategory(.ambient, mode: .default)
        try? AVAudioSession.sharedInstance().setActive(true)
    }

    // MARK: - Background music
    func playMusic() {
        guard let url = Bundle.main.url(forResource: "background", withExtension: "mp3") else {
            print("❌ background.mp3 not found")
            return
        }
        musicPlayer = try? AVAudioPlayer(contentsOf: url)
        musicPlayer?.numberOfLoops = -1
        musicPlayer?.volume = 0.3
        musicPlayer?.play()
    }

    func stopMusic() { musicPlayer?.stop() }

    func setMusicVolume(_ volume: Float) { musicPlayer?.volume = volume }

    // MARK: - Animal sounds (all mp3)
    func playAnimal(_ name: String) {
        guard let url = Bundle.main.url(forResource: name, withExtension: "mp3") else {
            print("❌ \(name).mp3 not found")
            return
        }
        effectPlayer = try? AVAudioPlayer(contentsOf: url)
        effectPlayer?.volume = 1.0
        effectPlayer?.play()
    }
}
