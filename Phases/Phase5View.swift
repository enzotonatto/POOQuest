import SwiftUI

// Phase 5: Block 1 — build the [Animal] array by adding animals
//          Block 2 — run the forEach and watch each animal respond differently

fileprivate struct AnimalEntry: Identifiable {
    let id = UUID()
    let emoji: String
    let type: String
    let sound: String      // display text
    let soundFile: String  // audio file name
}

struct Phase5View: View {
    @Binding var isComplete: Bool

    private let available: [AnimalEntry] = [
        AnimalEntry(emoji: "🐶", type: "Dog",  sound: "Woof!",  soundFile: "woof"),
        AnimalEntry(emoji: "🐱", type: "Cat",  sound: "Meow!",  soundFile: "meow"),
        AnimalEntry(emoji: "🐦", type: "Bird", sound: "Tweet!", soundFile: "tweet"),
        AnimalEntry(emoji: "🐄", type: "Cow",  sound: "Moo!",   soundFile: "moo"),
    ]

    @State private var arrayItems: [AnimalEntry] = []
    @State private var speakingId: UUID? = nil
    @State private var doneIds: Set<UUID> = []
    @State private var loopTriggered = false

    private var canRunLoop: Bool { arrayItems.count >= 3 }

    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                sectionLabel("BLOCK 1 — BUILD THE [Animal] ARRAY")
                block1Card

                sectionLabel("BLOCK 2 — RUN THE LOOP")
                    .opacity(canRunLoop ? 1 : 0.4)

                block2Card
                    .opacity(canRunLoop ? 1 : 0.4)
                    .disabled(!canRunLoop)
            }
            .padding(32)
        }
    }

    private var block1Card: some View {
        VStack(spacing: 16) {
            HStack(spacing: 10) {
                ForEach(available) { animal in
                    let added = arrayItems.contains(where: { $0.type == animal.type })
                    Button {
                        guard !added else { return }
                        withAnimation(.spring(response: 0.35, dampingFraction: 0.65)) {
                            arrayItems.append(animal)
                        }
                        // Play sound preview when adding to array
                        AudioManager.shared.playAnimal(animal.soundFile)
                    } label: {
                        VStack(spacing: 4) {
                            Text(animal.emoji).font(.system(size: 28))
                            Text(animal.type)
                                .font(.appLabel)
                                .foregroundStyle(added ? Color(uiColor: .placeholderText) : .primary)
                        }
                        .frame(maxWidth: .infinity, minHeight: 70)
                        .background(added ? Color.appFill : Color.appPrimary.opacity(0.08),
                                    in: RoundedRectangle(cornerRadius: 14, style: .continuous))
                        .overlay(RoundedRectangle(cornerRadius: 14, style: .continuous)
                            .stroke(added ? Color.clear : Color.appPrimary.opacity(0.25), lineWidth: 1.5))
                        .overlay(alignment: .topTrailing) {
                            if added {
                                Image(systemName: "checkmark.circle.fill")
                                    .foregroundStyle(.appPrimary).font(.system(size: 16)).padding(6)
                            }
                        }
                    }
                    .buttonStyle(.plain).disabled(added)
                }
            }

            VStack(alignment: .leading, spacing: 8) {
                Text("var animals: [Animal] = [")
                    .font(.appCode).foregroundStyle(.secondary)
                if arrayItems.isEmpty {
                    Text("   // empty").font(.appCode)
                        .foregroundStyle(Color(uiColor: .placeholderText)).padding(.leading, 16)
                } else {
                    ForEach(Array(arrayItems.enumerated()), id: \.element.id) { idx, item in
                        HStack(spacing: 6) {
                            Text("   \(item.emoji)")
                            Text("\(item.type)()")
                                .font(.appCodeMd).foregroundStyle(.appPrimary)
                            if idx < arrayItems.count - 1 {
                                Text(",").font(.appCode).foregroundStyle(.secondary)
                            }
                        }
                        .transition(.move(edge: .leading).combined(with: .opacity))
                    }
                }
                Text("]").font(.appCode).foregroundStyle(.secondary)
            }
            .padding(14).frame(maxWidth: .infinity, alignment: .leading)
            .background(Color.appFill, in: RoundedRectangle(cornerRadius: 12, style: .continuous))

            if !canRunLoop {
                FeedbackBanner(kind: .neutral, message: "Add at least 3 animals to the array.")
            } else {
                FeedbackBanner(kind: .success, message: "\(arrayItems.count) animals. Ready for the loop!")
            }
        }
        .padding(20)
        .background(Color.appSurface, in: RoundedRectangle(cornerRadius: 18, style: .continuous))
        .shadow(color: .black.opacity(0.06), radius: 12, x: 0, y: 3)
    }

    private var block2Card: some View {
        VStack(spacing: 16) {
            VStack(alignment: .leading, spacing: 4) {
                Text("animals.forEach { animal in")
                    .font(.appCode).foregroundStyle(.secondary)
                Text("   animal.makeSound()")
                    .font(.appCodeMd).foregroundStyle(.appPrimary)
                Text("}").font(.appCode).foregroundStyle(.secondary)
            }
            .padding(14).frame(maxWidth: .infinity, alignment: .leading)
            .background(Color.appFill, in: RoundedRectangle(cornerRadius: 12, style: .continuous))

            VStack(spacing: 8) {
                ForEach(arrayItems) { animal in
                    AnimalSoundRow(animal: animal,
                                  isSpeaking: speakingId == animal.id,
                                  isDone: doneIds.contains(animal.id))
                }
            }

            Button {
                guard !loopTriggered else { return }
                loopTriggered = true
                runLoop()
            } label: {
                HStack(spacing: 8) {
                    Image(systemName: loopTriggered ? "checkmark" : "play.fill").font(.appLabel)
                    Text(loopTriggered ? "Executed!" : "Run loop")
                        .font(.appBodyMd)
                }
                .foregroundStyle(loopTriggered ? Color(uiColor: .placeholderText) : .white)
                .frame(maxWidth: .infinity, minHeight: 52)
                .background(loopTriggered ? Color.appFill : Color.appPrimary,
                            in: RoundedRectangle(cornerRadius: 14, style: .continuous))
            }
            .buttonStyle(.plain).disabled(loopTriggered)
            .animation(.easeOut(duration: 0.3), value: loopTriggered)

            if isComplete {
                FeedbackBanner(kind: .success,
                               message: "Each animal responded differently to the same call. That's polymorphism!")
                    .transition(.move(edge: .top).combined(with: .opacity))
            }
        }
        .padding(20)
        .background(Color.appSurface, in: RoundedRectangle(cornerRadius: 18, style: .continuous))
        .shadow(color: .black.opacity(0.06), radius: 12, x: 0, y: 3)
        .animation(.easeOut(duration: 0.25), value: isComplete)
    }

    private func runLoop() {
        for (i, animal) in arrayItems.enumerated() {
            let delay = Double(i) * 0.7  // slightly longer gap so sounds don't overlap
            DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
                withAnimation { speakingId = animal.id }
                // Play the actual animal sound
                AudioManager.shared.playAnimal(animal.soundFile)
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + delay + 0.55) {
                withAnimation { doneIds.insert(animal.id); speakingId = nil }
            }
        }
        let finish = Double(arrayItems.count) * 0.7 + 0.5
        DispatchQueue.main.asyncAfter(deadline: .now() + finish) {
            withAnimation { isComplete = true }
        }
    }

    private func sectionLabel(_ text: String) -> some View {
        Text(text).font(.appLabel).foregroundStyle(.secondary).kerning(1.2)
            .frame(maxWidth: .infinity, alignment: .leading)
    }
}

