import SwiftUI

/// Manages seat selection state and logic for the cinema booking flow.
/// Handles seat generation, selection algorithms, and booking creation.
@Observable class SeatSelectionViewModel {
    var movie: Movie
    var time: String
    var ticketCount: Int
    var seats: [Seat] = []
    var selectedSeats: Set<Seat> = []
    
    // Pricing
    let standardPrice: Double = 15.0
    
    var totalPrice: Double {
        Double(selectedSeats.count) * standardPrice
    }
    
    init(movie: Movie, time: String, ticketCount: Int = 1) {
        self.movie = movie
        self.time = time
        self.ticketCount = ticketCount
        generateSeats()
    }
    
    private func generateSeats() {
        let rows = ["A", "B", "C", "D", "E", "F", "G", "H"]
        var generatedSeats: [Seat] = []
        
        for row in rows {
            for number in 1...8 {
                // Randomly mark some as occupied for demo
                let isOccupied = Bool.random() && Bool.random() && Bool.random() // Low chance
                let status: SeatStatus = isOccupied ? .occupied : .available
                generatedSeats.append(Seat(id: "\(row)\(number)", row: row, number: number, status: status))
            }
        }
        self.seats = generatedSeats
    }
    
    /// Toggles seat selection. If seat is already selected, clears all selections.
    /// Otherwise, selects consecutive seats together based on ticket count.
    func toggleSeat(_ seat: Seat) {
        guard seat.status != .occupied else { return }
        
        if selectedSeats.contains(seat) {
            // Deselect this seat and all adjacent selected seats
            clearSelection()
        } else {
            // Select multiple seats together based on ticket count
            selectSeatsTogether(startingFrom: seat)
        }
    }
    
    /// Selects consecutive seats together starting from the given seat.
    /// Algorithm: First tries to select seats to the right, then fills remaining slots to the left if needed.
    /// This ensures seats are selected together for a better viewing experience.
    private func selectSeatsTogether(startingFrom seat: Seat) {
        clearSelection()
        
        let row = seat.row
        let startNumber = seat.number
        // Get all seats in row (available or selected) excluding occupied
        let seatsInRow = seats.filter { $0.row == row && $0.status != .occupied }
            .sorted(by: { $0.number < $1.number })
        
        // Find the starting seat index
        guard let startIndex = seatsInRow.firstIndex(where: { $0.number == startNumber }) else { return }
        
        // Select consecutive seats to the right first
        var selectedCount = 0
        
        // Try to select seats to the right
        for i in startIndex..<min(startIndex + ticketCount, seatsInRow.count) {
            let seatToSelect = seatsInRow[i]
            if seatToSelect.status == .available {
                selectedSeats.insert(seatToSelect)
                if let index = seats.firstIndex(where: { $0.id == seatToSelect.id }) {
                    seats[index].status = .selected
                }
                selectedCount += 1
                if selectedCount >= ticketCount { break }
            }
        }
        
        // If we couldn't get enough seats to the right, try left
        if selectedCount < ticketCount && startIndex > 0 {
            let needed = ticketCount - selectedCount
            for i in (max(0, startIndex - needed)..<startIndex).reversed() {
                if selectedCount >= ticketCount { break }
                let seatToSelect = seatsInRow[i]
                if seatToSelect.status == .available && !selectedSeats.contains(seatToSelect) {
                    selectedSeats.insert(seatToSelect)
                    if let index = seats.firstIndex(where: { $0.id == seatToSelect.id }) {
                        seats[index].status = .selected
                    }
                    selectedCount += 1
                }
            }
        }
    }
    
    private func clearSelection() {
        for seat in selectedSeats {
            if let index = seats.firstIndex(where: { $0.id == seat.id }) {
                seats[index].status = .available
            }
        }
        selectedSeats.removeAll()
    }
    
    func createBooking() -> Booking {
        Booking(
            id: UUID(),
            movie: movie,
            seats: Array(selectedSeats),
            date: Date(),
            time: time,
            cinemaHall: "Hall 1", // Static for now
            totalPrice: totalPrice
        )
    }
}

