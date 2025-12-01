import SwiftUI

struct LegendsView: View {
    var body: some View {
        HStack(spacing: 24) {
            legendItem(color: .white.opacity(0.2), text: "Occupied")
            legendItem(color: .clear, text: "Available", hasBorder: true)
            legendItem(color: .seatYellow, text: "Selected") // Yellow for selected seats
        }
    }
    
    private func legendItem(color: Color, text: String, hasBorder: Bool = false) -> some View {
        HStack(spacing: 10) {
            RoundedRectangle(cornerRadius: 4)
                .fill(color)
                .frame(width: 16, height: 16)
                .overlay(
                    RoundedRectangle(cornerRadius: 4)
                        .stroke(Color.white.opacity(0.3), lineWidth: hasBorder ? 1 : 0)
                )
            
            Text(text)
                .font(.system(size: 13, weight: .medium))
                .foregroundColor(.gray600)
        }
    }
}

