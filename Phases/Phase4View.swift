import SwiftUI

// Phase 4: Block 1 — create subclasses of Animal one by one
//          Block 2 — quiz: what does `override` do?

struct Phase4View: View {
    @Binding var isComplete: Bool

    public struct SubAnimal: Identifiable {
        let id: String
        let emoji: String
        let label: String
        let override: String
        let color: Color
        let sound: String  // sound file name
    }

    private let subAnimals: [SubAnimal] = [
        SubAnimal(id: "dog",  emoji: "🐶", label: "Dog",  override: "makeSound() → \"Woof!\"",  color: Color(uiColor: .systemOrange), sound: "woof"),
        SubAnimal(id: "cat",  emoji: "🐱", label: "Cat",  override: "makeSound() → \"Meow!\"",  color: Color(uiColor: .systemPink),   sound: "meow"),
        SubAnimal(id: "bird", emoji: "🐦", label: "Bird", override: "makeSound() → \"Tweet!\"", color: Color(uiColor: .systemGreen),  sound: "tweet"),
    ]

    @State private var revealed: Set<String> = []
    @State private var quizAnswer: QuizState = .unanswered
    @State private var wrongTaps: Set<Int> = []

    private var allRevealed: Bool { revealed.count == 3 }

    enum QuizState { case unanswered, wrong(Int), correct }

    private let quizOptions: [(String, Bool)] = [
        ("Creates a new class from scratch", false),
        ("Replaces the inherited behavior in the subclass", true),
        ("Removes a method from the superclass", false),
        ("Copies the code from the superclass", false),
    ]

    var body: some View {
        ScrollView {
            VStack(spacing: 20) {

                sectionLabel("BLOCK 1 — BUILD THE INHERITANCE TREE")

                treeCard

                sectionLabel("BLOCK 2 — QUIZ: WHAT DOES `override` DO?")
                    .opacity(allRevealed ? 1 : 0.4)

                quizCard
                    .opacity(allRevealed ? 1 : 0.4)
                    .disabled(!allRevealed)
            }
            .padding(32)
        }
    }

    private var treeCard: some View {
        VStack(spacing: 20) {
            HStack {
                Spacer()
                VStack(spacing: 4) {
                    Text("class Animal")
                        .font(.appCodeMd)
                        .foregroundStyle(.appPrimary)
                        .padding(.horizontal, 20)
                        .padding(.vertical, 10)
                        .background(Color.appPrimary.opacity(0.10), in: RoundedRectangle(cornerRadius: 12, style: .continuous))
                        .overlay(RoundedRectangle(cornerRadius: 12, style: .continuous).stroke(Color.appPrimary.opacity(0.3), lineWidth: 1.5))

                    Text("func makeSound()")
                        .font(.appCode)
                        .foregroundStyle(.secondary)
                }
                Spacer()
            }

            Rectangle().fill(Color.appBorder).frame(width: 1.5, height: 16)

            HStack(alignment: .top, spacing: 14) {
                ForEach(subAnimals) { animal in
                    SubAnimalNode(animal: animal, isRevealed: revealed.contains(animal.id)) {
                        withAnimation(.spring(response: 0.4, dampingFraction: 0.65)) {
                            _ = revealed.insert(animal.id)
                        }
                        // Play the animal's sound when revealed
                        AudioManager.shared.playAnimal(animal.sound)
                    }
                }
            }

            if allRevealed {
                FeedbackBanner(kind: .success, message: "Each subclass inherits Animal and overrides makeSound() with its own sound.")
                    .transition(.move(edge: .top).combined(with: .opacity))
            } else {
                FeedbackBanner(kind: .neutral, message: "Tap each subclass to add it to the tree.")
            }
        }
        .padding(20)
        .background(Color.appSurface, in: RoundedRectangle(cornerRadius: 18, style: .continuous))
        .shadow(color: .black.opacity(0.06), radius: 12, x: 0, y: 3)
        .animation(.easeOut(duration: 0.25), value: allRevealed)
    }

    private var quizCard: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("What does the **override** keyword do in Swift?")
                .font(.appBody)
                .foregroundStyle(.primary)

            VStack(spacing: 10) {
                ForEach(Array(quizOptions.enumerated()), id: \.offset) { idx, option in
                    QuizOption(
                        emoji: optionEmoji(idx),
                        label: option.0,
                        state: optionState(idx: idx, isCorrect: option.1)
                    ) {
                        tapQuiz(idx: idx, isCorrect: option.1)
                    }
                }
            }

