import SwiftUI

/// Manages checkout state including payment method selection and payment processing.
@Observable class CheckoutViewModel {
    var booking: Booking
    var selectedPaymentMethod: PaymentMethod = .applePay
    
    init(booking: Booking) {
        self.booking = booking
    }
    
    func processPayment() async -> Bool {
        // Simulate network delay
        try? await Task.sleep(nanoseconds: 2_000_000_000)
        return true
    }
}

