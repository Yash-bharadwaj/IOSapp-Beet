import SwiftUI

/// Premium typography system using SF Pro Display
extension Font {
    /// Premium display font for large titles
    static func premiumDisplay(size: CGFloat, weight: Font.Weight = .bold) -> Font {
        .system(size: size, weight: weight, design: .default)
    }
    
    /// Premium title font
    static func premiumTitle(size: CGFloat = 34, weight: Font.Weight = .bold) -> Font {
        .system(size: size, weight: weight, design: .default)
    }
    
    /// Premium headline font
    static func premiumHeadline(size: CGFloat = 20, weight: Font.Weight = .semibold) -> Font {
        .system(size: size, weight: weight, design: .default)
    }
    
    /// Premium body font
    static func premiumBody(size: CGFloat = 17, weight: Font.Weight = .regular) -> Font {
        .system(size: size, weight: weight, design: .default)
    }
    
    /// Premium caption font
    static func premiumCaption(size: CGFloat = 15, weight: Font.Weight = .medium) -> Font {
        .system(size: size, weight: weight, design: .default)
    }
    
    /// Premium small font
    static func premiumSmall(size: CGFloat = 13, weight: Font.Weight = .regular) -> Font {
        .system(size: size, weight: weight, design: .default)
    }
}

extension Text {
    /// Apply premium tracking (letter spacing) for display text
    func premiumTracking(_ tracking: CGFloat) -> some View {
        self.tracking(tracking)
    }
}

