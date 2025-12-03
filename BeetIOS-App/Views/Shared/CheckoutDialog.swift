import SwiftUI
import UIKit

struct CheckoutDialog: View {
    let booking: Booking
    @Binding var isPresented: Bool
    @State private var isLoading = false
    @State private var dragOffset: CGFloat = 0
    @State private var isDragging = false
    @State private var showTicketAnimation = false
    
    @Environment(Router.self) private var router
    
    private let paymentService = PaymentService()
    
    var body: some View {
        ZStack {
            if showTicketAnimation {
                // Ticket Animation Flow
                TicketAnimationFlowView(booking: booking, isPresented: $isPresented)
                    .environment(router)
                    .transition(.opacity)
            } else {
                // Backdrop
                Color.black.opacity(0.6)
                    .ignoresSafeArea()
                    .onTapGesture {
                        withAnimation(.spring(response: 0.3, dampingFraction: 0.8)) {
                            isPresented = false
                        }
                    }
                
                // Dialog Content
            VStack {
                Spacer()
                
                VStack(spacing: 0) {
                    // Handle bar
                    RoundedRectangle(cornerRadius: 3)
                        .fill(Color.gray600.opacity(0.5))
                        .frame(width: 40, height: 4)
                        .padding(.top, 12)
                        .padding(.bottom, 8)
                    
                    // Header
                    HStack {
                        Text("Checkout")
                            .font(.system(size: 20, weight: .bold))
                            .foregroundColor(.white)
                        
                        Spacer()
                        
                        Button(action: {
                            haptic(.light)
                            withAnimation(.spring(response: 0.3, dampingFraction: 0.8)) {
                                isPresented = false
                            }
                        }) {
                            Image(systemName: "xmark")
                                .font(.system(size: 16, weight: .semibold))
                                .foregroundColor(.gray600)
                                .frame(width: 32, height: 32)
                                .background(Color.white.opacity(0.1))
                                .clipShape(Circle())
                        }
                        .accessibilityLabel("Close")
                        .accessibilityHint("Dismiss checkout dialog")
                    }
                    .padding(.horizontal, 24)
                    .padding(.bottom, 24)
                    
                    // Movie Details Section
                    HStack(spacing: 16) {
                        // Movie Poster
                        Group {
                            if let uiImage = UIImage(named: booking.movie.posterImage) {
                                Image(uiImage: uiImage)
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                                    .frame(width: 80, height: 120)
                                    .clipShape(RoundedRectangle(cornerRadius: 12))
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 12)
                                            .stroke(Color.gray600.opacity(0.2), lineWidth: 1)
                                    )
                            } else {
                                posterPlaceholder
                                    .frame(width: 80, height: 120)
                            }
                        }
                        
                        // Movie Info
                        VStack(alignment: .leading, spacing: 8) {
                            Text(booking.movie.title)
                                .font(.system(size: 18, weight: .bold))
                                .foregroundColor(.white)
                                .lineLimit(2)
                            
                            // Extract year from date or use current year
                            let year = Calendar.current.component(.year, from: booking.date)
                            Text("\(year) · \(booking.movie.genre) · \(booking.movie.duration)")
                                .font(.system(size: 14, weight: .regular))
                                .foregroundColor(.gray600)
                                .lineLimit(1)
                        }
                        
                        Spacer()
                    }
                    .padding(.horizontal, 24)
                    .padding(.bottom, 24)
                    
                    // Showtime and Seats Info
                    HStack(spacing: 12) {
                        Image(systemName: "ticket.fill")
                            .font(.system(size: 16))
                            .foregroundColor(.gray600)
                        
                        VStack(alignment: .leading, spacing: 4) {
                            Text(formatShowtime(booking.date, time: booking.time))
                                .font(.system(size: 15, weight: .medium))
                                .foregroundColor(.white)
                            
                            Text("Screen \(booking.cinemaHall.replacingOccurrences(of: "Hall ", with: "")) · Row \(booking.seats.first?.row ?? "A") · \(booking.seats.count) \(booking.seats.count == 1 ? "Seat" : "Seats")")
                                .font(.system(size: 13, weight: .regular))
                                .foregroundColor(.gray600)
                        }
                        
                        Spacer()
                    }
                    .padding(.horizontal, 24)
                    .padding(.bottom, 24)
                    
                    Divider()
                        .background(Color.gray600.opacity(0.3))
                        .padding(.horizontal, 24)
                        .padding(.bottom, 24)
                    
                    // Payment Section
                    HStack {
                        Text("Pay With")
                            .font(.system(size: 15, weight: .medium))
                            .foregroundColor(.white)
                        
                        Spacer()
                        
                        HStack(spacing: 8) {
                            Text(".... 4558")
                                .font(.system(size: 15, weight: .medium))
                                .foregroundColor(.white)
                            
                            // Mastercard logo placeholder
                            ZStack {
                                Circle()
                                    .fill(Color(hex: "EB001B"))
                                    .frame(width: 24, height: 24)
                                
                                Circle()
                                    .fill(Color(hex: "F79E1B"))
                                    .frame(width: 24, height: 24)
                                    .offset(x: -6)
                                    .blendMode(.multiply)
                            }
                            .frame(width: 24, height: 24)
                            
                            Image(systemName: "chevron.right")
                                .font(.system(size: 12, weight: .semibold))
                                .foregroundColor(.gray600)
                        }
                    }
                    .padding(.horizontal, 24)
                    .padding(.bottom, 24)
                    
                    Divider()
                        .background(Color.gray600.opacity(0.3))
                        .padding(.horizontal, 24)
                        .padding(.bottom, 24)
                    
                    // Total Section
                    HStack {
                        Text("Total")
                            .font(.system(size: 17, weight: .semibold))
                            .foregroundColor(.white)
                        
                        Spacer()
                        
                        Text(String(format: "$%.2f", booking.totalPrice))
                            .font(.system(size: 17, weight: .bold))
                            .foregroundColor(.white)
                    }
                    .padding(.horizontal, 24)
                    .padding(.bottom, 32)
                    
                    // Pay Button
                    Button(action: {
                        guard !isLoading else { return }
                        haptic(.medium)
                        Task { @MainActor in
                            isLoading = true
                            do {
                                try await paymentService.processPayment(for: booking, using: .applePay)
                                isLoading = false
                                haptic(.success)
                                // Show ticket animation flow
                                withAnimation(.spring(response: 0.3, dampingFraction: 0.8)) {
                                    showTicketAnimation = true
                                }
                            } catch {
                                isLoading = false
                                haptic(.error)
                                // In a real app, show error message to user
                            }
                        }
                    }) {
                        HStack {
                            if isLoading {
                                ProgressView()
                                    .progressViewStyle(CircularProgressViewStyle(tint: .white))
                                    .scaleEffect(0.8)
                            } else {
                                Text("Pay")
                                    .font(.system(size: 17, weight: .bold))
                                    .foregroundColor(.white)
                            }
                        }
                        .frame(maxWidth: .infinity)
                        .frame(height: 56)
                        .background(
                            LinearGradient(
                                colors: [Color.buttonYellow, Color(hex: "FF8C00")],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .clipShape(RoundedRectangle(cornerRadius: 28))
                    }
                    .disabled(isLoading)
                    .accessibilityLabel("Pay")
                    .accessibilityHint(isLoading ? "Processing payment" : "Complete payment of \(String(format: "$%.2f", booking.totalPrice))")
                    .padding(.horizontal, 24)
                    .padding(.bottom, 34)
                }
                .background(
                    Color(hex: "1A1A1A")
                )
                .clipShape(
                    UnevenRoundedRectangle(
                        cornerRadii: .init(
                            topLeading: 32,
                            bottomLeading: 0,
                            bottomTrailing: 0,
                            topTrailing: 32
                        )
                    )
                )
                .offset(y: dragOffset)
                .gesture(
                    DragGesture()
                        .onChanged { value in
                            if value.translation.height > 0 {
                                dragOffset = value.translation.height
                                isDragging = true
                            }
                        }
                        .onEnded { value in
                            if value.translation.height > 150 {
                                withAnimation(.spring(response: 0.3, dampingFraction: 0.8)) {
                                    isPresented = false
                                }
                            } else {
                                withAnimation(.spring(response: 0.3, dampingFraction: 0.8)) {
                                    dragOffset = 0
                                }
                            }
                            isDragging = false
                        }
                )
            }
            }
        }
        .transition(.move(edge: .bottom).combined(with: .opacity))
    }
    
    private var posterPlaceholder: some View {
        RoundedRectangle(cornerRadius: 12)
            .fill(
                LinearGradient(
                    colors: [Color.gray600.opacity(0.3), Color.gray600.opacity(0.1)],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
            )
            .overlay(
                Image(systemName: "photo")
                    .foregroundColor(.gray600)
            )
    }
    
    private func formatShowtime(_ date: Date, time: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEE, MMM d"
        let dateString = dateFormatter.string(from: date)
        
        // Parse time string (e.g., "2:45 PM" or "14:45")
        let timeString: String
        if time.contains("AM") || time.contains("PM") {
            timeString = time
        } else {
            // Convert 24-hour to 12-hour format if needed
            let timeFormatter = DateFormatter()
            timeFormatter.dateFormat = "HH:mm"
            if let timeDate = timeFormatter.date(from: time) {
                timeFormatter.dateFormat = "h:mm a"
                timeString = timeFormatter.string(from: timeDate)
            } else {
                timeString = time
            }
        }
        
        return "\(dateString) at \(timeString)"
    }
}


