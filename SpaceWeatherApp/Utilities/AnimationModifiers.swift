import SwiftUI

// MARK: - Staggered Appearance Animation

struct StaggeredAppearance: ViewModifier {
    let index: Int
    let baseDelay: Double
    @State private var isVisible = false

    func body(content: Content) -> some View {
        content
            .opacity(isVisible ? 1 : 0)
            .offset(y: isVisible ? 0 : 20)
            .onAppear {
                withAnimation(.spring(response: 0.5, dampingFraction: 0.8).delay(baseDelay + Double(index) * 0.05)) {
                    isVisible = true
                }
            }
    }
}

extension View {
    func staggeredAppearance(index: Int, baseDelay: Double = 0) -> some View {
        modifier(StaggeredAppearance(index: index, baseDelay: baseDelay))
    }
}

// MARK: - Slide In Animation

struct SlideIn: ViewModifier {
    let edge: Edge
    let delay: Double
    @State private var isVisible = false

    func body(content: Content) -> some View {
        content
            .opacity(isVisible ? 1 : 0)
            .offset(x: offsetX, y: offsetY)
            .onAppear {
                withAnimation(.spring(response: 0.6, dampingFraction: 0.75).delay(delay)) {
                    isVisible = true
                }
            }
    }

    private var offsetX: CGFloat {
        guard !isVisible else { return 0 }
        switch edge {
        case .leading: return -30
        case .trailing: return 30
        default: return 0
        }
    }

    private var offsetY: CGFloat {
        guard !isVisible else { return 0 }
        switch edge {
        case .top: return -30
        case .bottom: return 30
        default: return 0
        }
    }
}

extension View {
    func slideIn(from edge: Edge = .bottom, delay: Double = 0) -> some View {
        modifier(SlideIn(edge: edge, delay: delay))
    }
}

// MARK: - Scale Fade Animation

struct ScaleFade: ViewModifier {
    let delay: Double
    @State private var isVisible = false

    func body(content: Content) -> some View {
        content
            .opacity(isVisible ? 1 : 0)
            .scaleEffect(isVisible ? 1 : 0.92)
            .onAppear {
                withAnimation(.spring(response: 0.5, dampingFraction: 0.8).delay(delay)) {
                    isVisible = true
                }
            }
    }
}

extension View {
    func scaleFade(delay: Double = 0) -> some View {
        modifier(ScaleFade(delay: delay))
    }
}

// MARK: - Pulsing Glow

struct PulsingGlow: ViewModifier {
    let color: Color
    let radius: CGFloat
    @State private var isPulsing = false

    func body(content: Content) -> some View {
        content
            .shadow(color: color.opacity(isPulsing ? 0.6 : 0.3), radius: isPulsing ? radius * 1.3 : radius)
            .onAppear {
                withAnimation(.easeInOut(duration: 1.5).repeatForever(autoreverses: true)) {
                    isPulsing = true
                }
            }
    }
}

extension View {
    func pulsingGlow(color: Color, radius: CGFloat = 10) -> some View {
        modifier(PulsingGlow(color: color, radius: radius))
    }
}

// MARK: - Breathing Scale

struct BreathingScale: ViewModifier {
    let minScale: CGFloat
    let maxScale: CGFloat
    let duration: Double
    @State private var isBreathing = false

    func body(content: Content) -> some View {
        content
            .scaleEffect(isBreathing ? maxScale : minScale)
            .onAppear {
                withAnimation(.easeInOut(duration: duration).repeatForever(autoreverses: true)) {
                    isBreathing = true
                }
            }
    }
}

extension View {
    func breathingScale(min: CGFloat = 0.98, max: CGFloat = 1.02, duration: Double = 2) -> some View {
        modifier(BreathingScale(minScale: min, maxScale: max, duration: duration))
    }
}

// MARK: - Animated Counter

struct AnimatedNumber: View {
    let value: Int
    let font: Font
    let color: Color

    @State private var displayedValue: Int = 0

    var body: some View {
        Text("\(displayedValue)")
            .font(font)
            .foregroundStyle(color)
            .contentTransition(.numericText(value: Double(displayedValue)))
            .onChange(of: value) { oldValue, newValue in
                withAnimation(.spring(response: 0.4, dampingFraction: 0.8)) {
                    displayedValue = newValue
                }
            }
            .onAppear {
                withAnimation(.spring(response: 0.6, dampingFraction: 0.8).delay(0.2)) {
                    displayedValue = value
                }
            }
    }
}

// MARK: - Shimmer Loading Effect (Enhanced)

struct EnhancedShimmer: ViewModifier {
    @State private var phase: CGFloat = 0

    func body(content: Content) -> some View {
        content
            .overlay(
                GeometryReader { geo in
                    LinearGradient(
                        stops: [
                            .init(color: .clear, location: 0),
                            .init(color: .white.opacity(0.15), location: 0.3),
                            .init(color: .white.opacity(0.25), location: 0.5),
                            .init(color: .white.opacity(0.15), location: 0.7),
                            .init(color: .clear, location: 1)
                        ],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                    .frame(width: geo.size.width * 2)
                    .offset(x: -geo.size.width + (geo.size.width * 2 * phase))
                }
                .mask(content)
            )
            .onAppear {
                withAnimation(.linear(duration: 1.5).repeatForever(autoreverses: false)) {
                    phase = 1
                }
            }
    }
}

extension View {
    func enhancedShimmer() -> some View {
        modifier(EnhancedShimmer())
    }
}

// MARK: - Card Hover Effect

struct CardHover: ViewModifier {
    @State private var isHovered = false

    func body(content: Content) -> some View {
        content
            .scaleEffect(isHovered ? 1.02 : 1.0)
            .shadow(
                color: .black.opacity(isHovered ? 0.3 : 0.15),
                radius: isHovered ? 15 : 8,
                y: isHovered ? 8 : 4
            )
            .onLongPressGesture(minimumDuration: .infinity, pressing: { pressing in
                withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                    isHovered = pressing
                }
            }, perform: {})
    }
}

extension View {
    func cardHover() -> some View {
        modifier(CardHover())
    }
}
