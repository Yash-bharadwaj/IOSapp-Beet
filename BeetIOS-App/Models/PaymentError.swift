import Foundation

/// Payment processing errors
enum PaymentError: LocalizedError {
    case networkFailure
    case invalidPaymentMethod
    case insufficientFunds
    case paymentDeclined
    case unknown(Error)
    
    var errorDescription: String? {
        switch self {
        case .networkFailure:
            return "Network connection failed. Please check your internet connection."
        case .invalidPaymentMethod:
            return "Invalid payment method selected."
        case .insufficientFunds:
            return "Insufficient funds in your account."
        case .paymentDeclined:
            return "Payment was declined. Please try another payment method."
        case .unknown(let error):
            return "An unexpected error occurred: \(error.localizedDescription)"
        }
    }
}

