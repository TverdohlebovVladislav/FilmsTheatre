import SwiftUI

struct MovieListView: View {
    @State private var movies: [Movie] = [] // Все загруженные фильмы
    @State private var filteredMovies: [Movie] = [] // Отфильтрованные фильмы
    @State private var selectedGenre: String = "All"
    @State private var genres: [(id: Int, name: String)] = [(0, "All")] // Жанры с их ID
    
    @State private var currentPage: [Int: Int] = [0: 1] // Текущая страница для каждого жанра
    @State private var isLoading = false // Флаг загрузки
    
    @State private var minimumRating: Double = 0.0 // Минимальный рейтинг
    @State private var favorites: [Movie] = []
    

    var body: some View {
        NavigationView {
            VStack {
                // Слайдер для фильтрации по рейтингу
                    HStack {
                        Text("Минимальный рейтинг: \(String(format: "%.1f", minimumRating))")
                        Slider(value: $minimumRating, in: 0...10, step: 0.5) {
                            Text("Рейтинг")
                        }
                        .onChange(of: minimumRating) { _ in
                            filterMovies()
                        }
                    }
                    .padding()
                
                // Фильтр по жанрам
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack {
                        ForEach(genres, id: \.id) { genre in
                            Button(action: {
                                selectedGenre = genre.name
                                if genre.id == 0 {
                                    // Если выбран "All", показываем все фильмы
                                    filteredMovies = movies
                                } else {
                                    // Загружаем фильмы для выбранного жанра
                                    loadMoviesForGenre(genreId: genre.id, reset: true)
                                }
                            }) {
                                Text(genre.name)
                                    .padding()
                                    .background(selectedGenre == genre.name ? Color.blue : Color.gray.opacity(0.2))
                                    .foregroundColor(.white)
                                    .cornerRadius(10)
                            }
                        }
                    }
                    .padding()
                }

                // Лента фильмов
                ScrollView {
                    LazyVStack(alignment: .leading, spacing: 20) {
                        ForEach(filteredMovies) { movie in
                            NavigationLink(destination: MovieDetailView(movie: movie)) {
                                MovieRow(movie: movie)
                            }
                        }

                        // Подгрузка новых фильмов при прокрутке до конца
                        if !isLoading {
                            ProgressView()
                                .onAppear {
                                    let genreId = genres.first(where: { $0.name == selectedGenre })?.id ?? 0
                                    loadMoviesForGenre(genreId: genreId, reset: false)
                                }
                        }
                    }
                    .padding()
                }
                .navigationTitle("Фильмы")
            }
            .onAppear {
                if movies.isEmpty {
                    loadGenres() // Загружаем жанры при первом запуске
                    loadMoviesForGenre(genreId: 0, reset: false) // Загружаем фильмы для "All"
                }
            }
        }
    }

    // Загрузка фильмов для выбранного жанра
    private func loadMoviesForGenre(genreId: Int, reset: Bool) {
        guard !isLoading else { return }

        if reset {
            currentPage[genreId] = 1
            filteredMovies = [] // Очищаем список фильмов
        }

        let page = currentPage[genreId] ?? 1
        isLoading = true

        let baseURL = genreId == 0
            ? "https://api.themoviedb.org/3/movie/popular"
            : "https://api.themoviedb.org/3/discover/movie"

        let urlString = "\(baseURL)?api_key=\(Config.tmdbApiKey)&language=en-US&page=\(page)" +
                        (genreId != 0 ? "&with_genres=\(genreId)" : "")

        guard let url = URL(string: urlString) else { return }

        URLSession.shared.dataTask(with: url) { data, response, error in
            DispatchQueue.main.async {
                self.isLoading = false
            }

            if let data = data {
                do {
                    let response = try JSONDecoder().decode(MovieResponse.self, from: data)
                    DispatchQueue.main.async {
                        let newMovies = response.results.filter { $0.voteAverage >= self.minimumRating } // Учет рейтинга
                        self.filteredMovies.append(contentsOf: newMovies)

                        if genreId == 0 {
                            self.movies.append(contentsOf: newMovies)
                        }

                        self.currentPage[genreId, default: 1] += 1
                    }
                } catch {
                    print("Ошибка декодирования фильмов: \(error)")
                }
            }
        }.resume()
    }


    // Загрузка жанров
    private func loadGenres() {
        guard let url = URL(string: "https://api.themoviedb.org/3/genre/movie/list?api_key=\(Config.tmdbApiKey)&language=en-US") else { return }

        URLSession.shared.dataTask(with: url) { data, response, error in
            if let data = data {
                do {
                    let response = try JSONDecoder().decode(GenreResponse.self, from: data)
                    DispatchQueue.main.async {
                        self.genres = [(0, "All")] + response.genres.map { ($0.id, $0.name) }
                    }
                } catch {
                    print("Ошибка декодирования жанров: \(error)")
                }
            }
        }.resume()
    }
    
    
    private func filterMovies() {
        if selectedGenre == "All" {
            filteredMovies = movies.filter { $0.voteAverage >= minimumRating }
        } else {
            filteredMovies = movies.filter {
                $0.genreNames.contains(selectedGenre) && $0.voteAverage >= minimumRating
            }
        }
    }
}
