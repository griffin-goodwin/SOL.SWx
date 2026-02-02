import SwiftUI

/// Compact bottom banner that expands to show full announcement details
struct AnnouncementView: View {
    let announcement: Announcement
    let onDismiss: () -> Void

    @State private var isExpanded = false
    @State private var isVisible = false

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
        Group {
            if isExpanded {
                expandedView
            } else {
                collapsedBanner
            }
        }
        .offset(y: isVisible ? 0 : 60)
        .opacity(isVisible ? 1 : 0)
        .onAppear {
            withAnimation(.spring(response: 0.6, dampingFraction: 0.75).delay(0.3)) {
                isVisible = true
            }
        }
    }

    // MARK: - Collapsed Banner

    private var collapsedBanner: some View {
        Button {
            withAnimation(Theme.Animation.spring) {
                isExpanded = true
            }
        } label: {
            HStack(spacing: Theme.Spacing.sm) {
                Circle()
                    .fill(accentColor)
                    .frame(width: 8, height: 8)

                Image(systemName: iconName)
                    .font(.system(size: 14))
                    .foregroundStyle(accentColor)

                Text(announcement.title)
                    .font(Theme.mono(13, weight: .semibold))
                    .foregroundStyle(.white)
                    .lineLimit(1)

                Spacer()

                Image(systemName: "chevron.up")
                    .font(.system(size: 11, weight: .semibold))
                    .foregroundStyle(.white.opacity(0.5))
            }
            .padding(.horizontal, Theme.Spacing.lg)
            .padding(.vertical, Theme.Spacing.md)
            .background(
                RoundedRectangle(cornerRadius: Theme.Radius.xl, style: .continuous)
                    .fill(.ultraThinMaterial)
                    .overlay(
                        RoundedRectangle(cornerRadius: Theme.Radius.xl, style: .continuous)
                            .fill(Color.black.opacity(0.35))
                    )
                    .overlay(
                        RoundedRectangle(cornerRadius: Theme.Radius.xl, style: .continuous)
                            .stroke(accentColor.opacity(0.4), lineWidth: 1)
                    )
            )
            .padding(.horizontal, Theme.Spacing.lg)
        }
        .buttonStyle(.plain)
    }

    // MARK: - Expanded Detail

    private var expandedView: some View {
        VStack(spacing: Theme.Spacing.lg) {
            // Collapse button
            HStack {
                Spacer()
                Button {
                    withAnimation(Theme.Animation.spring) {
                        isExpanded = false
                    }
                } label: {
                    Image(systemName: "chevron.down")
                        .font(.system(size: 13, weight: .semibold))
                        .foregroundStyle(.white.opacity(0.5))
                        .frame(width: 32, height: 32)
                        .background(Color.white.opacity(0.08))
                        .clipShape(Circle())
                }
                .buttonStyle(.plain)
            }

            // Icon
            Image(systemName: iconName)
                .font(.system(size: 32))
                .foregroundStyle(accentColor)

            // Title
            Text(announcement.title)
                .font(Theme.mono(16, weight: .bold))
                .foregroundStyle(.white)
                .multilineTextAlignment(.center)

            // Message
            Text(announcement.message)
                .font(Theme.mono(13))
                .foregroundStyle(.white.opacity(0.8))
                .multilineTextAlignment(.center)
                .fixedSize(horizontal: false, vertical: true)

            // Optional link button
            if let urlString = announcement.linkURL,
               let url = URL(string: urlString),
               let label = announcement.linkLabel {
                Link(destination: url) {
                    Text(label.uppercased())
                        .font(Theme.mono(12, weight: .semibold))
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
                    .font(Theme.mono(13, weight: .bold))
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
            .buttonStyle(.plain)
        }
        .padding(Theme.Spacing.lg)
        .background(
            RoundedRectangle(cornerRadius: Theme.Radius.xl, style: .continuous)
                .fill(.ultraThinMaterial)
                .overlay(
                    RoundedRectangle(cornerRadius: Theme.Radius.xl, style: .continuous)
                        .fill(Color.black.opacity(0.35))
                )
                .overlay(
                    RoundedRectangle(cornerRadius: Theme.Radius.xl, style: .continuous)
                        .stroke(
                            LinearGradient(
                                colors: [accentColor.opacity(0.5), accentColor.opacity(0.15)],
                                startPoint: .top,
                                endPoint: .bottom
                            ),
                            lineWidth: 1
                        )
                )
                .shadow(color: Color.black.opacity(0.3), radius: 20, y: 10)
        )
        .padding(.horizontal, Theme.Spacing.lg)
        .transition(.scale(scale: 0.95).combined(with: .opacity))
    }
}
