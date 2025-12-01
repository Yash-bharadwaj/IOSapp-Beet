import SwiftUI

struct EmojiAvatar: View {
    let emoji: String
    let index: Int
    let isVisible: Bool
    
    @State private var scale: CGFloat = 0
    @State private var rotation: Double = 0
    @State private var opacity: Double = 0
    
    // Different emoji styles matching the reference
    static let emojiStyles: [String] = [
        "😊", // Happy face
        "😎", // Cool face with sunglasses
        "🤓", // Nerd face with glasses
        "😄", // Grinning face
        "😃", // Grinning face with big eyes
        "😁", // Beaming face
        "🥳", // Party face
        "😋", // Face savoring food
        "🤗", // Hugging face
        "😌"  // Relieved face
    ]
    
    var body: some View {
        Text(emoji)
            .font(.system(size: 50))
            .frame(width: 80, height: 80)
            .background(
                Circle()
                    .fill(backgroundColor)
                    .shadow(color: shadowColor, radius: 12, x: 0, y: 6)
            )
            .scaleEffect(scale)
            .rotationEffect(.degrees(rotation))
            .opacity(opacity)
            .onChange(of: isVisible) { _, newValue in
                if newValue {
                    appear()
                } else {
                    disappear()
                }
            }
            .onAppear {
                if isVisible {
                    appear()
                }
            }
    }
    
    private var backgroundColor: Color {
        let colors: [Color] = [
            Color(hex: "87CEEB"), // Light blue
            Color(hex: "FFD700"), // Yellow
            Color(hex: "FFA500"), // Orange
            Color(hex: "98D8C8"), // Mint green
            Color(hex: "F0A3FF"), // Light purple
            Color(hex: "FFB6C1"), // Light pink
            Color(hex: "B0E0E6"), // Powder blue
            Color(hex: "FFE4B5"), // Moccasin
            Color(hex: "DDA0DD"), // Plum
            Color(hex: "F5DEB3")  // Wheat
        ]
        return colors[index % colors.count]
    }
    
    private var shadowColor: Color {
        backgroundColor.opacity(0.4)
    }
    
    private func appear() {
        withAnimation(.spring(response: 0.5, dampingFraction: 0.6).delay(Double(index) * 0.1)) {
            scale = 1.0
            opacity = 1.0
            rotation = 0
        }
        
        // Bounce effect
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            withAnimation(.spring(response: 0.3, dampingFraction: 0.5)) {
                scale = 1.1
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                withAnimation(.spring(response: 0.3, dampingFraction: 0.5)) {
                    scale = 1.0
                }
            }
        }
    }
    
    private func disappear() {
        withAnimation(.spring(response: 0.4, dampingFraction: 0.7)) {
            scale = 0
            opacity = 0
            rotation = 180
        }
    }
}

