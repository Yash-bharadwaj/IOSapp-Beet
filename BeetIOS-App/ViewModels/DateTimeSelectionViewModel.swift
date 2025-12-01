import SwiftUI

/// Manages date and time selection state for movie showtimes.
/// Provides date formatting utilities and showtime availability.
@Observable class DateTimeSelectionViewModel {
    var movie: Movie
    var selectedDate: Date
    var selectedTime: String?
    
    // Available dates (next 7 days)
    var availableDates: [Date] {
        var dates: [Date] = []
        let calendar = Calendar.current
        let today = calendar.startOfDay(for: Date())
        
        for i in 0..<7 {
            if let date = calendar.date(byAdding: .day, value: i, to: today) {
                dates.append(date)
            }
        }
        return dates
    }
    
    // Available showtimes for selected date
    var availableShowtimes: [String] {
        // Different showtimes for different days (example)
        let allShowtimes = ["10:45 AM", "02:45 PM", "08:00 PM", "10:30 PM"]
        return allShowtimes
    }
    
    init(movie: Movie) {
        self.movie = movie
        // Default to today
        self.selectedDate = Calendar.current.startOfDay(for: Date())
    }
    
    func selectDate(_ date: Date) {
        selectedDate = date
        selectedTime = nil // Reset time when date changes
    }
    
    func selectTime(_ time: String) {
        selectedTime = time
    }
    
    func formatDateDay(_ date: Date) -> String {
        let calendar = Calendar.current
        let day = calendar.component(.day, from: date)
        return "\(day)"
    }
    
    func formatDateLetter(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "E"
        let dayLetter = formatter.string(from: date)
        return String(dayLetter.prefix(1))
    }
    
    func isDateSelected(_ date: Date) -> Bool {
        Calendar.current.isDate(selectedDate, inSameDayAs: date)
    }
    
    func isDateToday(_ date: Date) -> Bool {
        Calendar.current.isDateInToday(date)
    }
}

