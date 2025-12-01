import SwiftUI

struct TicketAnimationFlowView: View {
    let booking: Booking
    @Binding var isPresented: Bool
    @State private var showRotationAnimation = false
    @State private var showTicket = false
    @State private var animationComplete = false
    
    @Environment(Router.self) private var router
    
    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()
            
            if showRotationAnimation && !showTicket {
                // Rotation Animation Phase
                TicketRotationAnimationView(booking: booking)
                    .transition(.opacity)
                    .onAppear {
                        // Show rotation for 2.5 seconds, then transition to ticket
                        Task {
                            try? await Task.sleep(nanoseconds: 2_500_000_000)
                            withAnimation(.spring(response: 0.6, dampingFraction: 0.8)) {
                                showTicket = true
                            }
                        }
                    }
            } else if showTicket {
                // Final Ticket View
                VStack {
                    // Close button
                    HStack {
                        Spacer()
                        Button(action: {
                            haptic(.light)
                            withAnimation(.spring(response: 0.3, dampingFraction: 0.8)) {
                                isPresented = false
                            }
                            // Navigate to success after closing
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                                router.navigate(to: .success(booking))
                            }
                        }) {
                            Image(systemName: "xmark")
                                .font(.system(size: 16, weight: .semibold))
                                .foregroundColor(.white)
                                .frame(width: 32, height: 32)
                                .background(Color.white.opacity(0.1))
                                .clipShape(Circle())
                        }
                    }
                    .padding(.horizontal, 24)
                    .padding(.top, 20)
                    
                    Spacer()
                    
                    TicketCard(booking: booking)
                        .padding(.horizontal, 24)
                        .scaleEffect(showTicket ? 1.0 : 0.8)
                        .opacity(showTicket ? 1.0 : 0.0)
                        .animation(.spring(response: 0.6, dampingFraction: 0.8), value: showTicket)
                    
                    Spacer()
                }
                .onAppear {
                    // Auto-navigate to success after 3 seconds of showing ticket
                    Task {
                        try? await Task.sleep(nanoseconds: 3_000_000_000)
                        withAnimation(.spring(response: 0.3, dampingFraction: 0.8)) {
                            isPresented = false
                        }
                        try? await Task.sleep(nanoseconds: 300_000_000)
                        router.navigate(to: .success(booking))
                    }
                }
            }
        }
        .onAppear {
            // Start rotation animation immediately
            withAnimation(.spring(response: 0.3, dampingFraction: 0.8)) {
                showRotationAnimation = true
            }
        }
    }
}

