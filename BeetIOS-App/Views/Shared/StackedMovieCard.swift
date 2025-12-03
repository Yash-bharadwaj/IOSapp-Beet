import SwiftUI

/// Individual card component for the stacked carousel.
/// Displays movie information with dynamic gradients.
struct StackedMovieCard: View {
    let movie: Movie
    let position: Int
    let cardWidth: CGFloat
    let cardHeight: CGFloat
    
    var body: some View {
        ZStack {
            // Background gradient based on movie
            LinearGradient(
                colors: gradientColors(for: movie),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            
            VStack(spacing: 0) {
                Spacer()
                
                // Movie Poster Placeholder
                ZStack {
                    RoundedRectangle(cornerRadius: 16)
                        .fill(Color.white.opacity(0.1))
                        .frame(width: cardWidth * 0.65, height: cardHeight * 0.45)
                        .overlay(
                            Image(systemName: "film.fill")
                                .font(.system(size: 50))
                                .foregroundColor(.white.opacity(0.3))
                        )
                }
                .shadow(color: .black.opacity(0.3), radius: 15, x: 0, y: 8)
                
                Spacer()
                
                // Movie Info
                VStack(spacing: 6) {
                    // Tagline
                    if let tagline = movie.tagline {
                        Text(tagline)
                            .font(.premiumSmall(size: 10, weight: .medium))
                            .foregroundColor(.white.opacity(0.9))
                            .premiumTracking(1.2)
                            .lineLimit(1)
                    }
                    
                    // Title
                    Text(movie.title)
                        .font(.premiumTitle(size: 24, weight: .bold))
                        .foregroundColor(.white)
                        .multilineTextAlignment(.center)
                        .lineLimit(2)
                        .padding(.horizontal, 12)
                    
                    // Details
                    HStack(spacing: 4) {
                        if let year = movie.year {
                            Text("\(year)")
                        }
                        Text("·")
                        Text(movie.genre)
                        Text("·")
                        Text(movie.duration)
                    }
                    .font(.premiumCaption(size: 12, weight: .regular))
                    .foregroundColor(.white.opacity(0.8))
                    .lineLimit(1)
                    
                    // Rating
                    HStack(spacing: 6) {
                        Image(systemName: "star.fill")
                            .font(.system(size: 11))
                            .foregroundColor(.yellow)
                        Text(String(format: "%.1f", movie.rating))
                            .font(.premiumCaption(size: 13, weight: .semibold))
                            .foregroundColor(.white)
                        
                        if movie.isIMAX {
                            Text("IMAX")
                                .font(.premiumSmall(size: 9, weight: .bold))
                                .foregroundColor(.black)
                                .padding(.horizontal, 5)
                                .padding(.vertical, 2)
                                .background(Color.white)
                                .cornerRadius(3)
                        }
                    }
                }
                .padding(.bottom, 20)
            }
        }
        .frame(width: cardWidth, height: cardHeight)
        .clipShape(RoundedRectangle(cornerRadius: 20))
        .overlay(
            RoundedRectangle(cornerRadius: 20)
                .stroke(
                    LinearGradient(
                        colors: [
                            Color.white.opacity(position == 0 ? 0.3 : 0.1),
                            Color.white.opacity(0)
                        ],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    ),
                    lineWidth: position == 0 ? 2 : 1
                )
        )
        .shadow(
            color: .black.opacity(position == 0 ? 0.5 : 0.2),
            radius: position == 0 ? 25 : 10,
            x: 0,
            y: position == 0 ? 12 : 5
        )
    }
    
    private func gradientColors(for movie: Movie) -> [Color] {
        switch movie.title {
        case "the BAD GUYS":
            return [Color(hex: "8B0000"), Color(hex: "FF4500"), Color(hex: "FF6B35")]
        case "Dune: Part Two":
            return [Color(hex: "1A1A2E"), Color(hex: "16213E"), Color(hex: "0F3460")]
        case "Oppenheimer":
            return [Color(hex: "2C1810"), Color(hex: "4A2C2A"), Color(hex: "6B4423")]
        case "Barbie":
            return [Color(hex: "FF69B4"), Color(hex: "FFB6C1"), Color(hex: "FFC0CB")]
        case "Spider-Man: Across the Spider-Verse":
            return [Color(hex: "1E3A8A"), Color(hex: "3B82F6"), Color(hex: "60A5FA")]
        case "Top Gun: Maverick":
            return [Color(hex: "0A1929"), Color(hex: "1E3A8A"), Color(hex: "3B82F6")]
        default:
            return [Color(hex: "1A1A1A"), Color(hex: "2D2D2D"), Color(hex: "404040")]
        }
    }
}

