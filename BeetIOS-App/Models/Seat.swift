import Foundation

enum SeatStatus: String, Codable {
    case available
    case occupied
    case selected
}

struct Seat: Identifiable, Hashable, Codable {
    let id: String
    let row: String
    let number: Int
    var status: SeatStatus
    
    var displayName: String {
        "\(row)\(number)"
    }
}

