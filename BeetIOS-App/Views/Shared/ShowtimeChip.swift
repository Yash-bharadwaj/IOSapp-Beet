import SwiftUI

struct ShowtimeChip: View {
    let time: String
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(time)
                .font(.system(size: 15, weight: .medium))
                .foregroundColor(isSelected ? .white : .gray600)
                .padding(.horizontal, 20)
                .padding(.vertical, 12)
                .background(
                    RoundedRectangle(cornerRadius: 20)
                        .fill(isSelected ? Color.buttonYellow : Color.white.opacity(0.1))
                )
                .overlay(
                    RoundedRectangle(cornerRadius: 20)
                        .stroke(isSelected ? Color.clear : Color.gray600.opacity(0.3), lineWidth: 1)
                )
        }
        .accessibilityLabel("Select showtime \(time)")
        .accessibilityAddTraits(.isButton)
        .scaleEffect(isSelected ? 1.05 : 1.0)
        .animation(.spring(response: 0.3, dampingFraction: 0.7), value: isSelected)
    }
}

