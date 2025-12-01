import Foundation

struct Booking: Identifiable, Hashable {
    let id: UUID
    let movie: Movie
    let seats: [Seat]
    let date: Date
    let time: String
    let cinemaHall: String
    let totalPrice: Double
}

