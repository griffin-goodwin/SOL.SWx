import SwiftUI

/// Modal sheet displaying a remote announcement
struct AnnouncementView: View {
    let announcement: Announcement
    let onDismiss: () -> Void

    private var accentColor: Color {
        switch announcement.type {
        case .info:     return .yellow
        case .warning:  return .orange
        case .critical: return .red
        case .success:  return .green
        }
    }

    private var iconName: String {
        switch announcement.type {
        case .info:     return "info.circle.fill"
        case .warning:  return "exclamationmark.triangle.fill"
        case .critical: return "exclamationmark.octagon.fill"
        case .success:  return "checkmark.seal.fill"
        }
    }

    var body: some View {
        VStack(spacing: Theme.Spacing.xl) {
            // Drag indicator
            Capsule()
                .fill(Color.white.opacity(0.25))
                .frame(width: 36, height: 4)
                .padding(.top, Theme.Spacing.sm)

            // Icon
            Image(systemName: iconName)
                .font(.system(size: 40))
                .foregroundStyle(accentColor)
                .padding(.top, Theme.Spacing.md)

            // Title
            Text(announcement.title)
                .font(Theme.mono(18, weight: .bold))
                .foregroundStyle(.white)
                .multilineTextAlignment(.center)

            // Message
            Text(announcement.message)
                .font(Theme.mono(14))
                .foregroundStyle(.white.opacity(0.8))
                .multilineTextAlignment(.center)
                .fixedSize(horizontal: false, vertical: true)
                .padding(.horizontal, Theme.Spacing.lg)

            Spacer()

            VStack(spacing: Theme.Spacing.md) {
                // Optional link button
                if let urlString = announcement.linkURL,
                   let url = URL(string: urlString),
                   let label = announcement.linkLabel {
                    Link(destination: url) {
                        Text(label.uppercased())
                            .font(Theme.mono(13, weight: .semibold))
                            .foregroundStyle(accentColor)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, Theme.Spacing.md)
                            .background(accentColor.opacity(0.12))
                            .clipShape(RoundedRectangle(cornerRadius: Theme.Radius.md, style: .continuous))
                            .overlay(
                                RoundedRectangle(cornerRadius: Theme.Radius.md, style: .continuous)
                                    .stroke(accentColor.opacity(0.3), lineWidth: 1)
                            )
                    }
                }

                // Dismiss button
                Button(action: onDismiss) {
                    Text("GOT IT")
                        .font(Theme.mono(14, weight: .bold))
                        .foregroundStyle(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, Theme.Spacing.md)
                        .background(Color.white.opacity(0.1))
                        .clipShape(RoundedRectangle(cornerRadius: Theme.Radius.md, style: .continuous))
                        .overlay(
                            RoundedRectangle(cornerRadius: Theme.Radius.md, style: .continuous)
                                .stroke(Color.white.opacity(0.15), lineWidth: 1)
                        )
                }
            }
            .padding(.horizontal, Theme.Spacing.lg)
            .padding(.bottom, Theme.Spacing.xxl)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Theme.surface)
        .preferredColorScheme(.dark)
    }
}
