import SwiftUI

struct TicketQuantitySelector: View {
    @Binding var count: Int
    let minCount: Int
    let maxCount: Int
    let onDecrease: () -> Void
    let onIncrease: () -> Void
    
    @State private var decreasePressed = false
    @State private var increasePressed = false
    
    var body: some View {
        HStack(spacing: 32) {
            // Decrease Button
            Button(action: {
                guard count > minCount else { return }
                haptic(.light)
                withAnimation(.spring(response: 0.2, dampingFraction: 0.6)) {
                    decreasePressed = true
                }
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                    withAnimation(.spring(response: 0.2, dampingFraction: 0.6)) {
                        decreasePressed = false
                    }
                }
                onDecrease()
            }) {
                Image(systemName: "minus")
                    .font(.system(size: 20, weight: .semibold))
                    .foregroundColor(.white)
                    .frame(width: 44, height: 44)
                    .background(
                        Circle()
                            .fill(Color.gray600.opacity(0.3))
                            .overlay(
                                Circle()
                                    .stroke(Color.white.opacity(0.2), lineWidth: 1)
                            )
                    )
            }
            .disabled(count <= minCount)
            .opacity(count <= minCount ? 0.5 : 1.0)
            .scaleEffect(decreasePressed ? 0.9 : 1.0)
            .accessibilityLabel("Decrease ticket count")
            .accessibilityHint(count <= minCount ? "Minimum \(minCount) ticket" : "Current count: \(count)")
            
            // Count Display
            Text("\(count)")
                .font(.system(size: 48, weight: .bold))
                .foregroundColor(.white)
                .frame(minWidth: 60)
                .contentTransition(.numericText())
                .animation(.spring(response: 0.3, dampingFraction: 0.7), value: count)
                .accessibilityLabel("\(count) ticket\(count == 1 ? "" : "s")")
            
            // Increase Button
            Button(action: {
                guard count < maxCount else { return }
                haptic(.light)
                withAnimation(.spring(response: 0.2, dampingFraction: 0.6)) {
                    increasePressed = true
                }
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                    withAnimation(.spring(response: 0.2, dampingFraction: 0.6)) {
                        increasePressed = false
                    }
                }
                onIncrease()
            }) {
                Image(systemName: "plus")
                    .font(.system(size: 20, weight: .semibold))
                    .foregroundColor(.white)
                    .frame(width: 44, height: 44)
                    .background(
                        Circle()
                            .fill(Color.gray600.opacity(0.3))
                            .overlay(
                                Circle()
                                    .stroke(Color.white.opacity(0.2), lineWidth: 1)
                            )
                    )
            }
            .disabled(count >= maxCount)
            .opacity(count >= maxCount ? 0.5 : 1.0)
            .scaleEffect(increasePressed ? 0.9 : 1.0)
            .accessibilityLabel("Increase ticket count")
            .accessibilityHint(count >= maxCount ? "Maximum \(maxCount) tickets" : "Current count: \(count)")
        }
    }
}

