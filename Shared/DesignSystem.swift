import SwiftUI

// MARK: - Color palette
extension Color {
    static let appPrimary   = Color(uiColor: .systemBlue)
    static let appSuccess   = Color(uiColor: .systemGreen)
    static let appError     = Color(uiColor: .systemRed)
    static let appWarning   = Color(uiColor: .systemOrange)
    static let appSurface   = Color(uiColor: .systemBackground)
    static let appSecondary = Color(uiColor: .secondarySystemBackground)
    static let appFill      = Color(uiColor: .secondarySystemFill)
    static let appBorder    = Color(uiColor: .separator)
}

extension ShapeStyle where Self == Color {
    static var appPrimary:   Color { .appPrimary }
    static var appSuccess:   Color { .appSuccess }
    static var appError:     Color { .appError }
    static var appWarning:   Color { .appWarning }
    static var appSurface:   Color { .appSurface }
    static var appSecondary: Color { .appSecondary }
    static var appFill:      Color { .appFill }
    static var appBorder:    Color { .appBorder }
}

// MARK: - Type scale
extension Font {
    static var appDisplay:     Font { .system(size: 64, weight: .bold) }
    static var appLargeTitle:  Font { .system(size: 36, weight: .bold) }
    static var appTitle:       Font { .system(size: 34, weight: .bold) }
    static var appHeadline:    Font { .system(size: 22, weight: .bold) }
    static var appSubheadline: Font { .system(size: 18, weight: .regular) }
    static var appBody:        Font { .system(size: 17, weight: .regular) }
    static var appBodyMd:      Font { .system(size: 17, weight: .medium) }
    static var appCode:        Font { .system(size: 15, weight: .regular, design: .monospaced) }
    static var appCodeMd:      Font { .system(size: 15, weight: .semibold, design: .monospaced) }
    static var appLabel:       Font { .system(size: 13, weight: .semibold) }
    static var appCaption:     Font { .system(size: 12, weight: .medium) }
}

// MARK: - Primary button
struct AppButton: View {
    let label: String
    let icon: String?
    let style: Style
    let action: () -> Void

    enum Style { case primary, secondary, destructive }

    init(_ label: String, icon: String? = nil, style: Style = .primary, action: @escaping () -> Void) {
        self.label = label; self.icon = icon; self.style = style; self.action = action
    }

    var body: some View {
        Button(action: action) {
            HStack(spacing: 8) {
                if let icon { Image(systemName: icon).font(.appLabel) }
                Text(label).font(.appBodyMd)
            }
            .foregroundStyle(fgColor)
            .frame(maxWidth: .infinity, minHeight: 52)
            .background(bgColor, in: RoundedRectangle(cornerRadius: 14, style: .continuous))
        }
        .buttonStyle(.plain)
    }

    private var bgColor: Color {
        switch style {
        case .primary:     return .appPrimary
        case .secondary:   return .appFill
        case .destructive: return Color(uiColor: .systemRed).opacity(0.12)
        }
    }

    private var fgColor: Color {
        switch style {
        case .primary:     return .white
        case .secondary:   return .primary
        case .destructive: return .appError
        }
    }
}

// MARK: - Keyword chip
struct KeywordChip: View {
    let text: String
    var selected: Bool = false

    var body: some View {
        Text(text)
            .font(.appCodeMd)
            .foregroundStyle(selected ? .white : .appPrimary)
            .padding(.horizontal, 12)
            .padding(.vertical, 6)
            .background(
                selected ? Color.appPrimary : Color.appPrimary.opacity(0.12),
                in: RoundedRectangle(cornerRadius: 8, style: .continuous)
            )
    }
}

// MARK: - Feedback banner
struct FeedbackBanner: View {
    enum Kind { case error, success, neutral }
    let kind: Kind
    let message: String

    var body: some View {
        HStack(spacing: 10) {
            Image(systemName: icon)
                .font(.system(size: 16, weight: .semibold))
                .foregroundStyle(color)
            Text(message)
                .font(.appCode)
                .foregroundStyle(color)
            Spacer()
        }
        .padding(14)
        .background(color.opacity(0.10), in: RoundedRectangle(cornerRadius: 12, style: .continuous))
        .overlay(RoundedRectangle(cornerRadius: 12, style: .continuous).stroke(color.opacity(0.25), lineWidth: 1))
    }

    private var color: Color {
        switch kind {
        case .error:   return .appError
        case .success: return .appSuccess
        case .neutral: return Color(uiColor: .tertiaryLabel)
        }
    }

    private var icon: String {
        switch kind {
        case .error:   return "xmark.circle.fill"
        case .success: return "checkmark.circle.fill"
        case .neutral: return "circle.dashed"
        }
    }
}
