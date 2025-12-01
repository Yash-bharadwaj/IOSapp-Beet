import SwiftUI

struct CheckoutView: View {
    @Environment(Router.self) private var router
    @State private var viewModel: CheckoutViewModel
    @State private var isLoading = false
    @State private var appearAnimation = false
    
    init(booking: Booking) {
        _viewModel = State(initialValue: CheckoutViewModel(booking: booking))
    }
    
    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()
            
            VStack(spacing: 0) {
                HeaderBar(title: "Checkout") {
                    router.pop()
                }
                
                ScrollView {
                    VStack(spacing: 32) {
                        // Ticket Preview
                        TicketCard(booking: viewModel.booking)
                            .padding(.horizontal, 24)
                            .padding(.top, 16)
                            .opacity(appearAnimation ? 1 : 0)
                            .offset(y: appearAnimation ? 0 : 20)
                            .scaleEffect(appearAnimation ? 1 : 0.95)
                            .animation(.spring(response: 0.6, dampingFraction: 0.8).delay(0.1), value: appearAnimation)
                        
                        // Order Summary
                        orderSummarySection
                        
                        // Payment Methods
                        paymentMethodsSection
                        
                        Spacer().frame(height: DesignConstants.Layout.bottomSpacing)
                    }
                }
            }
            
            // Pay Button
            VStack {
                Spacer()
                GradientButton(
                    title: "Pay \(String(format: "$%.2f", viewModel.booking.totalPrice + 2.00))",
                    isLoading: isLoading
                ) {
                    Task {
                        isLoading = true
                        if await viewModel.processPayment() {
                            isLoading = false
                            haptic(.success)
                            router.navigate(to: .success(viewModel.booking))
                        } else {
                            isLoading = false
                            haptic(.error)
                        }
                    }
                }
                .accessibilityLabel("Pay \(String(format: "$%.2f", viewModel.booking.totalPrice + 2.00))")
                .accessibilityHint("Complete your booking payment")
                .padding(DesignConstants.Layout.horizontalPadding)
                .background(
                    LinearGradient(colors: [.black.opacity(0), .black], startPoint: .top, endPoint: .bottom)
                )
                .opacity(appearAnimation ? 1 : 0)
                .offset(y: appearAnimation ? 0 : 50)
                .animation(.spring(response: DesignConstants.Animation.springResponse, dampingFraction: DesignConstants.Animation.springDamping).delay(0.4), value: appearAnimation)
            }
            
            if isLoading {
                LoadingOverlay(message: "Processing payment...")
            }
        }
        .navigationBarHidden(true)
        .onAppear {
            appearAnimation = true
        }
    }
    
    // MARK: - Subviews
    
    private var orderSummarySection: some View {
        VStack(alignment: .leading, spacing: DesignConstants.Spacing.medium) {
            Text("Order Summary")
                .font(.title3)
                .fontWeight(.bold)
                .foregroundColor(.white)
            
            VStack(spacing: 12) {
                summaryRow(title: "Subtotal", value: String(format: "$%.2f", viewModel.booking.totalPrice))
                summaryRow(title: "Booking Fee", value: "$2.00")
                Divider().background(Color.gray.opacity(0.3))
                summaryRow(title: "Total", value: String(format: "$%.2f", viewModel.booking.totalPrice + 2.00), isTotal: true)
            }
            .padding(20)
            .background(Color.white.opacity(0.05))
            .cornerRadius(DesignConstants.CornerRadius.medium)
        }
        .padding(.horizontal, DesignConstants.Layout.horizontalPadding)
        .opacity(appearAnimation ? 1 : 0)
        .offset(y: appearAnimation ? 0 : 20)
        .animation(.spring(response: DesignConstants.Animation.springResponse, dampingFraction: DesignConstants.Animation.springDamping).delay(0.2), value: appearAnimation)
    }
    
    private var paymentMethodsSection: some View {
        VStack(alignment: .leading, spacing: DesignConstants.Spacing.medium) {
            Text("Payment Method")
                .font(.title3)
                .fontWeight(.bold)
                .foregroundColor(.white)
            
            ForEach(PaymentMethod.allCases) { method in
                PaymentOptionView(
                    method: method,
                    isSelected: viewModel.selectedPaymentMethod == method,
                    action: {
                        withAnimation(.spring(response: DesignConstants.Animation.quickSpringResponse, dampingFraction: DesignConstants.Animation.quickSpringDamping)) {
                            viewModel.selectedPaymentMethod = method
                        }
                    }
                )
            }
        }
        .padding(.horizontal, DesignConstants.Layout.horizontalPadding)
        .opacity(appearAnimation ? 1 : 0)
        .offset(y: appearAnimation ? 0 : 20)
        .animation(.spring(response: DesignConstants.Animation.springResponse, dampingFraction: DesignConstants.Animation.springDamping).delay(0.3), value: appearAnimation)
    }
    
    // MARK: - Helper Methods
    
    private func summaryRow(title: String, value: String, isTotal: Bool = false) -> some View {
        HStack {
            Text(title)
                .foregroundColor(isTotal ? .white : .gray)
                .fontWeight(isTotal ? .bold : .regular)
            Spacer()
            Text(value)
                .foregroundColor(isTotal ? .white : .gray)
                .fontWeight(isTotal ? .bold : .regular)
        }
    }
}

