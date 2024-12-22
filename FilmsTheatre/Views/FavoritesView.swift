import SwiftUI

struct FavoritesView: View {
    @EnvironmentObject var favoritesManager: FavoritesManager

    var body: some View {
        NavigationView {
            List {
                ForEach(favoritesManager.favorites) { movie in
                    NavigationLink(destination: MovieDetailView(movie: movie)) {
                        MovieRow(movie: movie)
                    }
                }
                .onDelete { indexSet in
                    favoritesManager.favorites.remove(atOffsets: indexSet)
                }
            }
            .navigationTitle("Избранное")
        }
    }
}

