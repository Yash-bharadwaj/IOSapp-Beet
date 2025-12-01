import SwiftUI

// Custom Ticket Shape with Cut-outs on left and right edges
struct TicketShape: Shape {
    var cornerRadius: CGFloat = 20
    var cutoutRadius: CGFloat = 12
    var cutoutSpacing: CGFloat = 16
    
    func path(in rect: CGRect) -> Path {
        var path = Path()
        
        let width = rect.width
        let height = rect.height
        
        // Start from top left corner
        path.move(to: CGPoint(x: cornerRadius, y: 0))
        
        // Top edge
        path.addLine(to: CGPoint(x: width - cornerRadius, y: 0))
        
        // Top right corner
        path.addQuadCurve(
            to: CGPoint(x: width, y: cornerRadius),
            control: CGPoint(x: width, y: 0)
        )
        
        // Right edge with cut-outs
        var currentY: CGFloat = cornerRadius + cutoutSpacing
        while currentY < height - cornerRadius - cutoutRadius {
            // Draw line segment before cut-out
            let cutoutStart = currentY - cutoutSpacing
            if cutoutStart > cornerRadius {
                path.addLine(to: CGPoint(x: width, y: cutoutStart))
            }
            
            // Cut-out (semi-circle going inward from right edge)
            path.addArc(
                center: CGPoint(x: width - cutoutRadius, y: currentY),
                radius: cutoutRadius,
                startAngle: .degrees(270),
                endAngle: .degrees(90),
                clockwise: false
            )
            
            currentY += cutoutSpacing + cutoutRadius * 2
        }
        
        // Complete right edge to bottom
        path.addLine(to: CGPoint(x: width, y: height - cornerRadius))
        
        // Bottom right corner
        path.addQuadCurve(
            to: CGPoint(x: width - cornerRadius, y: height),
            control: CGPoint(x: width, y: height)
        )
        
        // Bottom edge
        path.addLine(to: CGPoint(x: cornerRadius, y: height))
        
        // Bottom left corner
        path.addQuadCurve(
            to: CGPoint(x: 0, y: height - cornerRadius),
            control: CGPoint(x: 0, y: height)
        )
        
        // Left edge with cut-outs
        currentY = height - cornerRadius - cutoutSpacing
        while currentY > cornerRadius + cutoutRadius {
            // Draw line segment before cut-out
            let cutoutStart = currentY + cutoutSpacing
            if cutoutStart < height - cornerRadius {
                path.addLine(to: CGPoint(x: 0, y: cutoutStart))
            }
            
            // Cut-out (semi-circle going inward from left edge)
            path.addArc(
                center: CGPoint(x: cutoutRadius, y: currentY),
                radius: cutoutRadius,
                startAngle: .degrees(90),
                endAngle: .degrees(270),
                clockwise: false
            )
            
            currentY -= cutoutSpacing + cutoutRadius * 2
        }
        
        // Complete left edge to top
        path.addLine(to: CGPoint(x: 0, y: cornerRadius))
        
        // Top left corner
        path.addQuadCurve(
            to: CGPoint(x: cornerRadius, y: 0),
            control: CGPoint(x: 0, y: 0)
        )
        
        path.closeSubpath()
        return path
    }
}

struct TicketRotationAnimationView: View {
    let booking: Booking
    @State private var rotationAngle: Double = 0
    @State private var shimmerOffset: CGFloat = -200
    @State private var scale: CGFloat = 0.8
    
    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()
            
            // Rotating Ticket with Shimmer
            TicketRotationCard(booking: booking)
                .scaleEffect(scale)
                .rotation3DEffect(
                    .degrees(rotationAngle),
                    axis: (x: 0, y: 1, z: 0)
                )
                .overlay(
                    // Shimmer Effect
                    LinearGradient(
                        colors: [
                            Color.clear,
                            Color.white.opacity(0.6),
                            Color.clear
                        ],
                        startPoint: .leading,
                        endPoint: .trailing
                    )
                    .frame(width: 100)
                    .offset(x: shimmerOffset)
                    .blur(radius: 20)
                    .clipShape(TicketShape(cornerRadius: 20, cutoutRadius: 12, cutoutSpacing: 8))
                )
                .shadow(color: .ticketRed.opacity(0.5), radius: 30, x: 0, y: 15)
        }
        .onAppear {
            // Start rotation animation
            withAnimation(.linear(duration: 2.0).repeatForever(autoreverses: false)) {
                rotationAngle = 360
            }
            
            // Start shimmer animation
            withAnimation(.linear(duration: 1.5).repeatForever(autoreverses: false)) {
                shimmerOffset = 400
            }
            
            // Scale animation
            withAnimation(.spring(response: 0.6, dampingFraction: 0.7)) {
                scale = 1.0
            }
        }
    }
}

