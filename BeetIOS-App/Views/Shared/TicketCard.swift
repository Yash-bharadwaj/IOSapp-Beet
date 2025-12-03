import SwiftUI
import UIKit

struct TicketCard: View {
    let booking: Booking
    @State private var showCloseButton: Bool = true
    
    var body: some View {
        VStack(spacing: 0) {
            // Red Header Section with Full Poster
            ZStack {
                // Full movie poster image as background
                Group {
                    if let uiImage = UIImage(named: booking.movie.posterImage) {
                        Image(uiImage: uiImage)
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                            .clipped()
                    } else {
                        // Fallback red background
                        Color.ticketRed
                    }
                }
                
                // Gradient overlay at top for title readability
                VStack {
                    LinearGradient(
                        colors: [
                            Color.black.opacity(0.6),
                            Color.black.opacity(0.3),
                            Color.clear
                        ],
                        startPoint: .top,
                        endPoint: .bottom
                    )
                    .frame(height: 80)
                    Spacer()
                }
                
                // Movie title overlaid on top
                VStack {
                    Text(booking.movie.title.uppercased())
                        .font(.system(size: 24, weight: .bold))
                        .foregroundColor(.white)
                        .tracking(1)
                        .multilineTextAlignment(.center)
                        .lineLimit(2)
                        .minimumScaleFactor(0.7)
                        .padding(.horizontal, 20)
                        .padding(.top, 20)
                        .shadow(color: .black.opacity(0.8), radius: 4, x: 0, y: 2)
                    
                    Spacer()
                }
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
                        .font(.system(size: 18, weight: .bold))
                        .foregroundColor(.white)
                        .lineLimit(2)
                        .minimumScaleFactor(0.8)
                    
                    Text(formatShowtime(booking.date, time: booking.time))
                        .font(.system(size: 13, weight: .regular))
                        .foregroundColor(.gray600)
                        .lineLimit(1)
                        .minimumScaleFactor(0.9)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(20)
                
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
                .padding(.vertical, 20)
                .padding(.horizontal, 20)
                
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
                        .font(.system(size: 14))
                        .foregroundColor(.gray600)
                        .frame(width: 16)
                    
                    Text("Scan code at the counter")
                        .font(.system(size: 11, weight: .regular))
                        .foregroundColor(.gray600)
                        .lineLimit(2)
                        .minimumScaleFactor(0.9)
                        .multilineTextAlignment(.leading)
                    
                    Spacer()
                    
                    QRCodeView(data: booking.id.uuidString)
                        .frame(width: 70, height: 70)
                }
                .padding(16)
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
        VStack(spacing: 6) {
            Text(title)
                .font(.system(size: 12, weight: .medium))
                .foregroundColor(.gray600)
                .lineLimit(1)
            
            Text(value)
                .font(.system(size: 16, weight: .bold))
                .foregroundColor(.white)
                .lineLimit(1)
                .minimumScaleFactor(0.8)
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

