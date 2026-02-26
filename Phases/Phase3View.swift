import SwiftUI

// Fase 3: Três blocos
// Bloco 1 — tentar acessar private diretamente (erro esperado)
// Bloco 2 — usar o método público correto (sucesso)
// Bloco 3 — chamar curar() e confirmar que saude mudou

struct Phase3View: View {
    @Binding var isComplete: Bool

    @State private var block1Done = false   // tentou acesso direto
    @State private var block2Done = false   // usou getSaude()
    @State private var saude: Int = 40      // começa baixo pra ver efeito de curar
    @State private var block3Done = false   // chamou curar()

    @State private var shakeBlock1 = false
    @State private var shakeOffset: CGFloat = 0

    var body: some View {
        ScrollView {
            VStack(spacing: 20) {

                // Class reference card
                classCard

                sectionLabel("BLOCO 1 — ACESSO DIRETO (tente!)")

                block1Card

                sectionLabel("BLOCO 2 — ACESSO VIA MÉTODO")
                    .opacity(block1Done ? 1 : 0.4)

                block2Card
                    .opacity(block1Done ? 1 : 0.4)
                    .disabled(!block1Done)

                sectionLabel("BLOCO 3 — MODIFIQUE VIA MÉTODO")
                    .opacity(block2Done ? 1 : 0.4)

                block3Card
                    .opacity(block2Done ? 1 : 0.4)
                    .disabled(!block2Done)
            }
            .padding(32)
        }
    }

