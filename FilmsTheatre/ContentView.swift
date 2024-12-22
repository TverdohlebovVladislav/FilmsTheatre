import SwiftUI

struct ContentView: View {
    @EnvironmentObject var favoritesManager: FavoritesManager // Доступ к избранному

    var body: some View {
        TabView {
            MainContentView()
                .tabItem {
                    Label("Главная", systemImage: "house")
                }

            FavoritesView()
                .tabItem {
                    Label("Избранное", systemImage: "heart.fill")
                }
        }
    }
}

