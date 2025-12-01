import SwiftUI

struct SeatGrid: View {
    let seats: [Seat]
    let selectedSeats: Set<Seat>
    let onSeatTap: (Seat) -> Void
    
    // Flexible spacing constants
    private let horizontalPadding: CGFloat = 24
    private let rowLabelWidth: CGFloat = 28
    private let rowLabelSpacing: CGFloat = 16
    private let seatSpacing: CGFloat = 8
    private let rowSpacing: CGFloat = 10
    
    var rows: [String] {
        Array(Set(seats.map { $0.row })).sorted()
    }
    
    // Calculate seats per row dynamically
    private var seatsPerRow: Int {
        guard let firstRow = rows.first else { return 8 }
        return seats.filter { $0.row == firstRow }.count
    }
    
    var body: some View {
        GeometryReader { geometry in
            let availableWidth = geometry.size.width - horizontalPadding * 2 - rowLabelWidth - rowLabelSpacing
            let seatSize = calculateSeatSize(
                availableWidth: availableWidth,
                seatsPerRow: seatsPerRow,
                spacing: seatSpacing
            )
            
            HStack(alignment: .top, spacing: rowLabelSpacing) {
                // Row Labels
                VStack(alignment: .trailing, spacing: rowSpacing) {
                    ForEach(rows, id: \.self) { row in
                        Text(row)
                            .font(.system(size: 13, weight: .semibold))
                            .foregroundColor(.gray600)
                            .frame(height: seatSize)
                    }
                }
                .frame(width: rowLabelWidth)
                
                // Flexible Seat Grid using LazyVGrid
                let columns = Array(repeating: GridItem(.flexible(minimum: seatSize * 0.8, maximum: seatSize * 1.2), spacing: seatSpacing), count: seatsPerRow)
                
                LazyVGrid(columns: columns, alignment: .leading, spacing: rowSpacing) {
                    ForEach(rows, id: \.self) { row in
                        ForEach(seats.filter { $0.row == row }.sorted(by: { $0.number < $1.number }), id: \.id) { seat in
                            SeatView(
                                seat: seat,
                                isSelected: selectedSeats.contains(seat),
                                action: { onSeatTap(seat) }
                            )
                            .frame(width: seatSize, height: seatSize)
                            .aspectRatio(1, contentMode: .fit)
                        }
                    }
                }
                .frame(maxWidth: .infinity, alignment: .leading)
            }
            .padding(.horizontal, horizontalPadding)
        }
        .frame(minHeight: calculateMinGridHeight())
    }
    
    private func calculateMinGridHeight() -> CGFloat {
        // Estimate minimum height based on typical seat size
        let estimatedSeatSize: CGFloat = 24
        let rowHeight = estimatedSeatSize + rowSpacing
        return CGFloat(rows.count) * rowHeight + 20 // Add padding
    }
    
    private func calculateSeatSize(availableWidth: CGFloat, seatsPerRow: Int, spacing: CGFloat) -> CGFloat {
        let totalSpacing = CGFloat(seatsPerRow - 1) * spacing
        let seatSize = (availableWidth - totalSpacing) / CGFloat(seatsPerRow)
        // Ensure minimum and maximum sizes for readability
        return max(20, min(28, seatSize))
    }
}