    // MARK: Class reference card
    private var classCard: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("class Animal {")
                .font(.appCodeMd).foregroundStyle(.primary)
            Group {
                codeLine(indent: 1, parts: [
                    ("private var", Color.appError),
                    (" saude: Int = 40", .secondary)
                ])
                codeLine(indent: 1, parts: [
                    ("func", Color.appPrimary),
                    (" getSaude() -> Int", .secondary)
                ])
                codeLine(indent: 1, parts: [
                    ("func", Color.appPrimary),
                    (" curar()", .secondary)
                ])
            }
            Text("}")
                .font(.appCodeMd).foregroundStyle(.primary)
        }
        .padding(18)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color.appSurface, in: RoundedRectangle(cornerRadius: 16, style: .continuous))
        .shadow(color: .black.opacity(0.05), radius: 10, x: 0, y: 2)
    }

    // MARK: Block 1
    private var block1Card: some View {
        VStack(spacing: 14) {
            Text("O que acontece se tentarmos acessar `saude` diretamente?")
                .font(Font.system(size: 17, weight: .regular))
                .foregroundStyle(.primary)

            HStack(spacing: 10) {
                wrongAccessBtn("rex.saude")
                wrongAccessBtn("rex.saude = 100")
            }

            if block1Done {
                FeedbackBanner(
                    kind: .error,
                    message: "error: 'saude' is inaccessible due to 'private' protection level"
                )
                .offset(x: shakeOffset)
                .transition(.move(edge: .top).combined(with: .opacity))
                .onAppear { runShake() }
            }
        }
        .padding(20)
        .background(Color.appSurface, in: RoundedRectangle(cornerRadius: 18, style: .continuous))
        .shadow(color: .black.opacity(0.06), radius: 12, x: 0, y: 3)
        .animation(.easeOut(duration: 0.25), value: block1Done)
    }

    private func wrongAccessBtn(_ label: String) -> some View {
        Button {
            block1Done = true
            runShake()
        } label: {
            Text(label)
                .font(.appCode)
                .foregroundStyle(.red)
                .frame(maxWidth: .infinity, minHeight: 48)
                .background(Color.appError.opacity(0.08), in: RoundedRectangle(cornerRadius: 12, style: .continuous))
                .overlay(RoundedRectangle(cornerRadius: 12, style: .continuous).stroke(Color.appError.opacity(0.2), lineWidth: 1.5))
        }
        .buttonStyle(.plain)
    }

    // MARK: Block 2
    private var block2Card: some View {
        VStack(spacing: 14) {
            Text("Agora use o método público para ler `saude` com segurança.")
                .font(Font.system(size: 17, weight: .regular))
                .foregroundStyle(.primary)

            HStack(spacing: 10) {
                // Wrong
                Button {
                    // no-op, wrong attempt shows nothing extra here
                } label: {
                    Text("rex.saude")
                        .font(.appCode)
                        .foregroundStyle(Color(uiColor: .placeholderText))
                        .frame(maxWidth: .infinity, minHeight: 48)
                        .background(Color.appFill, in: RoundedRectangle(cornerRadius: 12, style: .continuous))
                }
                .buttonStyle(.plain)
                .disabled(true)
                .overlay(
                    RoundedRectangle(cornerRadius: 12, style: .continuous)
                        .stroke(Color.appError.opacity(0.2), lineWidth: 1.5)
                )

                // Correct
                Button {
                    withAnimation { block2Done = true }
                } label: {
                    Text("rex.getSaude()")
                        .font(.appCodeMd)
                        .foregroundStyle(block2Done ? .white : Color.appPrimary)
                        .frame(maxWidth: .infinity, minHeight: 48)
                        .background(
                            block2Done ? Color.appSuccess : Color.appPrimary.opacity(0.10),
                            in: RoundedRectangle(cornerRadius: 12, style: .continuous)
                        )
                        .overlay(RoundedRectangle(cornerRadius: 12, style: .continuous).stroke(block2Done ? Color.clear : Color.appPrimary.opacity(0.3), lineWidth: 1.5))
                }
                .buttonStyle(.plain)
                .disabled(block2Done)
            }

            if block2Done {
                FeedbackBanner(kind: .success, message: "rex.getSaude()  →  \(saude) ✓  Acesso seguro via método público.")
                    .transition(.move(edge: .top).combined(with: .opacity))
            }
        }
        .padding(20)
        .background(Color.appSurface, in: RoundedRectangle(cornerRadius: 18, style: .continuous))
        .shadow(color: .black.opacity(0.06), radius: 12, x: 0, y: 3)
        .animation(.easeOut(duration: 0.25), value: block2Done)
    }

    // MARK: Block 3
    private var block3Card: some View {
        VStack(spacing: 14) {
            HStack(spacing: 16) {
                // Animal health display
                VStack(spacing: 8) {
                    Text("🐶")
                        .font(.system(size: 46))
                    Text("saude: \(saude)")
                        .font(.appCodeMd)
                        .foregroundStyle(saude > 60 ? Color.appSuccess : Color.appWarning)
                    GeometryReader { geo in
                        ZStack(alignment: .leading) {
                            Capsule().fill(Color.appFill).frame(height: 8)
                            Capsule()
                                .fill(saude > 60 ? Color.appSuccess : Color.appWarning)
                                .frame(width: geo.size.width * CGFloat(saude) / 100, height: 8)
                                .animation(.spring(response: 0.5, dampingFraction: 0.7), value: saude)
                        }
                    }
                    .frame(height: 8)
                }
                .frame(width: 140)

                Divider().frame(height: 80)

                VStack(alignment: .leading, spacing: 10) {
                    Text("O método curar() é público e\nmodifica saude internamente.")
                        .font(Font.system(size: 15, weight: .regular))
                        .foregroundStyle(.secondary)
                        .lineSpacing(3)

                    Button {
                        withAnimation { saude = min(100, saude + 40) }
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                            withAnimation { block3Done = true; isComplete = true }
                        }
                    } label: {
                        Text("rex.curar()")
                            .font(.appCodeMd)
                            .foregroundStyle(block3Done ? Color(uiColor: .placeholderText) : .white)
                            .frame(maxWidth: .infinity, minHeight: 46)
                            .background(
                                block3Done ? Color.appFill : Color.appPrimary,
                                in: RoundedRectangle(cornerRadius: 12, style: .continuous)
                            )
                    }
                    .buttonStyle(.plain)
                    .disabled(block3Done)
                }
            }

            if block3Done {
                FeedbackBanner(kind: .success, message: "curar() modificou saude internamente. Fora da classe, ninguém acessa diretamente.")
                    .transition(.move(edge: .top).combined(with: .opacity))
            }
        }
        .padding(20)
        .background(Color.appSurface, in: RoundedRectangle(cornerRadius: 18, style: .continuous))
        .shadow(color: .black.opacity(0.06), radius: 12, x: 0, y: 3)
        .animation(.easeOut(duration: 0.25), value: block3Done)
    }

    // MARK: Helpers
    private func runShake() {
        let keyframes: [(CGFloat, Double)] = [(-10, 0), (10, 0.08), (-6, 0.16), (6, 0.24), (0, 0.32)]
        for (offset, delay) in keyframes {
            DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
                withAnimation(.easeInOut(duration: 0.07)) { shakeOffset = offset }
            }
        }
    }

    private func sectionLabel(_ text: String) -> some View {
        Text(text).font(.appLabel).foregroundStyle(.secondary).kerning(1.2)
            .frame(maxWidth: .infinity, alignment: .leading)
    }

    private func codeLine(indent: Int, parts: [(String, Color)]) -> some View {
        HStack(spacing: 0) {
            Text(String(repeating: "  ", count: indent))
                .font(.appCode).foregroundStyle(.clear)
            ForEach(Array(parts.enumerated()), id: \.offset) { _, part in
                Text(part.0).font(.appCode).foregroundStyle(part.1)
            }
        }
    }
}

#Preview {
    Phase3View(isComplete: .constant(false))
        .frame(width: 664, height: 768)
        .background(Color(uiColor: .secondarySystemBackground))
}
