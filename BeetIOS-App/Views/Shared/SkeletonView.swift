import SwiftUI

struct SkeletonModifier: ViewModifier {
    @State private var isAnimating = false
    
    func body(content: Content) -> some View {
        content
            .overlay(
                GeometryReader { geometry in
                    LinearGradient(
                        colors: [
                            Color.white.opacity(0.1),
                            Color.white.opacity(0.3),
                            Color.white.opacity(0.1)
                        ],
                        startPoint: .leading,
                        endPoint: .trailing
                    )
                    .frame(width: geometry.size.width * 2)
                    .offset(x: isAnimating ? geometry.size.width : -geometry.size.width)
                    .blur(radius: 8)
                }
            )
            .onAppear {
                withAnimation(
                    Animation.linear(duration: 1.5)
                        .repeatForever(autoreverses: false)
                ) {
                    isAnimating = true
                }
            }
    }
}

extension View {
    func skeleton() -> some View {
        modifier(SkeletonModifier())
    }
}

struct SkeletonView: View {
    let width: CGFloat?
    let height: CGFloat
    let cornerRadius: CGFloat
    
    init(width: CGFloat? = nil, height: CGFloat, cornerRadius: CGFloat = 8) {
        self.width = width
        self.height = height
        self.cornerRadius = cornerRadius
    }
    
    var body: some View {
        RoundedRectangle(cornerRadius: cornerRadius)
            .fill(Color.white.opacity(0.1))
            .frame(width: width, height: height)
            .skeleton()
    }
}

