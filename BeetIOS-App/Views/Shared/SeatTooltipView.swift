import SwiftUI

struct SeatTooltipView: View {
    let row: String
    let seatCount: Int
    let totalCount: Int
    let position: CGPoint
    
    @State private var appear = false
    
    var body: some View {
        HStack(spacing: 8) {
            // Compact badge with count
            HStack(spacing: 6) {
                Text("🎫")
                    .font(.system(size: 12))
                
                HStack(spacing: 3) {
                    Text("\(seatCount)")
                        .font(.system(size: 13, weight: .bold))
                        .foregroundColor(.white)
                    
                    Text("/")
                        .font(.system(size: 11, weight: .medium))
                        .foregroundColor(.gray600)
                    
                    Text("\(totalCount)")
                        .font(.system(size: 11, weight: .medium))
                        .foregroundColor(.gray600)
                }
            }
            
            Text("Row \(row)")
                .font(.system(size: 12, weight: .semibold))
                .foregroundColor(.white)
            
            // Price
            if seatCount == totalCount {
                Text("•")
                    .font(.system(size: 10))
                    .foregroundColor(.gray600)
                
                Text("$\(String(format: "%.0f", Double(seatCount) * 15.0))")
                    .font(.system(size: 12, weight: .bold))
                    .foregroundColor(.buttonYellow)
            }
        }
        .padding(.horizontal, 10)
        .padding(.vertical, 6)
        .background(
            Capsule()
                .fill(Color.white.opacity(0.12))
                .overlay(
                    Capsule()
                        .stroke(
                            seatCount == totalCount ? Color.successGreen.opacity(0.4) : Color.white.opacity(0.2),
                            lineWidth: 1
                        )
                )
                .shadow(color: .black.opacity(0.3), radius: 8, x: 0, y: 4)
        )
        .position(x: position.x, y: position.y)
        .opacity(appear ? 1 : 0)
        .scaleEffect(appear ? 1 : 0.9)
        .animation(.spring(response: 0.3, dampingFraction: 0.7), value: appear)
        .onAppear {
            appear = true
        }
    }
}

