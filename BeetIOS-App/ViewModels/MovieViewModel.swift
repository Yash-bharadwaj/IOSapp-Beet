import SwiftUI

/// Manages movie detail state including showtime selection.
@Observable class MovieViewModel {
    var movie: Movie
    var selectedDate: Date = Date()
    var selectedTime: String?
    
    let showtimes = ["10:30 AM", "12:45 PM", "3:30 PM", "6:15 PM", "9:00 PM"]
    
    init(movie: Movie = .mock) {
        self.movie = movie
        // Default selection
        self.selectedTime = showtimes[2]
    }
    
    func selectTime(_ time: String) {
        selectedTime = time
    }
}

