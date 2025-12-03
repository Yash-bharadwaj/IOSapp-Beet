import SwiftUI

/// A premium horizontal carousel for displaying movies with smooth animations and interactions.
/// Features include:
/// - Smooth scrolling with spring animations
/// - Scale and opacity transitions for selected cards
/// - Drag gesture support for navigation
/// - Auto-scroll to selected movie
struct MovieCarousel: View {
    let movies: [Movie]
    @Binding var selectedMovie: Movie
    @State private var currentIndex: Int = 0
    
    // MARK: - Constants
    private enum Constants {
        static let cardSpacing: CGFloat = 20
        static let cardWidthRatio: CGFloat = 0.75
        static let dragThreshold: CGFloat = 50
        static let scrollDelay: TimeInterval = 0.1
    }
    
    var body: some View {
        GeometryReader { geometry in
            let cardWidth = geometry.size.width * Constants.cardWidthRatio
            
            ScrollViewReader { proxy in
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: Constants.cardSpacing) {
                        ForEach(Array(movies.enumerated()), id: \.element.id) { index, movie in
                            MovieCarouselCard(
                                movie: movie,
                                isSelected: index == currentIndex,
                                geometry: geometry
                            )
                            .id(index)
                            .onTapGesture {
                                withAnimation(.spring(response: 0.5, dampingFraction: 0.8)) {
                                    currentIndex = index
                                    selectedMovie = movie
                                    proxy.scrollTo(index, anchor: .center)
                                }
                                haptic(.selection)
                            }
                        }
                    }
                    .padding(.horizontal, (geometry.size.width - cardWidth) / 2)
                    .padding(.vertical, 20)
                }
                .scrollTargetBehavior(.paging)
                .onChange(of: selectedMovie) { oldValue, newValue in
                    if let index = movies.firstIndex(where: { $0.id == newValue.id }), index != currentIndex {
                        withAnimation(.spring(response: 0.5, dampingFraction: 0.8)) {
                            currentIndex = index
                            proxy.scrollTo(index, anchor: .center)
                        }
                    }
                }
                .onAppear {
                    // Auto-scroll to selected movie
                    if let index = movies.firstIndex(where: { $0.id == selectedMovie.id }) {
                        currentIndex = index
                        Task { @MainActor in
                            try? await Task.sleep(nanoseconds: UInt64(Constants.scrollDelay * 1_000_000_000))
                            proxy.scrollTo(index, anchor: .center)
                        }
                    }
                }
                .gesture(
                    DragGesture()
                        .onEnded { value in
                            handleDragEnd(
                                translation: value.translation.width,
                                proxy: proxy
                            )
                        }
                )
            }
        }
    }
    
    // MARK: - Private Methods
    
    private func handleDragEnd(translation: CGFloat, proxy: ScrollViewProxy) {
        guard abs(translation) > Constants.dragThreshold else { return }
        
        withAnimation(.spring(response: 0.5, dampingFraction: 0.8)) {
            if translation > 0 && currentIndex > 0 {
                currentIndex -= 1
                selectedMovie = movies[currentIndex]
                proxy.scrollTo(currentIndex, anchor: .center)
                haptic(.light)
            } else if translation < 0 && currentIndex < movies.count - 1 {
                currentIndex += 1
                selectedMovie = movies[currentIndex]
                proxy.scrollTo(currentIndex, anchor: .center)
                haptic(.light)
            }
        }
    }
}

