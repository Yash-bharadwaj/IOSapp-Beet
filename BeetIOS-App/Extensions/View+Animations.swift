import SwiftUI

extension View {
    func bounceAnimation() -> some View {
        self.modifier(BounceModifier())
    }
    
    func pulseAnimation() -> some View {
        self.modifier(PulseModifier())
    }
    
    func shakeAnimation() -> some View {
        self.modifier(ShakeModifier())
    }
}

struct BounceModifier: ViewModifier {
    @State private var isAnimating = false
    
    func body(content: Content) -> some View {
        content
            .scaleEffect(isAnimating ? 1.1 : 1.0)
            .animation(
                Animation.spring(response: 0.3, dampingFraction: 0.6)
                    .repeatForever(autoreverses: true),
                value: isAnimating
            )
            .onAppear {
                isAnimating = true
            }
    }
}

struct PulseModifier: ViewModifier {
    @State private var isAnimating = false
    
    func body(content: Content) -> some View {
        content
            .opacity(isAnimating ? 0.5 : 1.0)
            .animation(
                Animation.easeInOut(duration: 1.5)
                    .repeatForever(autoreverses: true),
                value: isAnimating
            )
            .onAppear {
                isAnimating = true
            }
    }
}

struct ShakeModifier: ViewModifier {
    @State private var shake = false
    
    func body(content: Content) -> some View {
        content
            .offset(x: shake ? -8 : 8)
            .animation(
                Animation.default.repeatCount(3, autoreverses: true)
                    .speed(6),
                value: shake
            )
            .onAppear {
                shake = true
            }
    }
}

