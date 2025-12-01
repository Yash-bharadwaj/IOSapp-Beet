import SwiftUI

struct SeatTooltipBadge: View {
    let row: String
    let seatCount: Int
    let totalCount: Int
    let totalPrice: Double
    let selectedSeats: [Seat]
    
    @State private var appear = false
    
    var body: some View {
        HStack(spacing: 6) {
            // Compact count display
            Text("\(seatCount)/\(totalCount)")
                .font(.system(size: 11, weight: .bold))
                .foregroundColor(.white)
            
            // Row info
            Text("Row \(row)")
                .font(.system(size: 11, weight: .medium))
                .foregroundColor(.white.opacity(0.9))
        }
        .padding(.horizontal, 10)
        .padding(.vertical, 5)
        .background(
            Capsule()
                .fill(Color.black.opacity(0.85))
                .overlay(
                    Capsule()
                        .stroke(Color.white.opacity(0.2), lineWidth: 1)
                )
                .shadow(color: .black.opacity(0.3), radius: 6, x: 0, y: 2)
        )
        .opacity(appear ? 1 : 0)
        .scaleEffect(appear ? 1 : 0.9)
        .animation(.spring(response: 0.3, dampingFraction: 0.7), value: appear)
        .onAppear {
            appear = true
        }
    }
}

