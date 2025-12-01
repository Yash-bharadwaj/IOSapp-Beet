import SwiftUI
import UIKit

struct SeatView: View {
    let seat: Seat
    let isSelected: Bool
    let action: () -> Void
    
    @State private var isPressed = false
    
    var body: some View {
        Button(action: {
            withAnimation(.spring(response: 0.25, dampingFraction: 0.6)) {
                isPressed = true
            }
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                withAnimation(.spring(response: 0.25, dampingFraction: 0.6)) {
                    isPressed = false
                }
            }
            
            action()
            
            // Haptic feedback
            let generator = UIImpactFeedbackGenerator(style: .light)
            generator.impactOccurred()
        }) {
            GeometryReader { geometry in
                let size = min(geometry.size.width, geometry.size.height)
                let cornerRadius = size * 0.15 // Proportional corner radius
                
                ZStack {
                    // Square/rounded rectangle shape for seats - flexible sizing
                    RoundedRectangle(cornerRadius: cornerRadius)
                        .fill(backgroundColor)
                        .overlay(
                            RoundedRectangle(cornerRadius: cornerRadius)
                                .stroke(borderColor, lineWidth: borderWidth)
                        )
                        .shadow(
                            color: isSelected ? Color.seatYellow.opacity(0.5) : Color.clear,
                            radius: isSelected ? size * 0.25 : 0,
                            x: 0,
                            y: isSelected ? size * 0.08 : 0
                        )
                    
                    // Glow effect for selected seats
                    if isSelected {
                        RoundedRectangle(cornerRadius: cornerRadius)
                            .fill(
                                LinearGradient(
                                    colors: [
                                        Color.seatYellow.opacity(0.7),
                                        Color.seatGold.opacity(0.5)
                                    ],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                            )
                            .blur(radius: size * 0.12)
                            .opacity(0.6)
                    }
                }
                .frame(width: size, height: size)
            }
            .aspectRatio(1, contentMode: .fit)
        }
        .disabled(seat.status == .occupied)
        .accessibilityLabel("Seat \(seat.displayName), \(seat.status == .occupied ? "occupied" : seat.status == .selected ? "selected" : "available")")
        .accessibilityAddTraits(.isButton)
        .scaleEffect(isSelected ? 1.15 : (isPressed ? 0.9 : 1.0))
        .animation(.spring(response: 0.3, dampingFraction: 0.7), value: isSelected)
        .animation(.spring(response: 0.2, dampingFraction: 0.5), value: isPressed)
    }
    
    var backgroundColor: Color {
        switch seat.status {
        case .available:
            return isSelected ? Color.seatYellow : Color.clear // Hollow for available
        case .occupied:
            return Color.white.opacity(0.25) // Filled lighter grey for occupied
        case .selected:
            return Color.seatYellow // Filled bright yellow for selected
        }
    }
    
    var borderColor: Color {
        switch seat.status {
        case .available:
            return isSelected ? Color.seatGold : Color.white.opacity(0.4) // Light border for available (hollow)
        case .occupied:
            return Color.clear // No border for occupied
        case .selected:
            return Color.seatGold // Gold border for selected
        }
    }
    
    var borderWidth: CGFloat {
        switch seat.status {
        case .available:
            return 1.0 // Consistent border width for hollow seats
        case .occupied:
            return 0
        case .selected:
            return 1.5
        }
    }
}

