import SwiftUI

/// Individual movie card component for the carousel.
/// Displays movie information with dynamic gradients and animations based on selection state.
struct MovieCarouselCard: View {
    let movie: Movie
    let isSelected: Bool
    let geometry: GeometryProxy
    @State private var dragOffset: CGFloat = 0
    
    private var cardWidth: CGFloat {
        geometry.size.width * 0.75
    }
    
    private var cardHeight: CGFloat {
        cardWidth * 1.4
    }
    
    private var scale: CGFloat {
        isSelected ? 1.0 : 0.85
    }
    
    private var opacity: Double {
        isSelected ? 1.0 : 0.6
    }
    
    var body: some View {
        GeometryReader { cardGeometry in
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
                        RoundedRectangle(cornerRadius: 20)
                            .fill(Color.white.opacity(0.1))
                            .frame(width: cardWidth * 0.7, height: cardHeight * 0.5)
                            .overlay(
                                Image(systemName: "film.fill")
                                    .font(.system(size: 60))
                                    .foregroundColor(.white.opacity(0.3))
                            )
                    }
                    .shadow(color: .black.opacity(0.3), radius: 20, x: 0, y: 10)
                    
                    Spacer()
                    
                    // Movie Info
                    VStack(spacing: 8) {
                        // Tagline
                        if let tagline = movie.tagline {
                            Text(tagline)
                                .font(.premiumSmall(size: 11, weight: .medium))
                                .foregroundColor(.white.opacity(0.9))
                                .premiumTracking(1.5)
                        }
                        
                        // Title
                        Text(movie.title)
                            .font(.premiumTitle(size: 28, weight: .bold))
                            .foregroundColor(.white)
                            .multilineTextAlignment(.center)
                            .lineLimit(2)
                            .padding(.horizontal, 16)
                        
                        // Details
                        HStack(spacing: 6) {
                            if let year = movie.year {
                                Text("\(year)")
                            }
                            Text("·")
                            Text(movie.genre)
                            Text("·")
                            Text(movie.duration)
                        }
                        .font(.premiumCaption(size: 13, weight: .regular))
                        .foregroundColor(.white.opacity(0.8))
                        
                        // Rating
                        HStack(spacing: 6) {
                            Image(systemName: "star.fill")
                                .font(.system(size: 12))
                                .foregroundColor(.yellow)
                            Text(String(format: "%.1f", movie.rating))
                                .font(.premiumCaption(size: 14, weight: .semibold))
                                .foregroundColor(.white)
                            
                            if movie.isIMAX {
                                Text("IMAX")
                                    .font(.premiumSmall(size: 10, weight: .bold))
                                    .foregroundColor(.black)
                                    .padding(.horizontal, 6)
                                    .padding(.vertical, 2)
                                    .background(Color.white)
                                    .cornerRadius(4)
                            }
                        }
                    }
                    .padding(.bottom, 24)
                }
            }
            .frame(width: cardWidth, height: cardHeight)
            .clipShape(RoundedRectangle(cornerRadius: 24))
            .overlay(
                RoundedRectangle(cornerRadius: 24)
                    .stroke(
                        LinearGradient(
                            colors: [
                                Color.white.opacity(isSelected ? 0.3 : 0.1),
                                Color.white.opacity(0)
                            ],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        ),
                        lineWidth: isSelected ? 2 : 1
                    )
            )
            .shadow(
                color: .black.opacity(isSelected ? 0.4 : 0.2),
                radius: isSelected ? 30 : 15,
                x: 0,
                y: isSelected ? 15 : 8
            )
        }
        .scaleEffect(scale)
        .opacity(opacity)
        .animation(.spring(response: 0.5, dampingFraction: 0.8), value: isSelected)
    }
    
    private func gradientColors(for movie: Movie) -> [Color] {
        // Different gradient colors for each movie
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

