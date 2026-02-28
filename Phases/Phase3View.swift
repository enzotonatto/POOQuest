import SwiftUI

// Phase 3: Three blocks
// Block 1 — try to access private directly (expected error with shield feedback)
// Block 2 — use the correct public method (success)
// Block 3 — call heal() and confirm health changed up to the limit

struct Phase3View: View {
    @Binding var isComplete: Bool

    @State private var block1Done = false
    @State private var block2Done = false
    @State private var health: Int = 80 // Increased starting health to show the 100 cap faster
    @State private var block3Done = false
    @State private var shakeOffset: CGFloat = 0

    var body: some View {
        ScrollView {
            VStack(spacing: 20) {

                classCard

                sectionLabel("BLOCK 1 — THE THREAT (try it!)")

                block1Card

                sectionLabel("BLOCK 2 — SAFE READ")
                    .opacity(block1Done ? 1 : 0.4)

                block2Card
                    .opacity(block1Done ? 1 : 0.4)
                    .disabled(!block1Done)

                sectionLabel("BLOCK 3 — SAFE WRITE")
                    .opacity(block2Done ? 1 : 0.4)

                block3Card
                    .opacity(block2Done ? 1 : 0.4)
                    .disabled(!block2Done)
            }
            .padding(32)
        }
    }

    private var classCard: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("class Animal {")
                .font(.appCodeMd).foregroundStyle(.primary)
            Group {
                codeLine(indent: 1, parts: [("private var", Color.appError), (" health: Int = 80", .secondary)])
                codeLine(indent: 1, parts: [("func", Color.appPrimary), (" getHealth() -> Int", .secondary)])
                
                // Show the actual business logic to explain WHY we encapsulate
                codeLine(indent: 1, parts: [("func", Color.appPrimary), (" heal() {", .primary)])
                codeLine(indent: 2, parts: [("health", .primary), (" += 40", .secondary)])
                codeLine(indent: 2, parts: [("if", Color.appPrimary), (" health > 100 { health = 100 }", .secondary)])
                codeLine(indent: 1, parts: [("}", .primary)])
            }
            Text("}")
                .font(.appCodeMd).foregroundStyle(.primary)
        }
        .padding(18)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color.appSurface, in: RoundedRectangle(cornerRadius: 16, style: .continuous))
        .shadow(color: .black.opacity(0.05), radius: 10, x: 0, y: 2)
    }

    private var block1Card: some View {
        VStack(spacing: 14) {
            Text("What if a bug tries to set `health` to -999? Try it!")
                .font(.appBody)
                .foregroundStyle(.primary)

            HStack(spacing: 10) {
                wrongAccessBtn("rex.health")
                wrongAccessBtn("rex.health = -999")
            }

            if block1Done {
                HStack(alignment: .center, spacing: 12) {
                    Text("🛡️")
                        .font(.system(size: 32))
                        .offset(x: shakeOffset)
                    
                    FeedbackBanner(
                        kind: .error,
                        message: "error: 'health' is inaccessible due to 'private' protection. The shield holds!"
                    )
                }
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
            withAnimation { block1Done = true }
            runShake()
        } label: {
            Text(label)
                .font(.appCode)
                .foregroundStyle(block1Done ? Color.appError : .primary)
                .frame(maxWidth: .infinity, minHeight: 48)
                .background(
                    block1Done ? Color.appError.opacity(0.08) : Color.appFill,
                    in: RoundedRectangle(cornerRadius: 12, style: .continuous)
                )
                .overlay(
                    RoundedRectangle(cornerRadius: 12, style: .continuous)
                        .stroke(block1Done ? Color.appError.opacity(0.3) : Color.clear, lineWidth: 1.5)
                )
        }
        .buttonStyle(.plain)
    }

    private var block2Card: some View {
        VStack(spacing: 14) {
            Text("Use the public method to read `health` safely.")
                .font(.appBody)
                .foregroundStyle(.primary)

            HStack(spacing: 10) {
                Button { } label: {
                    Text("rex.health")
                        .font(.appCode)
                        .foregroundStyle(Color(uiColor: .placeholderText))
                        .frame(maxWidth: .infinity, minHeight: 48)
                        .background(Color.appFill, in: RoundedRectangle(cornerRadius: 12, style: .continuous))
                }
                .buttonStyle(.plain)
                .disabled(true)
                .overlay(RoundedRectangle(cornerRadius: 12, style: .continuous).stroke(Color.appError.opacity(0.2), lineWidth: 1.5))

                Button {
                    withAnimation { block2Done = true }
                } label: {
                    Text("rex.getHealth()")
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
                FeedbackBanner(kind: .success, message: "rex.getHealth()  →  \(health) ✓  Safe read via method.")
                    .transition(.move(edge: .top).combined(with: .opacity))
            }
        }
        .padding(20)
        .background(Color.appSurface, in: RoundedRectangle(cornerRadius: 18, style: .continuous))
        .shadow(color: .black.opacity(0.06), radius: 12, x: 0, y: 3)
        .animation(.easeOut(duration: 0.25), value: block2Done)
    }

    private var block3Card: some View {
        VStack(spacing: 14) {
            HStack(spacing: 16) {
                VStack(spacing: 8) {
                    Text("🐶").font(.system(size: 46))
                    Text("health: \(health)")
                        .font(.appCodeMd)
                        .foregroundStyle(health > 60 ? Color.appSuccess : Color.appWarning)
                    GeometryReader { geo in
                        ZStack(alignment: .leading) {
                            Capsule().fill(Color.appFill).frame(height: 8)
                            Capsule()
                                .fill(health > 60 ? Color.appSuccess : Color.appWarning)
                                .frame(width: geo.size.width * CGFloat(health) / 100, height: 8)
                                .animation(.spring(response: 0.5, dampingFraction: 0.7), value: health)
                        }
                    }
                    .frame(height: 8)
                }
                .frame(width: 140)

                Divider().frame(height: 80)

                VStack(alignment: .leading, spacing: 10) {
                    Text("heal() is public and controls the 100 limit internally.")
                        .font(.appCode)
                        .foregroundStyle(.secondary)
                        .lineSpacing(3)

                    Button {
                        withAnimation { health = min(100, health + 40) }
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                            withAnimation { block3Done = true; isComplete = true }
                        }
                    } label: {
                        Text("rex.heal()")
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
                FeedbackBanner(kind: .success, message: "Health increased but safely capped at 100! The object protects its own data.")
                    .transition(.move(edge: .top).combined(with: .opacity))
            }
        }
        .padding(20)
        .background(Color.appSurface, in: RoundedRectangle(cornerRadius: 18, style: .continuous))
        .shadow(color: .black.opacity(0.06), radius: 12, x: 0, y: 3)
        .animation(.easeOut(duration: 0.25), value: block3Done)
    }

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
            Text(String(repeating: "  ", count: indent)).font(.appCode).foregroundStyle(.clear)
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
