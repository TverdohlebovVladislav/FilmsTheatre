import Foundation

class FavoritesManager: ObservableObject {
    @Published var favorites: [Movie] = [] {
        didSet {
            saveFavorites() // Сохраняем при каждом изменении
        }
    }

    init() {
        loadFavorites() // Загружаем при инициализации
    }

    private func saveFavorites() {
        if let encoded = try? JSONEncoder().encode(favorites) {
            UserDefaults.standard.set(encoded, forKey: "favorites")
        }
    }

    private func loadFavorites() {
        if let data = UserDefaults.standard.data(forKey: "favorites"),
           let decoded = try? JSONDecoder().decode([Movie].self, from: data) {
            favorites = decoded
        }
    }

    func toggleFavorite(_ movie: Movie) {
        if favorites.contains(where: { $0.id == movie.id }) {
            favorites.removeAll { $0.id == movie.id }
        } else {
            favorites.append(movie)
        }
    }

    func isFavorite(_ movie: Movie) -> Bool {
        favorites.contains(where: { $0.id == movie.id })
    }
}
