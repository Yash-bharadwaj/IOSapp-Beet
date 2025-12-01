import SwiftUI

/// Design constants following Apple HIG guidelines
enum DesignConstants {
    /// Spacing
    enum Spacing {
        static let small: CGFloat = 8
        static let medium: CGFloat = 16
        static let large: CGFloat = 24
        static let extraLarge: CGFloat = 32
    }
    
    /// Corner Radius
    enum CornerRadius {
        static let small: CGFloat = 8
        static let medium: CGFloat = 16
        static let large: CGFloat = 24
        static let extraLarge: CGFloat = 28
    }
    
    /// Animation
    enum Animation {
        static let springResponse: Double = 0.6
        static let springDamping: Double = 0.8
        static let quickSpringResponse: Double = 0.3
        static let quickSpringDamping: Double = 0.7
    }
    
    /// Layout
    enum Layout {
        static let horizontalPadding: CGFloat = 24
        static let bottomSpacing: CGFloat = 100
        static let buttonHeight: CGFloat = 56
        static let posterAspectRatio: CGFloat = 2/3
        static let posterHeight: CGFloat = 400
    }
    
    /// Typography
    enum Typography {
        static let titleSize: CGFloat = 34
        static let subtitleSize: CGFloat = 20
        static let bodySize: CGFloat = 17
        static let captionSize: CGFloat = 15
        static let smallSize: CGFloat = 12
    }
}

