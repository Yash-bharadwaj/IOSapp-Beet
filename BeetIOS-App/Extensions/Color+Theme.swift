import SwiftUI

extension Color {
    static let primaryPurple = Color(hex: "6B46C1")
    static let pinkAccent = Color(hex: "F472B6")
    static let deepBlue = Color(hex: "1E3A8A")
    static let successGreen = Color(hex: "10B981")
    static let gray600 = Color(hex: "6B7280")
    static let themeWhite = Color(hex: "FFFFFF")
    static let seatYellow = Color(hex: "FFD700") // Gold yellow for selected seats
    static let seatGold = Color(hex: "FFC107") // Amber gold
    static let buttonYellow = Color(hex: "FFC107") // Bright yellow for Continue button (matching reference)
    static let ticketRed = Color(hex: "DC2626") // Red for ticket header (matching reference)
    
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (1, 1, 1, 0)
        }

        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue:  Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
}

