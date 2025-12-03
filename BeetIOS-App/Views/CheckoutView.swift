import SwiftUI

/// Checkout view for finalizing movie ticket purchases.
/// Handles payment processing with proper error handling and user feedback.
struct CheckoutView: View {
    @Environment(Router.self) private var router
    let booking: Booking
    @State private var selectedPaymentMethod: PaymentMethod = .applePay
    @State private var isLoading = false
    @State private var appearAnimation = false
    @State private var errorMessage: String?
    @State private var showError = false
    
    /// Processes payment with proper error handling
    func processPayment() async throws {
        // Simulate network delay
        try await Task.sleep(nanoseconds: 2_000_000_000)
        
        // Simulate potential payment failures (10% chance for demo)
        if Int.random(in: 1...10) == 1 {
            throw PaymentError.paymentDeclined
        }
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
                        TicketCard(booking: booking)
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
                    title: "Pay \(String(format: "$%.2f", booking.totalPrice + 2.00))",
                    isLoading: isLoading,
                    isDisabled: isLoading
                ) {
                    Task { @MainActor in
                        isLoading = true
                        errorMessage = nil
                        showError = false
                        
                        do {
                            try await processPayment()
                            isLoading = false
                            haptic(.success)
                            router.navigate(to: .success(booking))
                        } catch {
                            isLoading = false
                            haptic(.error)
                            errorMessage = (error as? LocalizedError)?.errorDescription ?? error.localizedDescription
                            showError = true
                        }
                    }
                }
                .accessibilityLabel("Pay \(String(format: "$%.2f", booking.totalPrice + 2.00))")
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
            
            if showError, let errorMessage = errorMessage {
                VStack {
                    Spacer()
                    ErrorBanner(message: errorMessage) {
                        showError = false
                    }
                    .padding(.horizontal, 24)
                    .padding(.bottom, 100)
                    .transition(.move(edge: .bottom).combined(with: .opacity))
                }
            }
        }
        .navigationBarHidden(true)
        .onAppear {
            appearAnimation = true
        }
        .animation(.spring(response: 0.3, dampingFraction: 0.8), value: showError)
    }
    
    // MARK: - Subviews
    
    private var orderSummarySection: some View {
        VStack(alignment: .leading, spacing: DesignConstants.Spacing.medium) {
            Text("Order Summary")
                .font(.title3)
                .fontWeight(.bold)
                .foregroundColor(.white)
            
            VStack(spacing: 12) {
                summaryRow(title: "Subtotal", value: String(format: "$%.2f", booking.totalPrice))
                summaryRow(title: "Booking Fee", value: "$2.00")
                Divider().background(Color.gray.opacity(0.3))
                summaryRow(title: "Total", value: String(format: "$%.2f", booking.totalPrice + 2.00), isTotal: true)
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
                    isSelected: selectedPaymentMethod == method,
                    action: {
                        withAnimation(.spring(response: DesignConstants.Animation.quickSpringResponse, dampingFraction: DesignConstants.Animation.quickSpringDamping)) {
                            selectedPaymentMethod = method
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

