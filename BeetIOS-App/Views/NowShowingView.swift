import SwiftUI

struct NowShowingView: View {
    @Environment(Router.self) private var router
    @State private var selectedMovie: Movie = .badGuys
    @State private var appearAnimation = false
    
    var body: some View {
        ZStack {
            // Background
            Color.black
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                // Header with "Now Showing" and profile
                HStack {
                    Spacer()
                    HStack(spacing: 8) {
                        Text("Now Showing")
                            .font(.system(size: 28, weight: .bold))
                            .foregroundColor(.white)
                        Image(systemName: "chevron.down")
                            .font(.system(size: 16, weight: .semibold))
                            .foregroundColor(.white.opacity(0.7))
                    }
                    Spacer()
                    Button(action: {}) {
                        ZStack {
                            Circle()
                                .fill(Color(hex: "4ADE80"))
                                .frame(width: 44, height: 44)
                            Image(systemName: "person.fill")
                                .font(.system(size: 20))
                                .foregroundColor(.white)
                        }
                    }
                    .accessibilityLabel("Profile")
                    .accessibilityHint("View user profile")
                }
                .padding(.horizontal, 24)
                .padding(.top, 8)
                .padding(.bottom, 20)
                .zIndex(1)
                
                // Movie Poster Section - fills remaining space
                GeometryReader { geometry in
                    ZStack {
                        // Background gradient (reddish-orange)
                        LinearGradient(
                            colors: [
                                Color(hex: "8B0000"),
                                Color(hex: "FF4500"),
                                Color(hex: "FF6B35")
                            ],
                            startPoint: .top,
                            endPoint: .bottom
                        )
                        
                        VStack(spacing: 0) {
                            // Tagline at top
                            Text(selectedMovie.tagline ?? "")
                            .font(.system(size: 13, weight: .medium))
                            .foregroundColor(.white)
                            .padding(.top, 20)
                            .opacity(appearAnimation ? 1 : 0)
                            .offset(y: appearAnimation ? 0 : -10)
                            .animation(.spring(response: 0.6, dampingFraction: 0.8).delay(0.1), value: appearAnimation)
                            
                            Spacer()
                            
                            // Movie Poster Placeholder (Wolf character would be here)
                            ZStack {
                                // Placeholder for the wolf character silhouette
                                RoundedRectangle(cornerRadius: 0)
                                    .fill(Color.clear)
                                    .frame(width: 280, height: 380)
                                    .overlay(
                                        Image(systemName: "person.fill")
                                            .font(.system(size: 140))
                                            .foregroundColor(.black.opacity(0.4))
                                    )
                            }
                            .padding(.vertical, 10)
                            .opacity(appearAnimation ? 1 : 0)
                            .scaleEffect(appearAnimation ? 1 : 0.9)
                            .animation(.spring(response: 0.6, dampingFraction: 0.8).delay(0.2), value: appearAnimation)
                            
                            Spacer()
                            
                            // Movie Title
                            VStack(spacing: 4) {
                                Text("the")
                                    .font(.system(size: 22, weight: .bold))
                                    .foregroundColor(.white)
                                Text("BAD GUYS")
                                    .font(.system(size: 44, weight: .bold))
                                    .foregroundColor(.white)
                            }
                            .padding(.bottom, 8)
                            .opacity(appearAnimation ? 1 : 0)
                            .offset(y: appearAnimation ? 0 : 10)
                            .animation(.spring(response: 0.6, dampingFraction: 0.8).delay(0.3), value: appearAnimation)
                            
                            // Movie Details
                            HStack(spacing: 6) {
                                if let year = selectedMovie.year {
                                    Text("\(year)")
                                }
                                Text("·")
                                Text(selectedMovie.genre)
                                Text("·")
                                Text(selectedMovie.duration)
                            }
                            .font(.system(size: 15, weight: .regular))
                            .foregroundColor(.white.opacity(0.9))
                            .padding(.bottom, 10)
                            .opacity(appearAnimation ? 1 : 0)
                            .offset(y: appearAnimation ? 0 : 10)
                            .animation(.spring(response: 0.6, dampingFraction: 0.8).delay(0.4), value: appearAnimation)
                            
                            // IMDb Rating
                            HStack(spacing: 6) {
                                // IMDb Logo placeholder
                                RoundedRectangle(cornerRadius: 4)
                                    .fill(Color(hex: "F5C518"))
                                    .frame(width: 38, height: 18)
                                    .overlay(
                                        Text("IMDb")
                                            .font(.system(size: 9, weight: .bold))
                                            .foregroundColor(.black)
                                    )
                                if let imdbRating = selectedMovie.imdbRating {
                                    Text(String(format: "%.1f", imdbRating))
                                        .font(.system(size: 17, weight: .semibold))
                                        .foregroundColor(.white)
                                }
                            }
                            .padding(.bottom, 20)
                            .opacity(appearAnimation ? 1 : 0)
                            .offset(y: appearAnimation ? 0 : 10)
                            .animation(.spring(response: 0.6, dampingFraction: 0.8).delay(0.5), value: appearAnimation)
                            
                            // Action Buttons
                            HStack(spacing: 12) {
                            // Buy Tickets Button
                            Button(action: {
                                haptic(.medium)
                                router.navigate(to: .dateTimeSelection(selectedMovie))
                            }) {
                                    Text("Buy Tickets")
                                        .font(.system(size: 17, weight: .semibold))
                                        .foregroundColor(.black)
                                        .frame(maxWidth: .infinity)
                                        .frame(height: 56)
                                        .background(
                                            LinearGradient(
                                                colors: [Color(hex: "FFC107"), Color(hex: "FF8C00")],
                                                startPoint: .leading,
                                                endPoint: .trailing
                                            )
                                        )
                                        .clipShape(Capsule())
                                }
                                .accessibilityLabel("Buy Tickets")
                                .accessibilityHint("Select date and time for \(selectedMovie.title)")
                                
                                // Play Trailer Button
                                Button(action: {
                                    haptic(.light)
                                }) {
                                    ZStack {
                                        Circle()
                                            .fill(Color.gray600.opacity(0.8))
                                            .frame(width: 56, height: 56)
                                        Image(systemName: "play.fill")
                                            .font(.system(size: 20))
                                            .foregroundColor(.white)
                                    }
                                }
                                .accessibilityLabel("Play Trailer")
                                .accessibilityHint("Watch trailer for \(selectedMovie.title)")
                            }
                            .padding(.horizontal, 24)
                            .padding(.bottom, 30)
                            .opacity(appearAnimation ? 1 : 0)
                            .offset(y: appearAnimation ? 0 : 20)
                            .animation(.spring(response: 0.6, dampingFraction: 0.8).delay(0.6), value: appearAnimation)
                        }
                    }
                }
                
                // Bottom Navigation Bar
                HStack(spacing: 0) {
                    Spacer()
                    Button(action: {}) {
                        Image(systemName: "house.fill")
                            .font(.system(size: 22))
                            .foregroundColor(.white)
                            .frame(width: 44, height: 44)
                    }
                    .accessibilityLabel("Home")
                    .accessibilityAddTraits(.isSelected)
                    Spacer()
                    Button(action: {}) {
                        Image(systemName: "magnifyingglass")
                            .font(.system(size: 22))
                            .foregroundColor(.white.opacity(0.6))
                            .frame(width: 44, height: 44)
                    }
                    .accessibilityLabel("Search")
                    Spacer()
                    Button(action: {}) {
                        Image(systemName: "bookmark")
                            .font(.system(size: 22))
                            .foregroundColor(.white.opacity(0.6))
                            .frame(width: 44, height: 44)
                    }
                    .accessibilityLabel("Saved")
                    Spacer()
                }
                .frame(height: 60)
                .background(Color.black)
                .overlay(
                    Rectangle()
                        .frame(height: 0.5)
                        .foregroundColor(.white.opacity(0.1)),
                    alignment: .top
                )
                .padding(.bottom, 34)
            }
        }
        .navigationBarHidden(true)
        .onAppear {
            appearAnimation = true
        }
    }
}

#Preview {
    NowShowingView()
        .environment(Router())
}

