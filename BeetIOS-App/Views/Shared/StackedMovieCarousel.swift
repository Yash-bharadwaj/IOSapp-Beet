import SwiftUI

/// A premium stacked card carousel with 3D perspective effects.
/// Cards are stacked horizontally with depth, allowing users to swipe through movies.
struct StackedMovieCarousel: View {
    let movies: [Movie]
    @Binding var selectedMovie: Movie
    let onMovieTap: ((Movie) -> Void)?
    @State private var currentIndex: Int = 0
    @State private var dragOffset: CGFloat = 0
    @State private var isDragging = false
    @State private var showNavigationArrows = true
    
    init(movies: [Movie], selectedMovie: Binding<Movie>, onMovieTap: ((Movie) -> Void)? = nil) {
        self.movies = movies
        self._selectedMovie = selectedMovie
        self.onMovieTap = onMovieTap
    }
    
    // MARK: - Constants
    private enum Constants {
        static let maxVisibleCards = 6
        static let cardSpacing: CGFloat = 15
        static let cardScaleStep: CGFloat = 0.04
        static let cardOpacityStep: Double = 0.08
        static let cardOffsetStep: CGFloat = 10
        static let rotationAngle: Double = 1.0
        static let dragThreshold: CGFloat = 50
        static let cardAspectRatio: CGFloat = 0.68
        static let perspective: CGFloat = 0.4
        static let buttonSize: CGFloat = 48
        static let buttonPadding: CGFloat = 20
        static let hintFadeDelay: TimeInterval = 3.0
    }
    
    var body: some View {
        GeometryReader { geometry in
            // Calculate card size to fit within available space with safe padding
            let availableWidth = geometry.size.width
            let availableHeight = geometry.size.height
            let maxCardWidth = availableWidth * 0.85
            let maxCardHeight = availableHeight * 0.85 // Leave 15% padding top/bottom
            let cardWidth = min(maxCardWidth, maxCardHeight * Constants.cardAspectRatio)
            let cardHeight = min(cardWidth / Constants.cardAspectRatio, maxCardHeight)
            
            ZStack {
                // Render all cards from back to front
                ForEach(allCardIndices, id: \.self) { index in
                    let position = index - currentIndex
                    let absPosition = abs(position)
                    
                    StackedMovieCard(
                        movie: movies[index],
                        position: position,
                        cardWidth: cardWidth,
                        cardHeight: cardHeight
                    )
                    .zIndex(Double(movies.count - absPosition))
                    .offset(x: dragOffset + CGFloat(position) * Constants.cardOffsetStep)
                    .scaleEffect(scaleForPosition(position))
                    .opacity(opacityForPosition(position))
                    .rotation3DEffect(
                        .degrees(rotationForPosition(position)),
                        axis: (x: 0, y: 1, z: 0),
                        perspective: Constants.perspective
                    )
                    .animation(
                        isDragging ? nil : .spring(response: 0.4, dampingFraction: 0.85),
                        value: currentIndex
                    )
                    .animation(
                        isDragging ? nil : .spring(response: 0.3, dampingFraction: 0.8),
                        value: dragOffset
                    )
                    .onTapGesture {
                        if position == 0 {
                            // Front card - navigate to booking
                            haptic(.medium)
                            onMovieTap?(movies[index])
                        } else {
                            // Back card - bring to front
                            withAnimation(.spring(response: 0.4, dampingFraction: 0.85)) {
                                currentIndex = index
                                selectedMovie = movies[index]
                            }
                            haptic(.selection)
                        }
                    }
                }
                
                // Navigation Buttons Overlay - Visible during interaction
                HStack {
                    // Left Arrow Button
                    Button(action: {
                        guard currentIndex > 0 else { return }
                        withAnimation(.spring(response: 0.4, dampingFraction: 0.85)) {
                            currentIndex -= 1
                            selectedMovie = movies[currentIndex]
                        }
                        haptic(.light)
                        // Show arrows prominently after tap
                        showNavigationArrows = true
                    }) {
                        ZStack {
                            Circle()
                                .fill(Color.black.opacity(0.7))
                                .frame(width: Constants.buttonSize, height: Constants.buttonSize)
                                .overlay(
                                    Circle()
                                        .stroke(Color.white.opacity(0.5), lineWidth: 2)
                                )
                                .shadow(color: .black.opacity(0.5), radius: 10, x: 0, y: 4)
                            
                            Image(systemName: "chevron.left")
                                .font(.system(size: 20, weight: .bold))
                                .foregroundColor(.white)
                        }
                    }
                    .opacity(currentIndex > 0 ? (showNavigationArrows ? 1.0 : 0.3) : 0.2)
                    .disabled(currentIndex == 0)
                    .accessibilityLabel("Previous movie")
                    .accessibilityHint("Swipe to see previous movie")
                    
                    Spacer()
                    
                    // Right Arrow Button
                    Button(action: {
                        guard currentIndex < movies.count - 1 else { return }
                        withAnimation(.spring(response: 0.4, dampingFraction: 0.85)) {
                            currentIndex += 1
                            selectedMovie = movies[currentIndex]
                        }
                        haptic(.light)
                        // Show arrows prominently after tap
                        showNavigationArrows = true
                    }) {
                        ZStack {
                            Circle()
                                .fill(Color.black.opacity(0.7))
                                .frame(width: Constants.buttonSize, height: Constants.buttonSize)
                                .overlay(
                                    Circle()
                                        .stroke(Color.white.opacity(0.5), lineWidth: 2)
                                )
                                .shadow(color: .black.opacity(0.5), radius: 10, x: 0, y: 4)
                            
                            Image(systemName: "chevron.right")
                                .font(.system(size: 20, weight: .bold))
                                .foregroundColor(.white)
                        }
                    }
                    .opacity(currentIndex < movies.count - 1 ? (showNavigationArrows ? 1.0 : 0.3) : 0.2)
                    .disabled(currentIndex == movies.count - 1)
                    .accessibilityLabel("Next movie")
                    .accessibilityHint("Swipe to see next movie")
                }
                .padding(.horizontal, Constants.buttonPadding)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .allowsHitTesting(true)
                .animation(.easeInOut(duration: 0.3), value: showNavigationArrows)
                .animation(.easeInOut(duration: 0.3), value: currentIndex)
            }
            .frame(width: cardWidth, height: cardHeight)
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
            .contentShape(Rectangle())
            .gesture(
                DragGesture(minimumDistance: 10)
                    .onChanged { value in
                        isDragging = true
                        // Smooth drag with slight resistance
                        dragOffset = value.translation.width * 0.8
                        // Show arrows prominently when user starts dragging
                        if !showNavigationArrows {
                            withAnimation(.easeOut(duration: 0.2)) {
                                showNavigationArrows = true
                            }
                        }
                    }
                    .onEnded { value in
                        isDragging = false
                        handleDragEnd(translation: value.translation.width)
                        // Keep arrows visible for a bit after drag ends
                        Task { @MainActor in
                            try? await Task.sleep(nanoseconds: 2_000_000_000) // 2 seconds
                            withAnimation(.easeOut(duration: 0.6)) {
                                showNavigationArrows = false
                            }
                        }
                    }
            )
            .onChange(of: selectedMovie) { oldValue, newValue in
                if let index = movies.firstIndex(where: { $0.id == newValue.id }), index != currentIndex {
                    withAnimation(.spring(response: 0.5, dampingFraction: 0.8)) {
                        currentIndex = index
                    }
                }
            }
            .onAppear {
                if let index = movies.firstIndex(where: { $0.id == selectedMovie.id }) {
                    currentIndex = index
                }
                // Show arrows initially, then fade after delay
                showNavigationArrows = true
                Task { @MainActor in
                    try? await Task.sleep(nanoseconds: UInt64(Constants.hintFadeDelay * 1_000_000_000))
                    withAnimation(.easeOut(duration: 0.6)) {
                        showNavigationArrows = false
                    }
                }
            }
            .onChange(of: currentIndex) { oldValue, newValue in
                // Show arrows prominently when user navigates
                showNavigationArrows = true
                Task { @MainActor in
                    try? await Task.sleep(nanoseconds: UInt64(Constants.hintFadeDelay * 1_000_000_000))
                    withAnimation(.easeOut(duration: 0.6)) {
                        showNavigationArrows = false
                    }
                }
            }
        }
    }
    
