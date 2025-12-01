import SwiftUI

struct HeaderBar: View {
    let title: String
    var onBack: (() -> Void)? = nil
    
    var body: some View {
        HStack {
            if let onBack = onBack {
                Button(action: onBack) {
                    Image(systemName: "chevron.left")
                        .font(.system(size: 20, weight: .semibold))
                        .foregroundColor(.white)
                        .frame(width: 44, height: 44)
                        .background(Color.white.opacity(0.1))
                        .clipShape(Circle())
                }
                .accessibilityLabel("Back")
                .accessibilityHint("Return to previous screen")
            } else {
                Spacer().frame(width: 44)
            }
            
            Spacer()
            
            Text(title)
                .font(.system(size: 20, weight: .bold))
                .foregroundColor(.white)
            
            Spacer()
            
            // Balance layout
            Spacer().frame(width: 44)
        }
        .padding(.horizontal, 24)
        .frame(height: 60)
    }
}

