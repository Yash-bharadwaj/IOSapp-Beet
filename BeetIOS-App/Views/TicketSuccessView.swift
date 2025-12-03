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
            
            ScrollView {
                VStack(spacing: 24) {
                    // Success Header
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
                    .padding(.top, 40)
                    
                    // Ticket Card with Scaling Animation
                    TicketCard(booking: booking)
                        .padding(.horizontal, 24)
                        .scaleEffect(scale)
                        .onAppear {
                            haptic(.success)
                            withAnimation(.spring(response: DesignConstants.Animation.quickSpringResponse, dampingFraction: DesignConstants.Animation.quickSpringDamping)) {
                                scale = 1.0
                            }
                        }
                    
                    // Action Buttons
                    VStack(spacing: 16) {
                        GradientButton(title: "Share Ticket", icon: "square.and.arrow.up") {
                            // Share action placeholder
                            haptic(.medium)
                        }
                        
                        Button(action: {
                            haptic(.medium)
                            // Navigate back to Now Showing to book another movie
                            router.popToRoot()
                        }) {
                            Text("Book Another Movie")
                                .font(.system(size: 17, weight: .semibold))
                                .foregroundColor(.white.opacity(0.8))
                                .frame(maxWidth: .infinity)
                                .frame(height: 50)
                                .background(Color.white.opacity(0.1))
                                .cornerRadius(12)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 12)
                                        .stroke(Color.white.opacity(0.2), lineWidth: 1)
                                )
                        }
                        .accessibilityLabel("Book Another Movie")
                        .accessibilityHint("Return to movie selection to book another ticket")
                    }
                    .padding(.horizontal, DesignConstants.Layout.horizontalPadding)
                    .padding(.bottom, 34)
                }
            }
        }
        .navigationBarHidden(true)
    }
}

