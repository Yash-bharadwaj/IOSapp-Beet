import SwiftUI

struct TicketSuccessView: View {
    @Environment(Router.self) private var router
    var booking: Booking
    
    @State private var scale: CGFloat = 1.2
    
    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()
            
            // Confetti Background
            ConfettiView()
                .opacity(0.6)
            
            VStack(spacing: 32) {
                Spacer()
                
                VStack(spacing: 16) {
                    Image(systemName: "checkmark.circle.fill")
                        .font(.system(size: 64))
                        .foregroundColor(.successGreen)
                        .symbolEffect(.bounce, value: scale)
                    
                    Text("Booking Confirmed!")
                        .font(.title)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                    
                    Text("Your tickets are ready.")
                        .font(.body)
                        .foregroundColor(.gray)
                }
                
                // Ticket Card with Scaling Animation
                TicketCard(booking: booking)
                    .padding(.horizontal, 32)
                    .scaleEffect(scale)
                    .onAppear {
                        haptic(.success)
                        withAnimation(.spring(response: DesignConstants.Animation.quickSpringResponse, dampingFraction: DesignConstants.Animation.quickSpringDamping)) {
                            scale = 1.0
                        }
                    }
                
                Spacer()
                
                VStack(spacing: 16) {
                    GradientButton(title: "Share Ticket", icon: "square.and.arrow.up") {
                        // Share action placeholder
                    }
                    
                    Button(action: {
                        router.popToRoot()
                    }) {
                        Text("Book Another Movie")
                            .font(.system(size: 17, weight: .semibold))
                            .foregroundColor(.gray)
                            .padding()
                    }
                    .accessibilityLabel("Book Another Movie")
                    .accessibilityHint("Return to movie selection")
                }
                .padding(DesignConstants.Layout.horizontalPadding)
            }
        }
        .navigationBarHidden(true)
    }
}

