import Foundation

enum PaymentMethod: String, CaseIterable, Identifiable {
    case applePay = "Apple Pay"
    case creditCard = "Credit Card"
    case paypal = "PayPal"
    
    var id: String { self.rawValue }
    
    var iconName: String {
        switch self {
        case .applePay: return "apple.logo"
        case .creditCard: return "creditcard.fill"
        case .paypal: return "dollarsign.circle.fill" // Placeholder
        }
    }
}

