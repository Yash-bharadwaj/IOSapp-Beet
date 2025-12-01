import SwiftUI

struct LoadingOverlay: View {
    let message: String?
    
    init(message: String? = nil) {
        self.message = message
    }
    
    var body: some View {
        ZStack {
            Color.black.opacity(0.6)
                .ignoresSafeArea()
                .background(.ultraThinMaterial)
            
            VStack(spacing: 20) {
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle(tint: .white))
                    .scaleEffect(1.2)
                
                if let message = message {
                    Text(message)
                        .font(.system(size: 15, weight: .medium))
                        .foregroundColor(.white)
                }
            }
            .padding(32)
            .background(Color(hex: "1F1F1F").opacity(0.9))
            .cornerRadius(20)
            .shadow(color: .black.opacity(0.3), radius: 20, x: 0, y: 10)
        }
    }
}

