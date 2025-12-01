import SwiftUI

struct TicketSelectionView: View {
    @Environment(Router.self) private var router
    let movie: Movie
    let selectedTime: String
    
    @State private var viewModel = TicketSelectionViewModel()
    @State private var appearAnimation = false
    
    var body: some View {
        ZStack {
            // Background
            LinearGradient(
                colors: [Color.black, Color(hex: "0A0A0A")],
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()
            
            ScrollView {
                VStack(spacing: 32) {
                    // Header
                    HeaderBar(title: "Ticket Selection") {
                        router.pop()
                    }
                    .padding(.top, 8)
                    
                    // Movie Info Card
                    MovieInfoCard(movie: movie)
                        .padding(.horizontal, 24)
                        .opacity(appearAnimation ? 1 : 0)
                        .offset(y: appearAnimation ? 0 : -20)
                        .animation(.spring(response: 0.6, dampingFraction: 0.8).delay(0.1), value: appearAnimation)
                    
                    // Who's going Section
                    VStack(spacing: 16) {
                        // Section Title
                        VStack(spacing: 8) {
                            Text("Who's going?")
                                .font(.system(size: 32, weight: .bold))
                                .foregroundColor(.white)
                            
                            Text("Select tickets amount")
                                .font(.system(size: 15, weight: .medium))
                                .foregroundColor(.gray600)
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.horizontal, 24)
                        .opacity(appearAnimation ? 1 : 0)
                        .offset(y: appearAnimation ? 0 : 10)
                        .animation(.spring(response: 0.6, dampingFraction: 0.8).delay(0.2), value: appearAnimation)
                        
                        // Emoji Avatars
                        EmojiAvatarsContainer(count: viewModel.ticketCount)
                            .padding(.vertical, 24)
                            .opacity(appearAnimation ? 1 : 0)
                            .animation(.spring(response: 0.6, dampingFraction: 0.8).delay(0.3), value: appearAnimation)
                        
                        // Ticket Quantity Selector
                        TicketQuantitySelector(
                            count: $viewModel.ticketCount,
                            minCount: viewModel.minTickets,
                            maxCount: viewModel.maxTickets,
                            onDecrease: {
                                viewModel.decreaseTickets()
                            },
                            onIncrease: {
                                viewModel.increaseTickets()
                            }
                        )
                        .padding(.vertical, 20)
                        .opacity(appearAnimation ? 1 : 0)
                        .offset(y: appearAnimation ? 0 : 20)
                        .animation(.spring(response: 0.6, dampingFraction: 0.8).delay(0.4), value: appearAnimation)
                    }
                    
                    Spacer().frame(height: 100) // Bottom spacing for button
                }
            }
            
            // Continue Button
            VStack {
                Spacer()
                PremiumButton(title: "Continue") {
                    haptic(.medium)
                    router.navigate(to: .seatSelection(movie, selectedTime, viewModel.ticketCount))
                }
                .padding(.horizontal, 24)
                .padding(.bottom, 34)
                .opacity(appearAnimation ? 1 : 0)
                .offset(y: appearAnimation ? 0 : 50)
                .animation(.spring(response: 0.6, dampingFraction: 0.8).delay(0.5), value: appearAnimation)
            }
        }
        .navigationBarHidden(true)
        .onAppear {
            appearAnimation = true
        }
    }
}

// Container for animated emoji avatars in a premium horizontal layout
struct EmojiAvatarsContainer: View {
    let count: Int
    @State private var visibleIndices: Set<Int> = []
    
    private let emojiSize: CGFloat = 80
    private let spacing: CGFloat = 28 // Premium spacing between emojis
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: spacing) {
                // Leading spacer for centering when content fits
                Spacer()
                    .frame(width: calculateCenteringSpacer())
                
                ForEach(0..<max(count, 1), id: \.self) { index in
                    EmojiAvatar(
                        emoji: EmojiAvatar.emojiStyles[index % EmojiAvatar.emojiStyles.count],
                        index: index,
                        isVisible: visibleIndices.contains(index)
                    )
                    .frame(width: emojiSize, height: emojiSize)
                }
                
                // Trailing spacer for centering when content fits
                Spacer()
                    .frame(width: calculateCenteringSpacer())
            }
            .padding(.horizontal, 24)
        }
        .scrollDisabled(count <= 4) // Disable scroll when emojis fit on screen
        .frame(height: emojiSize + 20) // Fixed height to prevent layout shifts
        .onChange(of: count) { _, newValue in
            updateVisibleIndices(newCount: newValue)
        }
        .onAppear {
            updateVisibleIndices(newCount: count)
        }
    }
    
    private func calculateCenteringSpacer() -> CGFloat {
        // Only add spacer when count is small enough to fit on screen
        guard count <= 4 else { return 0 }
        
        let screenWidth: CGFloat = 393 // iPhone 15 Pro width
        let totalEmojiWidth = CGFloat(count) * emojiSize
        let totalSpacing = CGFloat(max(0, count - 1)) * spacing
        let totalContentWidth = totalEmojiWidth + totalSpacing + 48 // 24 padding each side
        let availableSpace = max(0, screenWidth - totalContentWidth)
        return availableSpace / 2
    }
    
    private func updateVisibleIndices(newCount: Int) {
        let oldCount = visibleIndices.count
        
        if newCount > oldCount {
            // Adding new emojis with staggered animation
            for index in oldCount..<newCount {
                let delay = Double(index - oldCount) * 0.1
                DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
                    visibleIndices.insert(index)
                }
            }
        } else if newCount < oldCount {
            // Removing emojis
            let indicesToRemove = Array(visibleIndices).sorted().reversed().prefix(oldCount - newCount)
            for (offset, index) in indicesToRemove.enumerated() {
                DispatchQueue.main.asyncAfter(deadline: .now() + Double(offset) * 0.05) {
                    visibleIndices.remove(index)
                }
            }
        }
    }
}

