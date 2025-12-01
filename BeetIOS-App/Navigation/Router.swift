import SwiftUI

/// Manages navigation state using NavigationStack and NavigationPath.
/// Handles all screen transitions in the cinema booking flow.
@Observable class Router {
    var path = NavigationPath()
    
    /// Represents all possible navigation destinations in the app.
    enum Screen: Hashable {
        case movieDetail(Movie)
        case dateTimeSelection(Movie)
        case ticketSelection(Movie, String) // Movie, Time
        case seatSelection(Movie, String, Int) // Movie, Time, TicketCount
        case checkout(Booking)
        case success(Booking)
    }
    
    /// Navigates to a new screen by appending it to the navigation path.
    func navigate(to screen: Screen) {
        path.append(screen)
    }
    
    /// Pops the current screen from the navigation stack.
    func pop() {
        if !path.isEmpty {
            path.removeLast()
        }
    }
    
    /// Resets navigation to the root screen.
    func popToRoot() {
        path = NavigationPath()
    }
}

