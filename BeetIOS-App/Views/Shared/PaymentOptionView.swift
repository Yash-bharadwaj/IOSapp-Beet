import SwiftUI

struct PaymentOptionView: View {
    let method: PaymentMethod
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack {
                Image(systemName: method.iconName)
                    .font(.system(size: 24))
                    .foregroundColor(isSelected ? .primaryPurple : .gray)
                    .frame(width: 32)
                
                Text(method.rawValue)
                    .font(.system(size: 17, weight: .medium))
                    .foregroundColor(isSelected ? .white : .gray)
                
                Spacer()
                
                if isSelected {
                    Image(systemName: "checkmark.circle.fill")
                        .foregroundColor(.primaryPurple)
                } else {
                    Circle()
                        .stroke(Color.gray.opacity(0.5), lineWidth: 1)
                        .frame(width: 20, height: 20)
                }
            }
            .padding(16)
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(Color.white.opacity(0.05))
                    .overlay(
                        RoundedRectangle(cornerRadius: 16)
                            .stroke(isSelected ? Color.primaryPurple : Color.clear, lineWidth: 1)
                    )
            )
        }
        .accessibilityLabel("\(method.rawValue) payment method")
        .accessibilityHint(isSelected ? "Currently selected" : "Double tap to select")
        .accessibilityAddTraits(isSelected ? .isSelected : [])
    }
}

