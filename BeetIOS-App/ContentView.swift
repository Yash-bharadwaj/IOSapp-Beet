//
//  ContentView.swift
//  BeetIOS-App
//
//  Created by Yashwanth Bharadwaj on 01/12/25.
//

import SwiftUI

struct ContentView: View {
    @State private var router = Router()
    
    var body: some View {
        NavigationStack(path: $router.path) {
            NowShowingView()
                .environment(router)
                .navigationDestination(for: Router.Screen.self) { screen in
                    destinationView(for: screen)
                }
        }
        .animation(.spring(response: 0.35, dampingFraction: 0.85), value: router.path.count)
    }
    
    @ViewBuilder
    private func destinationView(for screen: Router.Screen) -> some View {
        switch screen {
        case .movieDetail(let movie):
            MovieDetailView(movie: movie)
                .environment(router)
        case .dateTimeSelection(let movie):
            DateTimeSelectionView(movie: movie)
                .environment(router)
        case .ticketSelection(let movie, let time):
            TicketSelectionView(movie: movie, selectedTime: time)
                .environment(router)
        case .seatSelection(let movie, let time, let ticketCount):
            SeatSelectionView(movie: movie, time: time, ticketCount: ticketCount)
                .environment(router)
        case .checkout(let booking):
            CheckoutView(booking: booking)
                .environment(router)
        case .success(let booking):
            TicketSuccessView(booking: booking)
                .environment(router)
        }
    }
}

#Preview {
    ContentView()
}
