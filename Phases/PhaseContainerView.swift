import SwiftUI

// MARK: - Phase metadata
struct PhaseInfo {
    let number: Int
    let title: String
    let concept: String
    let keywords: [String]
}

extension PhaseInfo {
    static let all: [PhaseInfo] = [
        PhaseInfo(
            number: 1,
            title: "Classes & Objects",
            concept: "A **class** is the blueprint. An **object** is the instance created from it — each object holds its own data.",
            keywords: ["class Animal", "init()", "let rex = Animal()"]
        ),
        PhaseInfo(
            number: 2,
            title: "Properties & Methods",
            concept: "**Properties** are the data an object stores. **Methods** are the actions it performs — they can read and modify that data.",
            keywords: ["var energy: Int", "func bark()", "self.energy"]
        ),
        PhaseInfo(
            number: 3,
            title: "Encapsulation",
            concept: "Protect internal data with **private**. Expose only what is needed through public methods — this prevents accidental changes.",
            keywords: ["private var health", "func getHealth()", "func heal()"]
        ),
        PhaseInfo(
            number: 4,
            title: "Inheritance",
            concept: "A class can **inherit** everything from another and add or override behaviors. This avoids code repetition.",
            keywords: ["class Dog: Animal", "override func", "super.init()"]
        ),
        PhaseInfo(
            number: 5,
            title: "Polymorphism",
            concept: "The same message, **different responses**. Objects of distinct types can be treated as the parent type — each one reacts its own way.",
            keywords: ["[Animal]", "for animal in list", "animal.makeSound()"]
        )
    ]
}

// MARK: - Container
struct PhaseContainerView: View {
    let phaseNumber: Int
    @EnvironmentObject private var appState: AppState
    @State private var isComplete = false

    var info: PhaseInfo { PhaseInfo.all[phaseNumber - 1] }

    var body: some View {
        HStack(spacing: 0) {
            leftPanel
                .frame(width: 360)

            Divider()

            rightPanel
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(Color.appSecondary)
        }
        .ignoresSafeArea()
    }

    // MARK: Left panel
    private var leftPanel: some View {
        VStack(alignment: .leading, spacing: 0) {

            HStack(spacing: 8) {
                Circle()
                    .fill(Color.appPrimary)
                    .frame(width: 8, height: 8)
                Text("Phase \(phaseNumber) of 5")
                    .font(.appLabel)
                    .foregroundStyle(.secondary)
            }
            .padding(.horizontal, 14)
            .padding(.vertical, 7)
            .background(Color.appFill, in: Capsule())
            .padding(.top, 36)

            Spacer().frame(height: 22)

            Text(info.title)
                .font(.appTitle)
                .foregroundStyle(.primary)
                .tracking(-0.5)

            Spacer().frame(height: 16)

            ConceptText(info.concept)
                .font(.appBody)
                .foregroundStyle(.secondary)
                .lineSpacing(5)
                .fixedSize(horizontal: false, vertical: true)

            Spacer().frame(height: 22)

            FlowLayout(spacing: 8) {
                ForEach(info.keywords, id: \.self) { kw in
                    KeywordChip(text: kw)
                }
            }

            Spacer()

            VStack(alignment: .leading, spacing: 20) {
                progressDots

                Button {
                    appState.advance(from: phaseNumber)
                } label: {
                    HStack {
                        Text(phaseNumber == 5 ? "See results" : "Next phase")
                            .font(.appBodyMd)
                        Spacer()
                        Image(systemName: "arrow.right")
                            .font(.appBodyMd)
                    }
                    .foregroundStyle(isComplete ? .white : Color(uiColor: .placeholderText))
                    .padding(.horizontal, 20)
                    .frame(maxWidth: .infinity, minHeight: 52)
                    .background(
                        isComplete ? Color.appPrimary : Color.appFill,
                        in: RoundedRectangle(cornerRadius: 14, style: .continuous)
                    )
                    .animation(.easeOut(duration: 0.3), value: isComplete)
                }
                .buttonStyle(.plain)
                .disabled(!isComplete)
            }
            .padding(.bottom, 36)
        }
        .padding(.horizontal, 32)
        .background(Color.appSurface)
    }

    private var progressDots: some View {
        HStack(spacing: 6) {
            ForEach(1...5, id: \.self) { i in
                if i == phaseNumber {
                    RoundedRectangle(cornerRadius: 4, style: .continuous)
                        .fill(Color.appPrimary)
                        .frame(width: 24, height: 8)
                } else if i < phaseNumber {
                    Circle().fill(Color.appPrimary.opacity(0.4)).frame(width: 8, height: 8)
                } else {
                    Circle().fill(Color.appFill).frame(width: 8, height: 8)
                }
            }
        }
    }

    // MARK: Right panel
    @ViewBuilder
    private var rightPanel: some View {
        switch phaseNumber {
        case 1: Phase1View(isComplete: $isComplete)
        case 2: Phase2View(isComplete: $isComplete)
        case 3: Phase3View(isComplete: $isComplete)
        case 4: Phase4View(isComplete: $isComplete)
        case 5: Phase5View(isComplete: $isComplete)
        default: EmptyView()
        }
    }
}

// MARK: - Attributed concept text
struct ConceptText: View {
    let raw: String
    init(_ raw: String) { self.raw = raw }

    var body: some View { Text(attributed) }

    private var attributed: AttributedString {
        var result = AttributedString()
        let parts = raw.components(separatedBy: "**")
        for (i, part) in parts.enumerated() {
            var attr = AttributedString(part)
            if i % 2 == 1 {
                attr.font = .appBodyMd
                attr.foregroundColor = .primary
            }
            result.append(attr)
        }
        return result
    }
}

// MARK: - Flow layout
struct FlowLayout: Layout {
    var spacing: CGFloat = 8
    func sizeThatFits(proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) -> CGSize {
        let rows = computeRows(proposal: proposal, subviews: subviews)
        let height = rows.map { row in row.map { $0.sizeThatFits(.unspecified).height }.max() ?? 0 }.reduce(0) { $0 + $1 + spacing }
        return CGSize(width: proposal.width ?? 0, height: max(0, height - spacing))
    }
    func placeSubviews(in bounds: CGRect, proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) {
        var y = bounds.minY
        for row in computeRows(proposal: proposal, subviews: subviews) {
            var x = bounds.minX
            let h = row.map { $0.sizeThatFits(.unspecified).height }.max() ?? 0
            for view in row {
                let s = view.sizeThatFits(.unspecified)
                view.place(at: CGPoint(x: x, y: y), proposal: ProposedViewSize(s))
                x += s.width + spacing
            }
            y += h + spacing
        }
    }
    private func computeRows(proposal: ProposedViewSize, subviews: Subviews) -> [[LayoutSubview]] {
        var rows: [[LayoutSubview]] = [[]]
        var x: CGFloat = 0
        let maxW = proposal.width ?? .infinity
        for view in subviews {
            let w = view.sizeThatFits(.unspecified).width
            if x + w > maxW, !rows[rows.count - 1].isEmpty { rows.append([]); x = 0 }
            rows[rows.count - 1].append(view)
            x += w + spacing
        }
        return rows
    }
}

#Preview {
    PhaseContainerView(phaseNumber: 1)
        .environmentObject(AppState())
        .frame(width: 1024, height: 768)
}