    // MARK: - Computed Properties
    
    private var visibleCardIndices: [Int] {
        // Show all movies, but limit rendering to visible ones for performance
        let start = max(0, currentIndex - Constants.maxVisibleCards / 2)
        let end = min(movies.count, currentIndex + Constants.maxVisibleCards / 2 + 1)
        return Array(start..<end)
    }
    
    private var allCardIndices: [Int] {
        // Return all movie indices for proper rendering
        return Array(0..<movies.count)
    }
    
    // MARK: - Helper Methods
    
    private func scaleForPosition(_ position: Int) -> CGFloat {
        let absPosition = abs(position)
        return 1.0 - (CGFloat(absPosition) * Constants.cardScaleStep)
    }
    
    private func opacityForPosition(_ position: Int) -> Double {
        let absPosition = abs(position)
        // Keep cards visible even when far back, but fade them more gradually
        return max(0.2, 1.0 - (Double(absPosition) * Constants.cardOpacityStep))
    }
    
    private func rotationForPosition(_ position: Int) -> Double {
        if position == 0 { return 0 }
        return Double(position) * Constants.rotationAngle
    }
    
    private func handleDragEnd(translation: CGFloat) {
        guard abs(translation) > Constants.dragThreshold else {
            // Snap back smoothly if threshold not met
            withAnimation(.spring(response: 0.3, dampingFraction: 0.8)) {
                dragOffset = 0
            }
            return
        }
        
        // Clean swipe animation
        withAnimation(.spring(response: 0.4, dampingFraction: 0.85)) {
            if translation > 0 && currentIndex > 0 {
                // Swipe right - go to previous
                currentIndex -= 1
                selectedMovie = movies[currentIndex]
                haptic(.light)
            } else if translation < 0 && currentIndex < movies.count - 1 {
                // Swipe left - go to next
                currentIndex += 1
                selectedMovie = movies[currentIndex]
                haptic(.light)
            }
            dragOffset = 0
        }
    }
}

