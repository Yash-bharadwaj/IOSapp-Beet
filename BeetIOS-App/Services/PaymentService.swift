import Foundation

/// Service responsible for processing payments in the cinema booking app.
/// Handles payment processing logic with error handling and network simulation.
class PaymentService {
    /// Processes a payment for a booking.
    /// - Parameters:
    ///   - booking: The booking to process payment for
    ///   - paymentMethod: The selected payment method
    /// - Throws: PaymentError if payment processing fails
    func processPayment(for booking: Booking, using paymentMethod: PaymentMethod) async throws {
        // Simulate network delay
        try await Task.sleep(nanoseconds: 2_000_000_000)
        
        // Simulate potential payment failures (10% chance for demo)
        if Int.random(in: 1...10) == 1 {
            throw PaymentError.paymentDeclined
        }
    }
}

