import SwiftUI
import UIKit

struct SeatSelectionView: View {
    @Environment(Router.self) private var router
    @State private var viewModel: SeatSelectionViewModel
    @State private var appearAnimation = false
    @State private var showTooltip = false
    @State private var isLoadingSeats = true
    @State private var showCheckoutDialog = false
    
    let ticketCount: Int
    
    init(movie: Movie, time: String, ticketCount: Int) {
        self.ticketCount = ticketCount
        _viewModel = State(initialValue: SeatSelectionViewModel(movie: movie, time: time, ticketCount: ticketCount))
    }
    
    var body: some View {
        ZStack {
            // Background gradient
            LinearGradient(
                colors: [Color.black, Color(hex: "0A0A0A")],
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()
            
            VStack(spacing: 0) {
                // Header
                HeaderBar(title: "Where to Sit?") {
                    router.pop()
                }
                .padding(.bottom, 8)
                
                Text("Select Seats")
                    .font(.system(size: DesignConstants.Typography.captionSize, weight: .medium))
                    .foregroundColor(.gray600)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal, DesignConstants.Layout.horizontalPadding)
                    .padding(.bottom, DesignConstants.Spacing.medium)
                
                // Cinema Screen
                CinemaScreenView(movie: viewModel.movie)
                    .padding(.bottom, DesignConstants.Layout.horizontalPadding)
                    .opacity(appearAnimation ? 1 : 0)
                    .offset(y: appearAnimation ? 0 : -20)
                    .animation(.spring(response: DesignConstants.Animation.springResponse, dampingFraction: DesignConstants.Animation.springDamping).delay(0.1), value: appearAnimation)
                
                // Seat Grid with embedded tooltip
                ZStack(alignment: .top) {
                    ScrollView {
                        GeometryReader { geometry in
                            ZStack {
                                if isLoadingSeats {
                                    SeatGridSkeleton()
                                        .padding(.top, 8)
                                } else {
                                    SeatGrid(
                                        seats: viewModel.seats,
                                        selectedSeats: viewModel.selectedSeats,
                                        onSeatTap: { seat in
                                            withAnimation(.spring(response: DesignConstants.Animation.quickSpringResponse, dampingFraction: DesignConstants.Animation.quickSpringDamping)) {
                                                viewModel.toggleSeat(seat)
                                                
                                                // Update tooltip visibility
                                                if !viewModel.selectedSeats.isEmpty {
                                                    showTooltip = true
                                                } else {
                                                    showTooltip = false
                                                }
                                            }
                                        }
                                    )
                                    .padding(.top, DesignConstants.Spacing.small)
                                    .opacity(appearAnimation ? 1 : 0)
                                    .offset(y: appearAnimation ? 0 : 20)
                                    .animation(.spring(response: DesignConstants.Animation.springResponse, dampingFraction: DesignConstants.Animation.springDamping).delay(0.2), value: appearAnimation)
                                    
                                    // Tooltip badge positioned above selected seats
                                    if showTooltip && !viewModel.selectedSeats.isEmpty {
                                        SeatTooltipBadge(
                                            row: getSelectedRow(),
                                            seatCount: viewModel.selectedSeats.count,
                                            totalCount: ticketCount,
                                            totalPrice: viewModel.totalPrice,
                                            selectedSeats: Array(viewModel.selectedSeats)
                                        )
                                        .padding(.top, calculateTooltipTopOffset())
                                        .padding(.leading, calculateTooltipLeadingOffset())
                                        .transition(.scale.combined(with: .opacity))
                                    }
                                }
                            }
                        }
                        .frame(height: 400)
                    }
                }
                
                Spacer()
            }
            
            // Premium Continue Button at Bottom with Legends above
            VStack {
                Spacer()
                
                // Legends above Continue button
                LegendsView()
                    .padding(.bottom, DesignConstants.Spacing.medium)
                    .opacity(appearAnimation ? 1 : 0)
                    .animation(.spring(response: DesignConstants.Animation.springResponse, dampingFraction: DesignConstants.Animation.springDamping).delay(0.5), value: appearAnimation)
                
                Button(action: {
                    guard viewModel.selectedSeats.count == ticketCount else { return }
                    haptic(.medium)
                    withAnimation(.spring(response: 0.3, dampingFraction: 0.8)) {
                        showCheckoutDialog = true
                    }
                }) {
                    Text("Continue")
                        .font(.system(size: DesignConstants.Typography.bodySize, weight: .bold))
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .frame(height: DesignConstants.Layout.buttonHeight)
                        .background(
                            Group {
                                if viewModel.selectedSeats.count != ticketCount {
                                    LinearGradient(
                                        colors: [Color.gray600, Color.gray600],
                                        startPoint: .topLeading,
                                        endPoint: .bottomTrailing
                                    )
                                } else {
                                    LinearGradient(
                                        colors: [Color.buttonYellow, Color(hex: "FF8C00")],
                                        startPoint: .topLeading,
                                        endPoint: .bottomTrailing
                                    )
                                }
                            }
                        )
                        .clipShape(RoundedRectangle(cornerRadius: 28))
                        .overlay(
                            RoundedRectangle(cornerRadius: 28)
                                .stroke(
                                    LinearGradient(
                                        colors: [
                                            Color.white.opacity(viewModel.selectedSeats.count != ticketCount ? 0.1 : 0.2),
                                            Color.clear
                                        ],
                                        startPoint: .topLeading,
                                        endPoint: .bottomTrailing
                                    ),
                                    lineWidth: 1
                                )
                        )
                }
                .disabled(viewModel.selectedSeats.count != ticketCount)
                .accessibilityLabel("Continue to checkout")
                .accessibilityHint(viewModel.selectedSeats.count != ticketCount ? "Select \(ticketCount) seats to continue" : "Proceed to checkout with selected seats")
                .padding(.horizontal, DesignConstants.Layout.horizontalPadding)
                .padding(.bottom, 34)
                .opacity(appearAnimation ? 1 : 0)
                .offset(y: appearAnimation ? 0 : 50)
                .animation(.spring(response: DesignConstants.Animation.springResponse, dampingFraction: DesignConstants.Animation.springDamping).delay(0.6), value: appearAnimation)
            }
        }
        .navigationBarHidden(true)
        .overlay {
            if showCheckoutDialog {
                CheckoutDialog(
                    booking: viewModel.createBooking(),
                    isPresented: $showCheckoutDialog
                )
                .environment(router)
                .zIndex(1000)
            }
        }
        .onAppear {
            // Simulate seat loading
            Task {
                try? await Task.sleep(nanoseconds: 500_000_000) // 0.5 seconds
                isLoadingSeats = false
                appearAnimation = true
            }
        }
        .onChange(of: viewModel.selectedSeats) { oldValue, newValue in
            if newValue.isEmpty {
                withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                    showTooltip = false
                }
            } else {
                showTooltip = true
            }
        }
    }
    
    // MARK: - Helper Methods
    
    private func calculateTooltipTopOffset() -> CGFloat {
        guard let firstSeat = viewModel.selectedSeats.first else { return 0 }
        let rowIndex = ["A", "B", "C", "D", "E", "F", "G", "H"].firstIndex(of: firstSeat.row) ?? 0
        let rowSpacing: CGFloat = 10
        let seatHeight: CGFloat = 24
        // Position above the row
        return CGFloat(rowIndex) * (seatHeight + rowSpacing) - 35
    }
    
    private func calculateTooltipLeadingOffset() -> CGFloat {
        guard let firstSeat = viewModel.selectedSeats.first,
              let lastSeat = viewModel.selectedSeats.sorted(by: { $0.number < $1.number }).last else {
            return 0
        }
        
        let rowLabelWidth: CGFloat = 28
        let rowLabelSpacing: CGFloat = DesignConstants.Spacing.medium
        let horizontalPadding: CGFloat = DesignConstants.Layout.horizontalPadding
        let seatWidth: CGFloat = 24
        let seatSpacing: CGFloat = DesignConstants.Spacing.small
        
        // Calculate center position of selected seats
        let firstSeatCenter = horizontalPadding + rowLabelWidth + rowLabelSpacing + (CGFloat(firstSeat.number - 1) * (seatWidth + seatSpacing)) + (seatWidth / 2)
        let lastSeatCenter = horizontalPadding + rowLabelWidth + rowLabelSpacing + (CGFloat(lastSeat.number - 1) * (seatWidth + seatSpacing)) + (seatWidth / 2)
        let centerX = (firstSeatCenter + lastSeatCenter) / 2
        
        // Return leading offset (badge width is approximately 100pt, so center it)
        return centerX - 50
    }
    
    private func getSelectedRow() -> String {
        if let firstSeat = viewModel.selectedSeats.first {
            return firstSeat.row
        }
        return ""
    }
}

extension View {
    func cornerRadius(_ radius: CGFloat, corners: UIRectCorner) -> some View {
        clipShape(RoundedCorner(radius: radius, corners: corners))
    }
}

struct RoundedCorner: Shape {
    var radius: CGFloat = .infinity
    var corners: UIRectCorner = .allCorners

    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(
            roundedRect: rect,
            byRoundingCorners: corners,
            cornerRadii: CGSize(width: radius, height: radius)
        )
        return Path(path.cgPath)
    }
}

