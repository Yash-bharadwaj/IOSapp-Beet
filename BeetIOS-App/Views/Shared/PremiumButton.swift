import SwiftUI

struct PremiumButton: View {
    let title: String
    let action: () -> Void
    
    @State private var isPressed = false
    @State private var glowIntensity: Double = 0.6
    @State private var shimmerOffset: CGFloat = -200
    
    var body: some View {
        Button(action: {
            withAnimation(.spring(response: 0.2, dampingFraction: 0.6)) {
                isPressed = true
            }
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                withAnimation(.spring(response: 0.2, dampingFraction: 0.6)) {
                    isPressed = false
                }
            }
            
            action()
        }) {
            ZStack {
                // Outer glow layer
                RoundedRectangle(cornerRadius: 28)
                    .fill(
                        LinearGradient(
                            colors: [
                                Color.buttonYellow.opacity(0.4),
                                Color(hex: "FF8C00").opacity(0.3)
                            ],
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
                    .blur(radius: 25)
                    .opacity(glowIntensity)
                    .offset(y: 4)
                
                // Main button background
                RoundedRectangle(cornerRadius: 28)
                    .fill(
                        LinearGradient(
                            colors: [
                                Color.buttonYellow,
                                Color(hex: "FF8C00"),
                                Color(hex: "FF6B00")
                            ],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .overlay(
                        // Shimmer effect
                        RoundedRectangle(cornerRadius: 28)
                            .fill(
                                LinearGradient(
                                    colors: [
                                        Color.clear,
                                        Color.white.opacity(0.3),
                                        Color.clear
                                    ],
                                    startPoint: .leading,
                                    endPoint: .trailing
                                )
                            )
                            .offset(x: shimmerOffset)
                            .blur(radius: 10)
                    )
                    .overlay(
                        // Inner highlight
                        RoundedRectangle(cornerRadius: 28)
                            .fill(
                                LinearGradient(
                                    colors: [
                                        Color.white.opacity(0.25),
                                        Color.white.opacity(0.1),
                                        Color.clear
                                    ],
                                    startPoint: .top,
                                    endPoint: .bottom
                                )
                            )
                    )
                    .overlay(
                        // Border glow
                        RoundedRectangle(cornerRadius: 28)
                            .stroke(
                                LinearGradient(
                                    colors: [
                                        Color.white.opacity(0.4),
                                        Color.white.opacity(0.1),
                                        Color.clear
                                    ],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                ),
                                lineWidth: 1.5
                            )
                    )
                    .shadow(color: Color.buttonYellow.opacity(0.6), radius: 25, x: 0, y: 10)
                    .shadow(color: Color.buttonYellow.opacity(0.4), radius: 50, x: 0, y: 20)
                
                // Button text
                Text(title)
                    .font(.system(size: 17, weight: .bold))
                    .foregroundColor(.white)
                    .shadow(color: Color.black.opacity(0.3), radius: 3, x: 0, y: 2)
                    .overlay(
                        // Text highlight
                        Text(title)
                            .font(.system(size: 17, weight: .bold))
                            .foregroundColor(.white.opacity(0.5))
                            .blur(radius: 1)
                            .offset(y: 1)
                    )
            }
            .frame(maxWidth: .infinity)
            .frame(height: 56)
            .clipShape(RoundedRectangle(cornerRadius: 28))
        }
        .scaleEffect(isPressed ? 0.96 : 1.0)
        .animation(.spring(response: 0.2, dampingFraction: 0.6), value: isPressed)
        .accessibilityLabel(title)
        .accessibilityHint("Double tap to continue")
        .onAppear {
            // Subtle pulsing glow effect
            withAnimation(.easeInOut(duration: 2.5).repeatForever(autoreverses: true)) {
                glowIntensity = 0.9
            }
            
            // Shimmer animation
            withAnimation(.linear(duration: 3.0).repeatForever(autoreverses: false)) {
                shimmerOffset = 400
            }
        }
    }
}

