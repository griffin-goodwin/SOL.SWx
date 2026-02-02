import SwiftUI

/// Dynamic app title that changes color with the selected instrument
struct SolarTitleView: View {
    var accentColor: Color = .orange

    var body: some View {
        HStack(alignment: .firstTextBaseline, spacing: 0) {
            Text("SOL")
                .font(.system(size: 32, weight: .heavy, design: .default))
                .foregroundStyle(.white)

            // The dot - always bright and visible with white outline effect
            Text(".")
                .font(.system(size: 36, weight: .black, design: .default))
                .foregroundStyle(dotColor)
                .shadow(color: .white.opacity(0.8), radius: 1, x: 0, y: 0)
                .shadow(color: dotColor, radius: 6, x: 0, y: 0)

            Text("SWx")
                .font(.system(size: 32, weight: .heavy, design: .default))
                .foregroundStyle(swxColor)
        }
        .tracking(-0.5)
        .shadow(color: accentColor.opacity(0.4), radius: 10, x: 0, y: 0)
        .animation(.easeInOut(duration: 0.3), value: accentColor.description)
    }

    // Ensure dot is always visible - brighten dark colors
    private var dotColor: Color {
        // For colors that might be too dark, use a brighter version
        switch accentColor {
        case .green:
            return Color(red: 0.3, green: 0.9, blue: 0.4)
        case .teal:
            return Color(red: 0.2, green: 0.85, blue: 0.8)
        case .blue:
            return Color(red: 0.4, green: 0.7, blue: 1.0)
        case .purple:
            return Color(red: 0.7, green: 0.5, blue: 1.0)
        case .pink:
            return Color(red: 1.0, green: 0.5, blue: 0.7)
        case .red:
            return Color(red: 1.0, green: 0.4, blue: 0.4)
        case .yellow:
            return Color(red: 1.0, green: 0.95, blue: 0.4)
        case .orange:
            return Color(red: 1.0, green: 0.6, blue: 0.2)
        case .gray:
            return Color(red: 0.8, green: 0.8, blue: 0.85)
        default:
            return accentColor
        }
    }

    // SWx color - slightly dimmer than the dot
    private var swxColor: Color {
        dotColor.opacity(0.85)
    }
}

#Preview {
    ZStack {
        Color.black
        VStack(spacing: 20) {
            SolarTitleView(accentColor: .orange)
            SolarTitleView(accentColor: .green)
            SolarTitleView(accentColor: .teal)
            SolarTitleView(accentColor: .purple)
            SolarTitleView(accentColor: .blue)
            SolarTitleView(accentColor: .gray)
        }
    }
}
