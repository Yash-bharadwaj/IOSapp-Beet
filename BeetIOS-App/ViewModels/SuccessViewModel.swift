import SwiftUI

/// Manages success screen state with booking confirmation details.
@Observable class SuccessViewModel {
    var booking: Booking
    
    init(booking: Booking) {
        self.booking = booking
    }
}

