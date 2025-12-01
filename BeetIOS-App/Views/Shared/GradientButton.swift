import SwiftUI

struct GradientButton: View {
    let title: String
    let icon: String?
    let action: () -> Void
    var isLoading: Bool = false
    var isDisabled: Bool = false
    var customColors: [Color]? = nil
    
    @State private var isPressed = false
    
    init(title: String, icon: String? = nil, isLoading: Bool = false, isDisabled: Bool = false, customColors: [Color]? = nil, action: @escaping () -> Void) {
        self.title = title
        self.icon = icon
        self.isLoading = isLoading
        self.isDisabled = isDisabled
        self.customColors = customColors
        self.action = action
    }
    
    var body: some View {
        Button(action: {
            guard !isLoading && !isDisabled else { return }
            
            withAnimation(.spring(response: 0.2, dampingFraction: 0.6)) {
                isPressed = true
            }
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                withAnimation(.spring(response: 0.2, dampingFraction: 0.6)) {
                    isPressed = false
                }
            }
            
            action()
        }) {
            HStack(spacing: 8) {
                if isLoading {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle(tint: .white))
                        .scaleEffect(0.8)
                } else {
                    Text(title)
                        .font(.system(size: 17, weight: .semibold))
                    
                    if let icon = icon {
                        Image(systemName: icon)
                            .font(.system(size: 17, weight: .semibold))
                    }
                }
            }
            .foregroundColor(.white)
            .frame(maxWidth: .infinity)
            .frame(height: 56)
            .background(
                Group {
                    if isDisabled {
                        Color.gray600
                    } else {
                        LinearGradient(
                            colors: customColors ?? [.primaryPurple, .pinkAccent],
                            startPoint: customColors != nil ? .topLeading : .leading,
                            endPoint: customColors != nil ? .bottomTrailing : .trailing
                        )
                    }
                }
            )
            .clipShape(RoundedRectangle(cornerRadius: 28))
            .shadow(
                color: (isDisabled || isLoading) ? Color.clear : (customColors?.first == Color.buttonYellow ? Color.buttonYellow.opacity(0.4) : Color.pinkAccent.opacity(0.4)),
                radius: 10,
                x: 0,
                y: 4
            )
        }
        .disabled(isLoading || isDisabled)
        .scaleEffect(isPressed ? 0.95 : 1.0)
        .animation(.spring(response: 0.2, dampingFraction: 0.6), value: isPressed)
        .accessibilityLabel(title)
        .accessibilityHint(isLoading ? "Processing" : isDisabled ? "Disabled" : "Double tap to \(title.lowercased())")
    }
}

