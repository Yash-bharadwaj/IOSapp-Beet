import SwiftUI
import UIKit

/// Individual card component for the stacked carousel.
/// Displays movie information with dynamic gradients.
struct StackedMovieCard: View {
    let movie: Movie
    let position: Int
    let cardWidth: CGFloat
    let cardHeight: CGFloat
    
    var body: some View {
        ZStack {
            // Full movie poster image as background
            Group {
                if let uiImage = UIImage(named: movie.posterImage) {
                    Image(uiImage: uiImage)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: cardWidth, height: cardHeight)
                } else {
                    // Fallback gradient if image not found
                    LinearGradient(
                        colors: gradientColors(for: movie),
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                }
            }
            
            // Gradient overlay at bottom for text readability
            VStack {
                Spacer()
                LinearGradient(
                    colors: [
                        Color.clear,
                        Color.black.opacity(0.3),
                        Color.black.opacity(0.7),
                        Color.black.opacity(0.85)
                    ],
                    startPoint: .top,
                    endPoint: .bottom
                )
                .frame(height: cardHeight * 0.5)
            }
            
            // Movie Info at bottom
            VStack {
                Spacer()
                VStack(spacing: 8) {
                    // Tagline
                    if let tagline = movie.tagline {
                        Text(tagline)
                            .font(.premiumSmall(size: 11, weight: .medium))
                            .foregroundColor(.white.opacity(0.95))
                            .premiumTracking(1.5)
                            .lineLimit(1)
                    }
                    
                    // Title
                    Text(movie.title)
                        .font(.premiumTitle(size: 26, weight: .bold))
                        .foregroundColor(.white)
                        .multilineTextAlignment(.center)
                        .lineLimit(2)
                        .padding(.horizontal, 16)
                        .shadow(color: .black.opacity(0.5), radius: 4, x: 0, y: 2)
                    
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
                    .font(.premiumCaption(size: 13, weight: .regular))
                    .foregroundColor(.white.opacity(0.9))
                    .lineLimit(1)
                    
                    // Rating
                    HStack(spacing: 8) {
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
                                .padding(.vertical, 3)
                                .background(Color.white)
                                .cornerRadius(4)
                        }
                    }
                }
                .padding(.bottom, 24)
                .padding(.horizontal, 12)
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

