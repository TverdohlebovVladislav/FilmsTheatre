struct Movie: Identifiable, Codable {
    let id: Int
    let title: String
    let overview: String
    let posterPath: String
    let genreIds: [Int]
    let voteAverage: Double // Рейтинг
    
    // Генерация жанров на основе их ID
    var genreNames: [String] {
        genreIds.compactMap { Movie.genresMapping[$0] }
    }
    
    static var genresMapping: [Int: String] = [:] // Это заполняется после загрузки жанров
    
    enum CodingKeys: String, CodingKey {
        case id, title, overview
        case posterPath = "poster_path"
        case genreIds = "genre_ids"
        case voteAverage = "vote_average" // Сопоставление с JSON-ключом
    }

    var fullImageUrl: String {
        "https://image.tmdb.org/t/p/w500\(posterPath)"
    }
}
