import Foundation

/// Service responsible for managing showtimes for movies.
/// Handles showtime generation and retrieval logic.
struct ShowtimeService {
    /// Default showtimes available for movies
    static let defaultShowtimes = ["10:30 AM", "12:45 PM", "3:30 PM", "6:15 PM", "9:00 PM"]
    
    /// Alternative showtimes for different date selections
    static let alternativeShowtimes = ["10:45 AM", "02:45 PM", "08:00 PM", "10:30 PM"]
    
    /// Retrieves showtimes for a given movie and date.
    /// - Parameters:
    ///   - movie: The movie to get showtimes for
    ///   - date: The date to get showtimes for
    /// - Returns: Array of showtime strings
    static func getShowtimes(for movie: Movie, on date: Date) -> [String] {
        // In a real app, this would fetch from an API based on movie and date
        // For now, return default showtimes
        return defaultShowtimes
    }
    
    /// Retrieves alternative showtimes (used in date selection view).
    /// - Returns: Array of alternative showtime strings
    static func getAlternativeShowtimes() -> [String] {
        return alternativeShowtimes
    }
    
    /// Gets the default selected showtime (middle one).
    /// - Returns: Default showtime string
    static func getDefaultSelectedShowtime() -> String {
        guard !defaultShowtimes.isEmpty else { return "" }
        let middleIndex = defaultShowtimes.count / 2
        return defaultShowtimes[middleIndex]
    }
}

