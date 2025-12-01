import SwiftUI

struct SeatSelectionBadge: View {
    let selectedCount: Int
    let totalCount: Int
    
    var body: some View {
        HStack(spacing: 8) {
            // Small emoji indicator
            Text("🎫")
                .font(.system(size: 14))
            
            // Count display
            HStack(spacing: 4) {
                Text("\(selectedCount)")
                    .font(.system(size: 15, weight: .bold))
                    .foregroundColor(.white)
                
                Text("/")
                    .font(.system(size: 13, weight: .medium))
                    .foregroundColor(.gray600)
                
                Text("\(totalCount)")
                    .font(.system(size: 13, weight: .medium))
                    .foregroundColor(.gray600)
            }
            
            // Status text
            Text(selectedCount == totalCount ? "Selected" : "Selecting")
                .font(.system(size: 12, weight: .medium))
                .foregroundColor(selectedCount == totalCount ? .successGreen : .gray600)
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 8)
        .background(
            Capsule()
                .fill(Color.white.opacity(0.08))
                .overlay(
                    Capsule()
                        .stroke(
                            selectedCount == totalCount ? Color.successGreen.opacity(0.3) : Color.white.opacity(0.15),
                            lineWidth: 1
                        )
                )
        )
    }
}

