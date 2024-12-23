import SwiftUI

struct EventListView: View {
    var events: [Event] // Список всех событий
    @State private var filteredEvents: [Event] = [] // Отфильтрованные события
    @State private var selectedVenue: String = "All" // Выбранный театр
    @State private var venues: [String] = [] // Список театров
    @State private var isLoading = false // Флаг загрузки

    var body: some View {
        NavigationView {
            VStack {
                // Фильтр по театрам
                Picker("Выберите театр", selection: $selectedVenue) {
                    Text("Все театры").tag("All")
                    ForEach(venues, id: \.self) { venue in
                        Text(venue).tag(venue)
                    }
                }
                .pickerStyle(MenuPickerStyle())
                .padding()
                .onChange(of: selectedVenue) { _ in
                    filterEvents(for: selectedVenue)
                }

                // Список событий
                List(filteredEvents, id: \.id) { event in
                    NavigationLink(destination: EventDetailView(event: event)) {
                        EventRow(event: event)
                    }
                }
                .navigationTitle("События")
                .onAppear {
                    loadVenues() // Загружаем театры при первом запуске
                    filterEvents(for: selectedVenue) // Фильтруем события
                }

                if isLoading {
                    ProgressView()
                        .padding()
                }
            }
        }
    }

    private func loadVenues() { 
        let allVenues = Set(events.compactMap { $0.venueName })
        venues = Array(allVenues).sorted()
    }

    private func filterEvents(for venue: String) {
        if venue == "All" {
            filteredEvents = events
        } else {
            filteredEvents = events.filter { event in
                event.venueName == venue
            }
        }
    }
}
