import SwiftUI

@main
struct FilmsTheatreApp: App {
    let persistenceController = PersistenceController.shared

    @StateObject private var favoritesManager = FavoritesManager() // Единое хранилище
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
                .environmentObject(favoritesManager) // Передаем в окружение
        }
    }
}
