import SwiftUI

// Phase 2: Block 1 — call methods on Animal and watch attributes change.
//          Block 2 — quiz: which method increases energy?

struct Phase2View: View {
    @Binding var isComplete: Bool

    @State private var energy: Int = 60
    @State private var log: [String] = []
    @State private var emojiScale: CGFloat = 1
    @State private var methodsUsed: Set<String> = []

    @State private var quizAnswer: QuizState = .unanswered
    @State private var wrongTaps: Set<String> = []

    private var quizUnlocked: Bool { methodsUsed.count >= 3 }

    enum QuizState { case unanswered, wrong(String), correct }

    private let quizOptions = [
        ("bark()",  false, "🗣️"),
        ("eat()",   true,  "🍖"),
        ("run()",   false, "🏃"),
    ]

    var body: some View {
        ScrollView {
            VStack(spacing: 20) {

                sectionLabel("BLOCK 1 — CALL THE METHODS")

                VStack(spacing: 16) {
                    HStack(spacing: 20) {
                        Text("🐶")
                            .font(.system(size: 56))
                            .scaleEffect(emojiScale)
                            .animation(.spring(response: 0.3, dampingFraction: 0.45), value: emojiScale)

                        VStack(alignment: .leading, spacing: 10) {
                            Text("rex : Animal")
                                .font(.appCodeMd)
                                .foregroundStyle(.primary)

                            VStack(alignment: .leading, spacing: 4) {
                                HStack {
                                    Text("energy:")
                                        .font(.appCode)
                                        .foregroundStyle(.secondary)
                                    Text("\(energy)")
                                        .font(.appCodeMd)
                                        .foregroundStyle(energyColor)
                                        .animation(.easeOut, value: energy)
                                    Spacer()
                                }
                                GeometryReader { geo in
                                    ZStack(alignment: .leading) {
                                        Capsule().fill(Color.appFill).frame(height: 10)
                                        Capsule()
                                            .fill(energyColor)
                                            .frame(width: geo.size.width * CGFloat(energy) / 100, height: 10)
                                            .animation(.spring(response: 0.4, dampingFraction: 0.7), value: energy)
                                    }
                                }
                                .frame(height: 10)
                            }
                        }
                    }

                    HStack(spacing: 10) {
                        ForEach([("bark()", "🗣️", -15), ("eat()", "🍖", +25), ("run()", "🏃", -20)], id: \.0) { name, emoji, delta in
                            MethodBtn(emoji: emoji, label: name, used: methodsUsed.contains(name)) {
                                callMethod(name: name, delta: delta)
                            }
                        }
                    }

                    if !log.isEmpty {
                        VStack(alignment: .leading, spacing: 4) {
                            ForEach(log.suffix(3), id: \.self) { line in
                                Text(line)
                                    .font(.appCode)
                                    .foregroundStyle(.secondary)
                            }
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(12)
                        .background(Color.appFill, in: RoundedRectangle(cornerRadius: 10, style: .continuous))
                    }
                }
                .padding(20)
                .background(Color.appSurface, in: RoundedRectangle(cornerRadius: 18, style: .continuous))
                .shadow(color: .black.opacity(0.06), radius: 12, x: 0, y: 3)

                if !quizUnlocked {
                    FeedbackBanner(kind: .neutral, message: "Use all 3 methods to unlock the quiz.")
                }

                sectionLabel("BLOCK 2 — QUIZ")
                    .opacity(quizUnlocked ? 1 : 0.4)

                VStack(alignment: .leading, spacing: 16) {
                    Text("Which method **increases** the Animal's energy?")
                        .font(.appBody)
                        .foregroundStyle(.primary)

                    VStack(spacing: 10) {
                        ForEach(quizOptions, id: \.0) { name, isCorrect, emoji in
                            QuizOption(
                                emoji: emoji,
                                label: name,
                                state: optionState(name: name, isCorrect: isCorrect)
                            ) {
                                guard quizUnlocked else { return }
                                tapQuiz(name: name, isCorrect: isCorrect)
                            }
                        }
                    }

                    if case .correct = quizAnswer {
                        FeedbackBanner(kind: .success, message: "Correct! eat() adds energy to the Animal.")
                    }
                }
                .padding(20)
                .background(Color.appSurface, in: RoundedRectangle(cornerRadius: 18, style: .continuous))
                .shadow(color: .black.opacity(0.06), radius: 12, x: 0, y: 3)
                .opacity(quizUnlocked ? 1 : 0.4)
                .disabled(!quizUnlocked)
            }
            .padding(32)
        }
    }

    private var energyColor: Color {
        energy > 60 ? .appSuccess : energy > 30 ? .appWarning : .appError
    }

    private func callMethod(name: String, delta: Int) {
        methodsUsed.insert(name)
        energy = max(0, min(100, energy + delta))
        let sign = delta > 0 ? "+" : ""
        log.append("rex.\(name)  →  energy \(sign)\(delta)  =  \(energy)")
        // Dog barks on every interaction
        AudioManager.shared.playAnimal("woof")
        emojiScale = 1.3
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.15) { emojiScale = 1 }
    }

    private func tapQuiz(name: String, isCorrect: Bool) {
        if isCorrect {
            quizAnswer = .correct
            isComplete = true
        } else {
            quizAnswer = .wrong(name)
            wrongTaps.insert(name)
        }
    }

    private func optionState(name: String, isCorrect: Bool) -> QuizOptionState {
        if case .correct = quizAnswer { return isCorrect ? .correct : .idle }
        if wrongTaps.contains(name) { return .wrong }
        return .idle
    }

    private func sectionLabel(_ text: String) -> some View {
        Text(text).font(.appLabel).foregroundStyle(.secondary).kerning(1.2)
            .frame(maxWidth: .infinity, alignment: .leading)
    }
}

private struct MethodBtn: View {
    let emoji: String
    let label: String
    let used: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            VStack(spacing: 6) {
                Text(emoji).font(.system(size: 26))
                Text(label)
                    .font(.appCode)
                    .foregroundStyle(used ? Color.appPrimary : .primary)
            }
            .frame(maxWidth: .infinity, minHeight: 72)
            .background(
                used ? Color.appPrimary.opacity(0.10) : Color.appFill,
                in: RoundedRectangle(cornerRadius: 14, style: .continuous)
            )
            .overlay(
                RoundedRectangle(cornerRadius: 14, style: .continuous)
                    .stroke(used ? Color.appPrimary.opacity(0.3) : Color.clear, lineWidth: 1.5)
            )
        }
        .buttonStyle(.plain)
    }
}

enum QuizOptionState { case idle, correct, wrong }

private struct QuizOption: View {
    let emoji: String
    let label: String
    let state: QuizOptionState
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack(spacing: 14) {
                Text(emoji).font(.system(size: 22))
                Text(label)
                    .font(.appCodeMd)
                    .foregroundStyle(textColor)
                Spacer()
                if state == .correct {
                    Image(systemName: "checkmark.circle.fill").foregroundStyle(.appSuccess).font(.system(size: 20))
                } else if state == .wrong {
                    Image(systemName: "xmark.circle.fill").foregroundStyle(.appError).font(.system(size: 20))
                }
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 14)
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

#Preview {
    Phase2View(isComplete: .constant(false))
        .frame(width: 664, height: 768)
        .background(Color(uiColor: .secondarySystemBackground))
}
