import SwiftUI

struct MovieRow: View {
    let movie: Movie

    var body: some View {
        HStack(alignment: .top) {
            // Отображение изображения фильма
            AsyncImage(url: URL(string: movie.fullImageUrl)) { image in
                image.resizable().aspectRatio(contentMode: .fill)
            } placeholder: {
                Color.gray
            }
            .frame(width: 100, height: 150)
            .cornerRadius(10)

            // Текстовая информация о фильме
            VStack(alignment: .leading, spacing: 10) {
                Text(movie.title) // Название фильма
                    .font(.headline)
                    .lineLimit(1)
                Text(String(format: "⭐️ %.1f", movie.voteAverage)) // Отображаем рейтинг
                                    .font(.subheadline)
                                    .foregroundColor(.orange)
                Text(movie.overview) // Краткое описание
                    .font(.subheadline)
                    .foregroundColor(.gray)
                    .lineLimit(3)
                Text(movie.genreNames.joined(separator: ", ")) // Жанры
                    .font(.footnote)
                    .foregroundColor(.blue)
                    .lineLimit(1)
            }
        }
    }
}

