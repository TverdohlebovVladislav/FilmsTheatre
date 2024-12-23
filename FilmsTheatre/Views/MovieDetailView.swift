import SwiftUI

struct MovieDetailView: View {
    let movie: Movie
    @State private var reviews: [Review] = []
    @State private var selectedReview: Review?

    @State private var isFavorite: Bool = false // Локальное состояние избранного
    @EnvironmentObject var favoritesManager: FavoritesManager

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                // Изображение фильма
                AsyncImage(url: URL(string: movie.fullImageUrl)) { image in
                    image.resizable().aspectRatio(contentMode: .fill)
                } placeholder: {
                    Color.gray
                }
                .frame(height: 300)
                .cornerRadius(10)

                // Название
                Text(movie.title)
                    .font(.largeTitle)
                    .bold()

                // Рейтинг
                Text(String(format: "⭐️ %.1f", movie.voteAverage))
                    .font(.headline)
                    .foregroundColor(.orange)

                Button(action: {
                    favoritesManager.toggleFavoriteMovie(movie)
                }) {
                    Text(favoritesManager.isFavoriteMovie(movie) ? "Удалить из избранного" : "Добавить в избранное")
                        .padding()
                        .background(favoritesManager.isFavoriteMovie(movie) ? Color.red : Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }

                // Жанры
                Text(movie.genreNames.joined(separator: ", "))
                    .font(.subheadline)
                    .foregroundColor(.blue)
                    .padding(.bottom, 10)

                // Полное описание
                Text(movie.overview)
                    .font(.body)
                    .padding(.bottom, 20)
                
                // Раздел с отзывами
                Text("Отзывы")
                    .font(.title2)
                    .bold()

                if reviews.isEmpty {
                    Text("Нет отзывов.")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                } else {
                    ForEach(reviews) { review in
                        VStack(alignment: .leading, spacing: 10) {
                            Text(review.author)
                                .font(.headline)
                                .foregroundColor(.blue)
                            Text(review.content)
                                .font(.body)
                                .lineLimit(3)
                            Button(action: {
                                selectedReview = review
                            }) {
                                Text("Смотреть полностью")
                                    .font(.subheadline)
                                    .foregroundColor(.blue)
                            }
                        }
                        .padding(.bottom, 10)
                    }
                }
            }
            .padding()
        }
        .navigationTitle(movie.title)
        .onAppear {
            loadReviews()
        }
        .sheet(item: $selectedReview) { review in
            FullReviewView(review: review)
        }
    }
    
    private func loadReviews() {
            guard let url = URL(string: "https://api.themoviedb.org/3/movie/\(movie.id)/reviews?api_key=\(Config.tmdbApiKey)&language=en-US") else { return }

            URLSession.shared.dataTask(with: url) { data, response, error in
                if let data = data {
                    do {
                        let response = try JSONDecoder().decode(ReviewsResponse.self, from: data)
                        DispatchQueue.main.async {
                            self.reviews = response.results
                        }
                    } catch {
                        print("Ошибка декодирования отзывов: \(error)")
                    }
                }
            }.resume()
        }

}
