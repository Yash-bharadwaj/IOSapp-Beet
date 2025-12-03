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
        posterImage: "thebadguys",
        synopsis: "After a lifetime of legendary heists, notorious criminals Mr. Wolf, Mr. Snake, Mr. Piranha, Mr. Shark, and Ms. Tarantula are finally caught.",
        isIMAX: false,
        year: 2025,
        tagline: "BACK IN BADNESS",
        imdbRating: 7.7
    )
    
    static let dune = Movie(
        id: UUID(),
        title: "Dune: Part Two",
        genre: "Sci-Fi / Adventure",
        duration: "2h 46m",
        rating: 9.2,
        posterImage: "Dune",
        synopsis: "Paul Atreides unites with Chani and the Fremen while on a warpath of revenge against the conspirators who destroyed his family.",
        isIMAX: true,
        year: 2024,
        tagline: "LONG LIVE THE FIGHTERS",
        imdbRating: 8.7
    )
    
    static let oppenheimer = Movie(
        id: UUID(),
        title: "Oppenheimer",
        genre: "Biography / Drama",
        duration: "3h 0m",
        rating: 9.0,
        posterImage: "openheimer",
        synopsis: "The story of American scientist J. Robert Oppenheimer and his role in the development of the atomic bomb.",
        isIMAX: true,
        year: 2023,
        tagline: "THE WORLD FOREVER CHANGES",
        imdbRating: 8.3
    )
    
    static let barbie = Movie(
        id: UUID(),
        title: "Barbie",
        genre: "Comedy / Adventure",
        duration: "1h 54m",
        rating: 8.5,
        posterImage: "barbie",
        synopsis: "Barbie suffers a crisis that leads her to question her world and her existence.",
        isIMAX: false,
        year: 2023,
        tagline: "SHE'S EVERYTHING. HE'S JUST KEN.",
        imdbRating: 6.9
    )
    
    static let spiderMan = Movie(
        id: UUID(),
        title: "Spider-Man: Across the Spider-Verse",
        genre: "Animation / Action",
        duration: "2h 20m",
        rating: 9.5,
        posterImage: "spiderman",
        synopsis: "Miles Morales catapults across the Multiverse, where he encounters a team of Spider-People charged with protecting its very existence.",
        isIMAX: true,
        year: 2023,
        tagline: "IT'S HOW YOU WEAR THE MASK",
        imdbRating: 8.7
    )
    
    static let topGun = Movie(
        id: UUID(),
        title: "Top Gun: Maverick",
        genre: "Action / Drama",
        duration: "2h 10m",
        rating: 9.1,
        posterImage: "topgun",
        synopsis: "After thirty years, Maverick is still pushing the envelope as a top naval aviator, training a new generation of pilots.",
        isIMAX: true,
        year: 2022,
        tagline: "FEEL THE NEED",
        imdbRating: 8.2
    )
    
    static var allMovies: [Movie] {
        [badGuys, dune, oppenheimer, barbie, spiderMan, topGun]
    }
}

