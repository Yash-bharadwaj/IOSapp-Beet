import SwiftUI

struct TicketCard: View {
    let booking: Booking
    @State private var showCloseButton: Bool = true
    
    var body: some View {
        VStack(spacing: 0) {
            // Red Header Section (matching image2)
            ZStack {
                Color.ticketRed
                
                VStack(spacing: 12) {
                    Text(booking.movie.title.uppercased())
                        .font(.system(size: 24, weight: .bold))
                        .foregroundColor(.white)
                        .tracking(1)
                        .multilineTextAlignment(.center)
                    
                    // Character silhouette placeholder
                    ZStack {
                        // Background gradient (orange sunset)
                        LinearGradient(
                            colors: [
                                Color(hex: "FF6B35"),
                                Color(hex: "FF8C42"),
                                Color(hex: "FFA07A")
                            ],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                        .frame(width: 100, height: 120)
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                        
                        // Character silhouette
                        VStack(spacing: 0) {
                            // Head
                            Circle()
                                .fill(Color.black)
                                .frame(width: 40, height: 40)
                            
                            // Body (suit)
                            RoundedRectangle(cornerRadius: 6)
                                .fill(Color.black)
                                .frame(width: 70, height: 80)
                                .overlay(
                                    // White shirt
                                    VStack {
                                        RoundedRectangle(cornerRadius: 3)
                                            .fill(Color.white)
                                            .frame(width: 50, height: 50)
                                            .offset(y: 8)
                                        
                                        Spacer()
                                    }
                                )
                                .overlay(
                                    // Orange tie
                                    RoundedRectangle(cornerRadius: 2)
                                        .fill(Color(hex: "FF6B35"))
                                        .frame(width: 10, height: 40)
                                        .offset(y: 12)
                                )
                                .overlay(
                                    // Orange sunglasses
                                    HStack(spacing: 18) {
                                        Circle()
                                            .fill(Color(hex: "FF6B35"))
                                            .frame(width: 18, height: 18)
                                        
                                        Circle()
                                            .fill(Color(hex: "FF6B35"))
                                            .frame(width: 18, height: 18)
                                    }
                                    .offset(y: -20)
                                )
                        }
                    }
                    .padding(.top, 8)
                }
                .padding(20)
            }
            .frame(height: 200)
            .clipShape(
                UnevenRoundedRectangle(
                    cornerRadii: .init(
                        topLeading: 20,
                        bottomLeading: 0,
                        bottomTrailing: 0,
                        topTrailing: 20
                    )
                )
            )
            
            // Main Content Section (Black background matching image2)
            VStack(spacing: 0) {
                // Movie Details
                VStack(alignment: .leading, spacing: 12) {
                    Text(booking.movie.title)
                        .font(.system(size: 20, weight: .bold))
                        .foregroundColor(.white)
                    
                    Text(formatShowtime(booking.date, time: booking.time))
                        .font(.system(size: 14, weight: .regular))
                        .foregroundColor(.gray600)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(24)
                
                // Ticket Details Grid
                HStack(spacing: 0) {
                    ticketDetailColumn(title: "Screen", value: booking.cinemaHall.replacingOccurrences(of: "Hall ", with: ""))
                    
                    Rectangle()
                        .fill(Color.gray600.opacity(0.3))
                        .frame(width: 1, height: 50)
                    
                    ticketDetailColumn(title: "Row", value: booking.seats.first?.row ?? "")
                    
                    Rectangle()
                        .fill(Color.gray600.opacity(0.3))
                        .frame(width: 1, height: 50)
                    
                    ticketDetailColumn(title: "Seats", value: formatSeats(booking.seats))
                }
                .padding(.vertical, 24)
                .padding(.horizontal, 24)
                
                // Manage RSVP Button
                Button(action: {
                    // Manage RSVP action
                }) {
                    Text("Manage RSVP")
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(.black)
                        .frame(maxWidth: .infinity)
                        .frame(height: 48)
                        .background(Color.white)
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                }
                .padding(.horizontal, 24)
                .padding(.bottom, 24)
                
                // QR Code Section
                HStack(spacing: 12) {
                    Image(systemName: "ticket.fill")
                        .font(.system(size: 16))
                        .foregroundColor(.gray600)
                    
                    Text("Scan code at the counter to get a physical ticket.")
                        .font(.system(size: 12, weight: .regular))
                        .foregroundColor(.gray600)
                        .multilineTextAlignment(.leading)
                    
                    Spacer()
                    
                    QRCodeView(data: booking.id.uuidString)
                        .frame(width: 80, height: 80)
                }
                .padding(20)
                .background(Color(hex: "2A2A2A"))
            }
            .background(Color.black)
            .clipShape(
                UnevenRoundedRectangle(
                    cornerRadii: .init(
                        topLeading: 0,
                        bottomLeading: 20,
                        bottomTrailing: 20,
                        topTrailing: 0
                    )
                )
            )
        }
        .clipShape(RoundedRectangle(cornerRadius: 20))
        .shadow(color: .black.opacity(0.3), radius: 20, x: 0, y: 10)
    }
    
    private func ticketDetailColumn(title: String, value: String) -> some View {
        VStack(spacing: 8) {
            Text(title)
                .font(.system(size: 13, weight: .medium))
                .foregroundColor(.gray600)
            
            Text(value)
                .font(.system(size: 18, weight: .bold))
                .foregroundColor(.white)
        }
        .frame(maxWidth: .infinity)
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
    
    private func formatSeats(_ seats: [Seat]) -> String {
        if seats.count == 1 {
            return seats.first?.displayName ?? ""
        } else if seats.count == 2 {
            return seats.map { $0.displayName }.joined(separator: " - ")
        } else {
            let first = seats.first?.displayName ?? ""
            let last = seats.last?.displayName ?? ""
            return "\(first) - \(last)"
        }
    }
}

