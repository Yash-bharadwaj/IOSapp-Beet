import Foundation
import SwiftUI

/// Manages ticket quantity selection with min/max constraints.
@Observable
class TicketSelectionViewModel {
    var ticketCount: Int = 1
    let minTickets: Int = 1
    let maxTickets: Int = 10
    
    var canDecrease: Bool {
        ticketCount > minTickets
    }
    
    var canIncrease: Bool {
        ticketCount < maxTickets
    }
    
    func decreaseTickets() {
        guard canDecrease else { return }
        ticketCount -= 1
    }
    
    func increaseTickets() {
        guard canIncrease else { return }
        ticketCount += 1
    }
}

