import SwiftUI

struct EventDetailView: View {
    let event: Event
    @State private var isFavorite: Bool = false // Локальное состояние избранного
    @EnvironmentObject var favoritesManager: FavoritesManager // Менеджер избранных

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                // Изображение события
                if let imageUrl = event.imageUrl, let url = URL(string: imageUrl) {
                    AsyncImage(url: url) { image in
                        image.resizable()
                            .aspectRatio(contentMode: .fit)
                    } placeholder: {
                        Color.gray
                    }
                    .frame(height: 300)
                    .cornerRadius(10)
                }

                // Название события
                Text(event.name)
                    .font(.largeTitle)
                    .bold()

                // Дата события
                if let startDate = event.startDate {
                    Text("Дата: \(startDate)")
                        .font(.headline)
                        .foregroundColor(.orange)
                }

                // Место проведения
                if let venueName = event.venueName {
                    Text("Место проведения: \(venueName)")
                        .font(.subheadline)
                        .foregroundColor(.blue)
                        .padding(.bottom, 10)
                }

                // Кнопка добавления в избранное
                Button(action: {
                    favoritesManager.toggleFavoriteEvent(event)
                }) {
                    Text(favoritesManager.isFavoriteEvent(event) ? "Удалить из избранного" : "Добавить в избранное")
                        .padding()
                        .background(favoritesManager.isFavoriteEvent(event) ? Color.red : Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }

                // Кнопка для перехода на сайт события
                if let eventUrl = event.eventUrl, let url = URL(string: eventUrl) {
                    Button(action: {
                        UIApplication.shared.open(url)
                    }) {
                        Text("Посмотреть на сайте")
                            .font(.headline)
                            .foregroundColor(.blue)
                            .padding()
                            .overlay(
                                RoundedRectangle(cornerRadius: 10)
                                    .stroke(Color.blue, lineWidth: 1)
                            )
                    } 
                }
            }
            .padding()
        }
        .navigationTitle(event.name)
        .navigationBarTitleDisplayMode(.inline)
    }
}
