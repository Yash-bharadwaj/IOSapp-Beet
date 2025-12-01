import SwiftUI

struct CinemaScreenView: View {
    let movie: Movie
    
    var body: some View {
        VStack(spacing: 0) {
            // Movie Screen with Image
            ZStack {
                // Placeholder for movie still
                CurvedScreenShape()
                    .fill(
                        LinearGradient(
                            colors: [
                                Color.gray.opacity(0.4),
                                Color.black.opacity(0.7),
                                Color.black.opacity(0.9)
                            ],
                            startPoint: .top,
                            endPoint: .bottom
                        )
                    )
                    .frame(height: 140)
                    .overlay(
                        Image(systemName: "movieclapper.fill")
                            .font(.system(size: 50))
                            .foregroundColor(.white.opacity(0.2))
                    )
                    .overlay(
                        // Screen glow effect
                        CurvedScreenShape()
                            .stroke(
                                LinearGradient(
                                    colors: [
                                        Color.primaryPurple.opacity(0.3),
                                        Color.primaryPurple.opacity(0),
                                        Color.primaryPurple.opacity(0.3)
                                    ],
                                    startPoint: .leading,
                                    endPoint: .trailing
                                ),
                                lineWidth: 2
                            )
                            .frame(height: 140)
                    )
                    .shadow(color: .primaryPurple.opacity(0.2), radius: 15, x: 0, y: 5)
            }
            .padding(.horizontal, 24)
            
            Text("SCREEN")
                .font(.system(size: 11, weight: .bold))
                .foregroundColor(.gray600)
                .tracking(3)
                .padding(.top, 12)
        }
    }
}

struct CurvedScreenShape: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        let width = rect.width
        let height = rect.height
        
        // Start from bottom left
        path.move(to: CGPoint(x: 0, y: height))
        
        // Bottom edge
        path.addLine(to: CGPoint(x: width, y: height))
        
        // Top curved edge
        path.addQuadCurve(
            to: CGPoint(x: 0, y: height),
            control: CGPoint(x: width / 2, y: -25)
        )
        
        path.closeSubpath()
        return path
    }
}

