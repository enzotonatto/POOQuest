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
            title: "Classes & Objetos",
            concept: "Uma **classe** é a planta do projeto. Um **objeto** é a instância criada a partir dela — cada objeto tem seus próprios dados.",
            keywords: ["class Animal", "init()", "let rex = Animal()"]
        ),
        PhaseInfo(
            number: 2,
            title: "Atributos & Métodos",
            concept: "**Atributos** são os dados que o objeto guarda. **Métodos** são as ações que ele executa — eles podem ler e modificar esses dados.",
            keywords: ["var energia: Int", "func latir()", "self.energia"]
        ),
        PhaseInfo(
            number: 3,
            title: "Encapsulamento",
            concept: "Proteja os dados internos com **private**. Exponha apenas o necessário via métodos públicos — isso evita alterações acidentais.",
            keywords: ["private var saude", "func getSaude()", "func curar()"]
        ),
        PhaseInfo(
            number: 4,
            title: "Herança",
            concept: "Uma classe pode **herdar** tudo de outra e adicionar ou sobrescrever comportamentos. Isso evita repetição de código.",
            keywords: ["class Cachorro: Animal", "override func", "super.init()"]
        ),
        PhaseInfo(
            number: 5,
            title: "Polimorfismo",
            concept: "A mesma mensagem, **respostas diferentes**. Objetos de tipos distintos podem ser tratados como o tipo pai — cada um reage do seu jeito.",
            keywords: ["[Animal]", "for animal in lista", "animal.fazerSom()"]
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

            // Phase pill
            HStack(spacing: 8) {
                Circle()
                    .fill(Color.appPrimary)
                    .frame(width: 8, height: 8)
                Text("Fase \(phaseNumber) de 5")
                    .font(.appLabel)
                    .foregroundStyle(.secondary)
            }
            .padding(.horizontal, 14)
            .padding(.vertical, 7)
            .background(Color.appFill, in: Capsule())
            .padding(.top, 36)

            Spacer().frame(height: 22)

            // Title
            Text(info.title)
                .font(.appTitle)
                .foregroundStyle(.primary)
                .tracking(-0.5)

            Spacer().frame(height: 16)

            // Concept
            ConceptText(info.concept)
                .font(Font.system(size: 17, weight: .regular))
                .foregroundStyle(.secondary)
                .lineSpacing(5)
                .fixedSize(horizontal: false, vertical: true)

            Spacer().frame(height: 22)

            // Keywords
            FlowLayout(spacing: 8) {
                ForEach(info.keywords, id: \.self) { kw in
                    KeywordChip(text: kw)
                }
            }

            Spacer()

            // Progress + Next button
            VStack(alignment: .leading, spacing: 20) {
                progressDots

                Button {
                    appState.advance(from: phaseNumber)
                } label: {
                    HStack {
                        Text(phaseNumber == 5 ? "Ver resultado" : "Próxima fase")
                            .font(Font.system(size: 17, weight: .semibold))
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
                attr.font = .system(size: 17, weight: .semibold)
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
