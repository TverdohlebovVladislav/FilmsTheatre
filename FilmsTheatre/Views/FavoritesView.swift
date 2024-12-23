import SwiftUI

struct FavoritesView: View {
    @EnvironmentObject var favoritesManager: FavoritesManager

    var body: some View {
        NavigationView {
            List {
                // Секция фильмов
                if !favoritesManager.favoriteMovies.isEmpty {
                    Section(header: Text("Фильмы")) {
                        ForEach(favoritesManager.favoriteMovies) { movie in
                            NavigationLink(destination: MovieDetailView(movie: movie)) {
                                MovieRow(movie: movie)
                            }
                        }
                        .onDelete { indexSet in
                            favoritesManager.favoriteMovies.remove(atOffsets: indexSet)
                        }
                    }
                }

                // Секция событий
                if !favoritesManager.favoriteEvents.isEmpty {
                    Section(header: Text("События")) {
                        ForEach(favoritesManager.favoriteEvents) { event in
                            NavigationLink(destination: EventDetailView(event: event)) {
                                EventRow(event: event)
                            }
                        }
                        .onDelete { indexSet in
                            favoritesManager.favoriteEvents.remove(atOffsets: indexSet)
                        }
                    }
                }

                // Сообщение, если нет избранного
                if favoritesManager.favoriteMovies.isEmpty && favoritesManager.favoriteEvents.isEmpty {
                    Text("Нет избранных фильмов или событий.")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                        .multilineTextAlignment(.center)
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                }
            }
            .navigationTitle("Избранное")
            .listStyle(InsetGroupedListStyle())
        }
    }
}
