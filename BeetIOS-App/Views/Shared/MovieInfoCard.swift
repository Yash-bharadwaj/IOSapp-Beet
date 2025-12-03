import SwiftUI
import UIKit

struct MovieInfoCard: View {
    let movie: Movie
    
    var body: some View {
        HStack(spacing: 16) {
            // Movie Poster Thumbnail
            Group {
                if let uiImage = UIImage(named: movie.posterImage) {
                    Image(uiImage: uiImage)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 80, height: 120)
                        .clipShape(RoundedRectangle(cornerRadius: 16))
                        .shadow(color: .black.opacity(0.3), radius: 8, x: 0, y: 4)
                } else {
                    RoundedRectangle(cornerRadius: 16)
                        .fill(
                            LinearGradient(
                                colors: [Color.ticketRed, Color.ticketRed.opacity(0.7)],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .frame(width: 80, height: 120)
                        .overlay(
                            Image(systemName: "film.fill")
                                .font(.system(size: 30))
                                .foregroundColor(.white.opacity(0.8))
                        )
                        .shadow(color: .ticketRed.opacity(0.3), radius: 8, x: 0, y: 4)
                }
            }
            
            VStack(alignment: .leading, spacing: 8) {
                // Movie Title
                Text(movie.title)
                    .font(.system(size: 24, weight: .bold))
                    .foregroundColor(.white)
                    .lineLimit(2)
                
                // Movie Details
                HStack(spacing: 4) {
                    if let year = movie.year {
                        Text("\(year)")
                            .font(.system(size: 14, weight: .medium))
                            .foregroundColor(.gray600)
                        Text("·")
                            .font(.system(size: 14))
                            .foregroundColor(.gray600)
                    }
                    Text(movie.genre)
                        .font(.system(size: 14, weight: .medium))
                        .foregroundColor(.gray600)
                    Text("·")
                        .font(.system(size: 14))
                        .foregroundColor(.gray600)
                    Text(movie.duration)
                        .font(.system(size: 14, weight: .medium))
                        .foregroundColor(.gray600)
                }
                
                // IMDb Rating Badge
                HStack(spacing: 6) {
                    Text("IMDb")
                        .font(.system(size: 12, weight: .bold))
                        .foregroundColor(.black)
                        .padding(.horizontal, 6)
                        .padding(.vertical, 3)
                        .background(Color.buttonYellow)
                        .cornerRadius(4)
                    
                    Text(String(format: "%.1f", movie.rating))
                        .font(.system(size: 15, weight: .semibold))
                        .foregroundColor(.white)
                }
            }
            
            Spacer()
        }
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(Color.white.opacity(0.05))
                .overlay(
                    RoundedRectangle(cornerRadius: 20)
                        .stroke(Color.white.opacity(0.1), lineWidth: 1)
                )
        )
    }
}