struct TicketRotationCard: View {
    let booking: Booking
    
    var body: some View {
        VStack(spacing: 0) {
            // Red Header Section (matching image1)
            ZStack {
                Color.ticketRed
                
                VStack(spacing: 12) {
                    Text(booking.movie.title.uppercased())
                        .font(.system(size: 28, weight: .bold))
                        .foregroundColor(.white)
                        .tracking(2)
                        .multilineTextAlignment(.center)
                    
                    // Character silhouette placeholder
                    ZStack {
                        // Background gradient (orange sunset)
                        LinearGradient(
                            colors: [
                                Color(hex: "FF6B35"),
                                Color(hex: "FF8C42"),
                                Color(hex: "FFA07A")
                            ],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                        .frame(width: 120, height: 150)
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                        
                        // Character silhouette
                        VStack(spacing: 0) {
                            // Head
                            Circle()
                                .fill(Color.black)
                                .frame(width: 50, height: 50)
                            
                            // Body (suit)
                            RoundedRectangle(cornerRadius: 8)
                                .fill(Color.black)
                                .frame(width: 80, height: 100)
                                .overlay(
                                    // White shirt
                                    VStack {
                                        RoundedRectangle(cornerRadius: 4)
                                            .fill(Color.white)
                                            .frame(width: 60, height: 60)
                                            .offset(y: 10)
                                        
                                        Spacer()
                                    }
                                )
                                .overlay(
                                    // Orange tie
                                    RoundedRectangle(cornerRadius: 2)
                                        .fill(Color(hex: "FF6B35"))
                                        .frame(width: 12, height: 50)
                                        .offset(y: 15)
                                )
                                .overlay(
                                    // Orange sunglasses
                                    HStack(spacing: 20) {
                                        Circle()
                                            .fill(Color(hex: "FF6B35"))
                                            .frame(width: 20, height: 20)
                                        
                                        Circle()
                                            .fill(Color(hex: "FF6B35"))
                                            .frame(width: 20, height: 20)
                                    }
                                    .offset(y: -25)
                                )
                        }
                    }
                    .padding(.top, 8)
                }
                .padding(24)
            }
            .frame(height: 280)
            
            // Barcode Section
            VStack(spacing: 8) {
                // Perforation line
                HStack(spacing: 4) {
                    ForEach(0..<20) { _ in
                        Circle()
                            .fill(Color.gray600.opacity(0.3))
                            .frame(width: 2, height: 2)
                    }
                }
                .padding(.vertical, 8)
                
                // Barcode
                HStack(spacing: 2) {
                    ForEach(0..<40) { index in
                        RoundedRectangle(cornerRadius: 1)
                            .fill(Color.white)
                            .frame(width: barcodeWidth(for: index), height: 40)
                    }
                }
                .padding(.horizontal, 20)
                .padding(.bottom, 12)
            }
            .frame(height: 80)
            .background(Color.black)
        }
        .frame(width: 320, height: 360)
        .clipShape(TicketShape(cornerRadius: 20, cutoutRadius: 12, cutoutSpacing: 8))
        .shadow(color: .black.opacity(0.3), radius: 20, x: 0, y: 10)
    }
    
    private func barcodeWidth(for index: Int) -> CGFloat {
        // Deterministic barcode pattern based on index
        let pattern = [2, 3, 2, 4, 2, 3, 3, 2, 4, 2, 3, 2, 4, 3, 2, 3, 2, 4, 2, 3, 3, 2, 4, 2, 3, 2, 4, 3, 2, 3, 2, 4, 2, 3, 3, 2, 4, 2, 3, 2]
        return CGFloat(pattern[index % pattern.count])
    }
}