private struct AnimalSoundRow: View {
    let animal: AnimalEntry
    let isSpeaking: Bool
    let isDone: Bool

    var body: some View {
        HStack(spacing: 14) {
            Text(animal.emoji).font(.system(size: 28))
                .scaleEffect(isSpeaking ? 1.25 : 1)
                .animation(.spring(response: 0.3, dampingFraction: 0.45), value: isSpeaking)
            Text("\(animal.type) : Animal").font(.appCodeMd).foregroundStyle(.primary)
            Spacer()
            if isDone || isSpeaking {
                Text(animal.sound).font(.appCodeMd)
                    .foregroundStyle(isSpeaking ? .appPrimary : .secondary)
                    .transition(.scale(scale: 0.6).combined(with: .opacity))
            } else {
                Text("--").font(.appCode).foregroundStyle(Color(uiColor: .placeholderText))
            }
        }
        .padding(.horizontal, 16).padding(.vertical, 12)
        .background(isSpeaking ? Color.appPrimary.opacity(0.08) : Color.appFill,
                    in: RoundedRectangle(cornerRadius: 12, style: .continuous))
        .overlay(RoundedRectangle(cornerRadius: 12, style: .continuous)
            .stroke(isSpeaking ? Color.appPrimary.opacity(0.3) : Color.clear, lineWidth: 1.5))
        .animation(.easeOut(duration: 0.2), value: isSpeaking)
        .animation(.easeOut(duration: 0.2), value: isDone)
    }
}

#Preview {
    Phase5View(isComplete: .constant(false))
        .frame(width: 664, height: 768)
        .background(Color(uiColor: .secondarySystemBackground))
}
