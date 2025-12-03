import SwiftUI

struct NowShowingView: View {
    @Environment(Router.self) private var router
    @State private var selectedMovie: Movie = .badGuys
    @State private var appearAnimation = false
    
    private let movies = Movie.allMovies
    
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
                            .font(.premiumTitle(size: 28, weight: .bold))
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
                .padding(.bottom, 12)
                .zIndex(1)
                
                // Premium Stacked Movie Carousel - Flexible sizing with safe area
                GeometryReader { geometry in
                    StackedMovieCarousel(
                        movies: movies,
                        selectedMovie: $selectedMovie,
                        onMovieTap: { movie in
                            router.navigate(to: .dateTimeSelection(movie))
                        }
                    )
                    .frame(width: geometry.size.width, height: geometry.size.height)
                }
                .frame(minHeight: 400)
                .layoutPriority(1)
                
                // Selected Movie Tagline at Bottom (matching image design)
                if let tagline = selectedMovie.tagline {
                    Text(tagline)
                        .font(.premiumSmall(size: 15, weight: .medium))
                        .foregroundColor(.white)
                        .premiumTracking(2.5)
                        .padding(.horizontal, 24)
                        .padding(.top, 8)
                        .padding(.bottom, 4)
                        .opacity(appearAnimation ? 1 : 0)
                        .animation(.spring(response: 0.6, dampingFraction: 0.8), value: selectedMovie.id)
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

