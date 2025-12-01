import Foundation

struct Movie: Identifiable, Codable, Hashable {
    let id: UUID
    let title: String
    let genre: String
    let duration: String
    let rating: Double
    let posterImage: String
    let synopsis: String
    let isIMAX: Bool
    let year: Int?
    let tagline: String?
    let imdbRating: Double?
}

extension Movie {
    static let mock = Movie(
        id: UUID(),
        title: "Dune: Part Two",
        genre: "Sci-Fi / Adventure",
        duration: "2h 46m",
        rating: 4.8,
        posterImage: "poster-placeholder", // Placeholder as per requirements
        synopsis: "Paul Atreides unites with Chani and the Fremen while on a warpath of revenge against the conspirators who destroyed his family.",
        isIMAX: true,
        year: nil,
        tagline: nil,
        imdbRating: nil
    )
    
    static let badGuys = Movie(
        id: UUID(),
        title: "the BAD GUYS",
        genre: "Animation",
        duration: "96 min",
        rating: 7.7,
        posterImage: "poster-placeholder",
        synopsis: "After a lifetime of legendary heists, notorious criminals Mr. Wolf, Mr. Snake, Mr. Piranha, Mr. Shark, and Ms. Tarantula are finally caught.",
        isIMAX: false,
        year: 2025,
        tagline: "BACK IN BADNESS",
        imdbRating: 7.7
    )
}

