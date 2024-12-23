import Foundation

class FavoritesManager: ObservableObject {
    @Published var favoriteMovies: [Movie] = [] {
        didSet {
            saveMovies()
        }
    }

    @Published var favoriteEvents: [Event] = [] {
        didSet {
            saveEvents()
        }
    }

    init() {
        loadMovies()
        loadEvents()
    }

    private func saveMovies() {
        if let encoded = try? JSONEncoder().encode(favoriteMovies) {
            UserDefaults.standard.set(encoded, forKey: "favoriteMovies")
        }
    }

    private func saveEvents() {
        if let encoded = try? JSONEncoder().encode(favoriteEvents) {
            UserDefaults.standard.set(encoded, forKey: "favoriteEvents")
        }
    }

    private func loadMovies() {
        if let data = UserDefaults.standard.data(forKey: "favoriteMovies"),
           let decoded = try? JSONDecoder().decode([Movie].self, from: data) {
            favoriteMovies = decoded
        }
    }

    private func loadEvents() {
        if let data = UserDefaults.standard.data(forKey: "favoriteEvents"),
           let decoded = try? JSONDecoder().decode([Event].self, from: data) {
            favoriteEvents = decoded
        }
    }

    func toggleFavoriteMovie(_ movie: Movie) {
        if favoriteMovies.contains(where: { $0.id == movie.id }) {
            favoriteMovies.removeAll { $0.id == movie.id }
        } else {
            favoriteMovies.append(movie)
        }
    }

    func toggleFavoriteEvent(_ event: Event) {
        if favoriteEvents.contains(where: { $0.id == event.id }) {
            favoriteEvents.removeAll { $0.id == event.id }
        } else {
            favoriteEvents.append(event)
        }
    }

    func isFavoriteMovie(_ movie: Movie) -> Bool {
        favoriteMovies.contains(where: { $0.id == movie.id })
    }

    func isFavoriteEvent(_ event: Event) -> Bool {
        favoriteEvents.contains(where: { $0.id == event.id })
    }
}
