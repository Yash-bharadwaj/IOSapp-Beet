import SwiftUI
import UIKit

enum HapticStyle {
    case light
    case medium
    case heavy
    case success
    case warning
    case error
    case selection
    
    var feedbackStyle: UIImpactFeedbackGenerator.FeedbackStyle {
        switch self {
        case .light: return .light
        case .medium: return .medium
        case .heavy: return .heavy
        default: return .medium
        }
    }
}

extension View {
    func haptic(_ style: HapticStyle = .medium) {
        switch style {
        case .light, .medium, .heavy:
            let generator = UIImpactFeedbackGenerator(style: style.feedbackStyle)
            generator.impactOccurred()
        case .success:
            let generator = UINotificationFeedbackGenerator()
            generator.notificationOccurred(.success)
        case .warning:
            let generator = UINotificationFeedbackGenerator()
            generator.notificationOccurred(.warning)
        case .error:
            let generator = UINotificationFeedbackGenerator()
            generator.notificationOccurred(.error)
        case .selection:
            let generator = UISelectionFeedbackGenerator()
            generator.selectionChanged()
        }
    }
}

