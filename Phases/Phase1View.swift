import SwiftUI

struct Phase1View: View {
    @Binding var isComplete: Bool

    struct Prop {
        let key: String
        let type: String
        let emoji: String
    }

    let allProps: [Prop] = [
        Prop(key: "nome",    type: "String",  emoji: "🏷️"),
        Prop(key: "especie", type: "String",  emoji: "🐾"),
        Prop(key: "som",     type: "String",  emoji: "🔊"),
        Prop(key: "energia", type: "Int",     emoji: "⚡"),
        Prop(key: "peso",    type: "Double",  emoji: "⚖️"),
    ]

    @State private var selected: Set<String> = []
    @State private var instantiated = false
    @State private var instanceScale: CGFloat = 0.7

    private var canInstantiate: Bool { selected.count >= 3 }

    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                sectionLabel("BLOCO 1 — MONTE A CLASSE")
                classCard
                hintBanner
                sectionLabel("BLOCO 2 — INSTANCIE O OBJETO")
                    .opacity(canInstantiate ? 1 : 0.4)
                instantiationCard
            }
            .padding(32)
        }
    }

    // MARK: - Subviews

    private var classCard: some View {
        VStack(alignment: .leading, spacing: 0) {
            HStack {
                Text("class Animal {")
                    .font(.appCodeMd)
                    .foregroundStyle(.primary)
                Spacer()
                Text("\(selected.count) / 5 props")
                    .font(.appCaption)
                    .foregroundStyle(.secondary)
            }
            .padding(.bottom, 14)

            VStack(alignment: .leading, spacing: 8) {
                ForEach(allProps, id: \.key) { prop in
                    PropRow(
                        prop: prop,
                        isSelected: selected.contains(prop.key)
                    ) {
                        withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                            if selected.contains(prop.key) {
                                selected.remove(prop.key)
                            } else {
                                selected.insert(prop.key)
                            }
                        }
                    }
                }
            }

            Divider().padding(.vertical, 14)

            Text("}")
                .font(.appCodeMd)
                .foregroundStyle(.primary)
        }
        .padding(20)
        .background(Color.appSurface, in: RoundedRectangle(cornerRadius: 18, style: .continuous))
        .shadow(color: .black.opacity(0.06), radius: 12, x: 0, y: 3)
    }

    @ViewBuilder
    private var hintBanner: some View {
        if selected.count < 3 {
            FeedbackBanner(kind: .neutral, message: "Selecione pelo menos 3 propriedades para instanciar.")
        }
    }

    private var instantiationCard: some View {
        VStack(spacing: 16) {
            if instantiated {
                instancePreview
                FeedbackBanner(kind: .success, message: "Instancia criada! rex agora e um objeto do tipo Animal.")
            } else {
                preInstantiateContent
            }
        }
        .padding(20)
        .background(Color.appSurface, in: RoundedRectangle(cornerRadius: 18, style: .continuous))
        .shadow(color: .black.opacity(0.06), radius: 12, x: 0, y: 3)
        .animation(.easeOut(duration: 0.25), value: instantiated)
    }

    private var instancePreview: some View {
        VStack(spacing: 12) {
            Text("🐶")
                .font(.system(size: 52))
                .scaleEffect(instanceScale)
                .onAppear {
                    withAnimation(.spring(response: 0.4, dampingFraction: 0.55)) {
                        instanceScale = 1
                    }
                }

            Text("rex : Animal")
                .font(Font.system(size: 20, weight: .bold, design: .monospaced))
                .foregroundStyle(.appPrimary)

            VStack(alignment: .leading, spacing: 6) {
                ForEach(allProps.filter { selected.contains($0.key) }, id: \.key) { prop in
                    PropValueRow(prop: prop)
                }
            }
        }
        .frame(maxWidth: .infinity)
        .padding(20)
        .background(Color.appPrimary.opacity(0.06), in: RoundedRectangle(cornerRadius: 14, style: .continuous))
        .overlay(
            RoundedRectangle(cornerRadius: 14, style: .continuous)
                .stroke(Color.appPrimary.opacity(0.2), lineWidth: 1.5)
        )
        .transition(.scale(scale: 0.8).combined(with: .opacity))
    }

    private var preInstantiateContent: some View {
        VStack(spacing: 12) {
            Text("let rex = Animal()")
                .font(.appCode)
                .foregroundStyle(canInstantiate ? .secondary : Color(uiColor: .placeholderText))
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(16)
                .background(Color.appFill, in: RoundedRectangle(cornerRadius: 12, style: .continuous))

            AppButton("Criar instancia", icon: "plus.circle") {
                withAnimation(.spring(response: 0.4, dampingFraction: 0.65)) {
                    instantiated = true
                    isComplete = true
                }
            }
            .disabled(!canInstantiate)
            .opacity(canInstantiate ? 1 : 0.4)
        }
    }

    // MARK: - Helpers

    private func sectionLabel(_ text: String) -> some View {
        Text(text)
            .font(.appLabel)
            .foregroundStyle(.secondary)
            .kerning(1.2)
            .frame(maxWidth: .infinity, alignment: .leading)
    }
}

// MARK: - Prop value row (extracted to help compiler)
private struct PropValueRow: View {
    let prop: Phase1View.Prop

    var body: some View {
        HStack(spacing: 6) {
            Text(prop.emoji).font(.system(size: 14))
            Text("\(prop.key):")
                .font(.appCode)
                .foregroundStyle(.secondary)
            Text(defaultValue(for: prop.type))
                .font(.appCodeMd)
                .foregroundStyle(.appPrimary)
        }
    }

    private func defaultValue(for type: String) -> String {
        switch type {
        case "String": return "\"...\""
        case "Int":    return "0"
        case "Double": return "0.0"
        default:       return "nil"
        }
    }
}

// MARK: - Prop row
private struct PropRow: View {
    let prop: Phase1View.Prop
    let isSelected: Bool
    let onTap: () -> Void

    var body: some View {
        Button(action: onTap) {
            HStack(spacing: 10) {
                Image(systemName: isSelected ? "checkmark.circle.fill" : "circle")
                    .font(.system(size: 20))
                    .foregroundStyle(isSelected ? Color.appPrimary : Color(uiColor: .placeholderText))

                Text(prop.emoji).font(.system(size: 16))

                Text("var \(prop.key)")
                    .font(.appCodeMd)
                    .foregroundStyle(isSelected ? Color.appPrimary : .primary)

                Text(": \(prop.type)")
                    .font(.appCode)
                    .foregroundStyle(.secondary)

                Spacer()
            }
            .padding(.horizontal, 14)
            .padding(.vertical, 10)
            .background(
                isSelected ? Color.appPrimary.opacity(0.08) : Color.appFill,
                in: RoundedRectangle(cornerRadius: 10, style: .continuous)
            )
            .overlay(
                RoundedRectangle(cornerRadius: 10, style: .continuous)
                    .stroke(isSelected ? Color.appPrimary.opacity(0.3) : Color.clear, lineWidth: 1.5)
            )
        }
        .buttonStyle(.plain)
    }
}

#Preview {
    Phase1View(isComplete: .constant(false))
        .frame(width: 664, height: 768)
        .background(Color(uiColor: .secondarySystemBackground))
}
