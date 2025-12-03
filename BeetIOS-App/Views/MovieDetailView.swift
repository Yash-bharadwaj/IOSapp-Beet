import SwiftUI

struct MovieDetailView: View {
    @Environment(Router.self) private var router
    let movie: Movie
    let showtimes = ["10:30 AM", "12:45 PM", "3:30 PM", "6:15 PM", "9:00 PM"]
    @State private var selectedTime: String?
    @State private var isLoading = false
    @State private var appearAnimation = false
    @Namespace private var animation
    
    init(movie: Movie) {
        self.movie = movie
        _selectedTime = State(initialValue: ["10:30 AM", "12:45 PM", "3:30 PM", "6:15 PM", "9:00 PM"][2])
    }
    
    var body: some View {
        ZStack {
            // Background Gradient
            LinearGradient(
                colors: [Color.primaryPurple.opacity(0.3), Color.black],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
            .background(Color.black)
            
            ScrollView {
                VStack(spacing: DesignConstants.Spacing.large) {
                    // Header
                    HeaderBar(title: "Movie Detail")
                    
                    if isLoading {
                        PosterSkeleton()
                            .padding(.top, DesignConstants.Spacing.medium)
                    } else {
                    // Poster (Hero) - with matched geometry for transition
                        posterView
                    }
                    
                    // Title & Info
                    titleAndInfoSection
                    
                    // Synopsis
                    synopsisSection
                    
                    // Showtimes
                    showtimesSection
                    
                    Spacer().frame(height: DesignConstants.Layout.bottomSpacing)
                }
            }
            .refreshable {
                await refreshMovie()
            }
            
            // Bottom CTA
            bottomCTASection
        }
        .navigationBarHidden(true)
        .onAppear {
            appearAnimation = true
        }
    }
    
    // MARK: - Subviews
    
    private var posterView: some View {
                    Rectangle()
                        .fill(Color.gray.opacity(0.3))
            .aspectRatio(DesignConstants.Layout.posterAspectRatio, contentMode: .fit)
            .frame(height: DesignConstants.Layout.posterHeight)
            .cornerRadius(DesignConstants.CornerRadius.large)
                        .overlay(
                            Image(systemName: "movieclapper")
                                .font(.system(size: 60))
                                .foregroundColor(.white.opacity(0.5))
                        )
                        .shadow(color: .primaryPurple.opacity(0.3), radius: 20, x: 0, y: 10)
            .padding(.top, DesignConstants.Spacing.medium)
                        .opacity(appearAnimation ? 1 : 0)
                        .scaleEffect(appearAnimation ? 1 : 0.9)
            .animation(.spring(response: DesignConstants.Animation.springResponse, dampingFraction: DesignConstants.Animation.springDamping).delay(0.1), value: appearAnimation)
                        .matchedGeometryEffect(id: "poster-\(movie.id)", in: animation)
                    }
                    
    private var titleAndInfoSection: some View {
                    VStack(spacing: 12) {
                        Text(movie.title)
                .font(.system(size: DesignConstants.Typography.titleSize, weight: .bold))
                            .foregroundColor(.white)
                            .multilineTextAlignment(.center)
                            .opacity(appearAnimation ? 1 : 0)
                            .offset(y: appearAnimation ? 0 : 10)
                .animation(.spring(response: DesignConstants.Animation.springResponse, dampingFraction: DesignConstants.Animation.springDamping).delay(0.2), value: appearAnimation)
                        
            HStack(spacing: DesignConstants.Spacing.medium) {
                            infoBadge(icon: "star.fill", text: String(format: "%.1f", movie.rating))
                            infoBadge(icon: "clock", text: movie.duration)
                            if movie.isIMAX {
                    imaxBadge
                }
            }
            .opacity(appearAnimation ? 1 : 0)
            .offset(y: appearAnimation ? 0 : 10)
            .animation(.spring(response: DesignConstants.Animation.springResponse, dampingFraction: DesignConstants.Animation.springDamping).delay(0.3), value: appearAnimation)
        }
    }
    
    private var imaxBadge: some View {
                                Text("IMAX")
            .font(.system(size: DesignConstants.Typography.smallSize, weight: .bold))
            .padding(.horizontal, DesignConstants.Spacing.small)
                                    .padding(.vertical, 4)
                                    .background(Color.white)
                                    .foregroundColor(.black)
                                    .cornerRadius(4)
                    }
                    
    private var synopsisSection: some View {
                    Text(movie.synopsis)
            .font(.system(size: DesignConstants.Typography.bodySize))
                        .foregroundColor(.gray)
                        .multilineTextAlignment(.center)
            .padding(.horizontal, DesignConstants.Layout.horizontalPadding)
                        .lineLimit(3)
                        .opacity(appearAnimation ? 1 : 0)
                        .offset(y: appearAnimation ? 0 : 10)
            .animation(.spring(response: DesignConstants.Animation.springResponse, dampingFraction: DesignConstants.Animation.springDamping).delay(0.4), value: appearAnimation)
    }
                    
    private var showtimesSection: some View {
        VStack(alignment: .leading, spacing: DesignConstants.Spacing.medium) {
                        Text("Select Showtime")
                .font(.system(size: DesignConstants.Typography.subtitleSize, weight: .bold))
                            .foregroundColor(.white)
                .padding(.horizontal, DesignConstants.Layout.horizontalPadding)
                            .opacity(appearAnimation ? 1 : 0)
                .animation(.spring(response: DesignConstants.Animation.springResponse, dampingFraction: DesignConstants.Animation.springDamping).delay(0.5), value: appearAnimation)
                        
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 12) {
                                ForEach(Array(showtimes.enumerated()), id: \.element) { index, time in
                                    ShowtimeChip(
                                        time: time,
                                        isSelected: selectedTime == time,
                                        action: {
                                            haptic(.selection)
                                            selectedTime = time
                                        }
                                    )
                                    .opacity(appearAnimation ? 1 : 0)
                                    .offset(x: appearAnimation ? 0 : 20)
                                    .animation(.spring(response: 0.5, dampingFraction: 0.7).delay(0.6 + Double(index) * 0.05), value: appearAnimation)
                                }
                            }
                .padding(.horizontal, DesignConstants.Layout.horizontalPadding)
            }
                }
            }
    
    private var bottomCTASection: some View {
            VStack {
                Spacer()
                GradientButton(
                    title: "Select Seats",
                    customColors: [Color.buttonYellow, Color(hex: "FF8C00")]
                ) {
                    haptic(.medium)
                    if let time = selectedTime {
                        router.navigate(to: .ticketSelection(movie, time))
                    }
                }
            .padding(DesignConstants.Layout.horizontalPadding)
                .background(
                    LinearGradient(colors: [.black.opacity(0), .black], startPoint: .top, endPoint: .bottom)
                )
                .opacity(appearAnimation ? 1 : 0)
                .offset(y: appearAnimation ? 0 : 50)
            .animation(.spring(response: DesignConstants.Animation.springResponse, dampingFraction: DesignConstants.Animation.springDamping).delay(0.7), value: appearAnimation)
            }
        }
    
    // MARK: - Helper Methods
    
    private func refreshMovie() async {
        isLoading = true
        try? await Task.sleep(nanoseconds: 1_000_000_000) // Simulate network delay
        isLoading = false
        appearAnimation = true
    }
    
    private func infoBadge(icon: String, text: String) -> some View {
        HStack(spacing: 4) {
            Image(systemName: icon)
                .foregroundColor(.yellow)
            Text(text)
                .foregroundColor(.gray)
        }
        .font(.system(size: DesignConstants.Typography.captionSize, weight: .medium))
    }
}