            if case .correct = quizAnswer {
                FeedbackBanner(kind: .success, message: "Exactly! override signals that the subclass method replaces the superclass one.")
                    .transition(.move(edge: .top).combined(with: .opacity))
            }
        }
        .padding(20)
        .background(Color.appSurface, in: RoundedRectangle(cornerRadius: 18, style: .continuous))
        .shadow(color: .black.opacity(0.06), radius: 12, x: 0, y: 3)
        .animation(.easeOut(duration: 0.25), value: quizAnswer == .unanswered ? 0 : 1)
    }

    private func tapQuiz(idx: Int, isCorrect: Bool) {
        if isCorrect {
            quizAnswer = .correct
            isComplete = true
        } else {
            quizAnswer = .wrong(idx)
            wrongTaps.insert(idx)
        }
    }

    private func optionState(idx: Int, isCorrect: Bool) -> QuizOptionState {
        if case .correct = quizAnswer { return isCorrect ? .correct : .idle }
        if wrongTaps.contains(idx) { return .wrong }
        return .idle
    }

    private func optionEmoji(_ idx: Int) -> String {
        ["🔄", "✏️", "🗑️", "📋"][idx]
    }

    private func sectionLabel(_ text: String) -> some View {
        Text(text).font(.appLabel).foregroundStyle(.secondary).kerning(1.2)
            .frame(maxWidth: .infinity, alignment: .leading)
    }
}

struct SubAnimalNode: View {
    let animal: Phase4View.SubAnimal
    let isRevealed: Bool
    let onTap: () -> Void

    var body: some View {
        VStack(spacing: 0) {
            Rectangle().fill(Color.appBorder).frame(width: 1.5, height: 16)

            Button(action: isRevealed ? {} : onTap) {
                VStack(spacing: 8) {
                    Text(animal.emoji).font(.system(size: 28))
                    Text("class \(animal.label)")
                        .font(.appCode)
                        .foregroundStyle(isRevealed ? animal.color : Color(uiColor: .placeholderText))
                        .multilineTextAlignment(.center)
                    if isRevealed {
                        Text("override \(animal.override)")
                            .font(.appCaption)
                            .foregroundStyle(.secondary)
                            .multilineTextAlignment(.center)
                    } else {
                        Text("Tap to add")
                            .font(.appCaption)
                            .foregroundStyle(Color(uiColor: .placeholderText))
                    }
                }
                .padding(.horizontal, 12)
                .padding(.vertical, 12)
                .frame(maxWidth: .infinity)
                .background(
                    isRevealed ? animal.color.opacity(0.10) : Color.appFill,
                    in: RoundedRectangle(cornerRadius: 14, style: .continuous)
                )
                .overlay(
                    RoundedRectangle(cornerRadius: 14, style: .continuous)
                        .stroke(isRevealed ? animal.color.opacity(0.35) : Color.appBorder, lineWidth: 1.5)
                )
            }
            .buttonStyle(.plain)
            .scaleEffect(isRevealed ? 1 : 0.95)
        }
        .frame(maxWidth: .infinity)
    }
}

private struct QuizOption: View {
    let emoji: String
    let label: String
    let state: QuizOptionState
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack(spacing: 12) {
                Text(emoji).font(.system(size: 20))
                Text(label)
                    .font(.appBody)
                    .foregroundStyle(textColor)
                    .multilineTextAlignment(.leading)
                Spacer()
                if state == .correct {
                    Image(systemName: "checkmark.circle.fill").foregroundStyle(.appSuccess).font(.system(size: 20))
                } else if state == .wrong {
                    Image(systemName: "xmark.circle.fill").foregroundStyle(.appError).font(.system(size: 20))
                }
            }
            .padding(.horizontal, 16).padding(.vertical, 14)
            .background(bgColor, in: RoundedRectangle(cornerRadius: 12, style: .continuous))
            .overlay(RoundedRectangle(cornerRadius: 12, style: .continuous).stroke(borderColor, lineWidth: 1.5))
        }
        .buttonStyle(.plain)
        .disabled(state == .correct || state == .wrong)
    }

    private var bgColor: Color {
        switch state {
        case .idle:    return Color.appFill
        case .correct: return Color.appSuccess.opacity(0.10)
        case .wrong:   return Color.appError.opacity(0.10)
        }
    }
    private var textColor: Color {
        switch state {
        case .idle:    return .primary
        case .correct: return .appSuccess
        case .wrong:   return .appError
        }
    }
    private var borderColor: Color {
        switch state {
        case .idle:    return Color.clear
        case .correct: return Color.appSuccess.opacity(0.3)
        case .wrong:   return Color.appError.opacity(0.3)
        }
    }
}

extension Phase4View.QuizState: Equatable {
    static func == (lhs: Phase4View.QuizState, rhs: Phase4View.QuizState) -> Bool {
        switch (lhs, rhs) {
        case (.unanswered, .unanswered): return true
        case (.correct, .correct):       return true
        case (.wrong(let a), .wrong(let b)): return a == b
        default: return false
        }
    }
}

#Preview {
    Phase4View(isComplete: .constant(false))
        .frame(width: 664, height: 768)
        .background(Color(uiColor: .secondarySystemBackground))
}
