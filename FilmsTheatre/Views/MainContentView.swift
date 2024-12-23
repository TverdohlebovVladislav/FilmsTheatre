import SwiftUI

struct MainContentView: View {
    @State private var movies: [Movie] = [] // Список фильмов
    @State private var events: [Event] = [] // Список театральных мероприятий
    @State private var favorites: [Movie] = []
    
    private let movieService = MovieService()
    private let eventService = EventService()

    var body: some View {
        NavigationView {
            ScrollView(.vertical, showsIndicators: false) {
                VStack(alignment: .leading, spacing: 20) {
                    moviesSection
                    allMoviesButton
                    eventsSection
                    allEventsButton // Добавляем кнопку для спектаклей
                }
            }
            .navigationTitle("Афиша")
            .onAppear {
                loadContent()
            }
        }
    }

    // Раздел фильмов
    private var moviesSection: some View {
        VStack(alignment: .leading) {
            Text("Популярные фильмы")
                .font(.title)
                .bold()
                .padding(.horizontal)
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 16) {
                    ForEach(movies) { movie in
                        NavigationLink(destination: MovieDetailView(movie: movie)) {
                            movieCard(movie)
                        }
                    }
                }
                .padding(.horizontal)
            }
        }
    }

    // Кнопка "Смотреть все фильмы"
    private var allMoviesButton: some View {
        NavigationLink(destination: MovieListView()) {
            Text("Смотреть все фильмы")
                .font(.headline)
                .padding()
                .frame(maxWidth: .infinity)
                .background(Color.blue)
                .foregroundColor(.white)
                .cornerRadius(10)
                .padding(.horizontal)
        }
    }

    // Раздел мероприятий
    private var eventsSection: some View {
        VStack(alignment: .leading) {
            Text("Театральные мероприятия")
                .font(.title)
                .bold()
                .padding(.horizontal)
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 16) {
                    ForEach(events, id: \.id) { event in
                        eventCard(event)
                    }
                }
                .padding(.horizontal)
            }
        }
    }

    // Кнопка "Смотреть все спектакли"
    private var allEventsButton: some View {
        NavigationLink(destination: EventListView(events: events)) {
            Text("Смотреть все спектакли")
                .font(.headline)
                .padding()
                .frame(maxWidth: .infinity)
                .background(Color.blue)
                .foregroundColor(.white)
                .cornerRadius(10)
                .padding(.horizontal)
        }
    }

    // Карточка фильма
    private func movieCard(_ movie: Movie) -> some View {
        VStack {
            AsyncImage(url: URL(string: movie.fullImageUrl)) { image in
                image.resizable().aspectRatio(contentMode: .fill)
            } placeholder: {
                Color.gray
            }
            .frame(width: 150, height: 225)
            .cornerRadius(10)
            
            Text(movie.title)
                .font(.subheadline)
                .lineLimit(1)
                .frame(maxWidth: 150)
        }
    }

    // Карточка мероприятия
    private func eventCard(_ event: Event) -> some View {
        NavigationLink(destination: EventDetailView(event: event)) {
            VStack {
                AsyncImage(url: URL(string: event.imageUrl ?? "")) { image in
                    image.resizable().aspectRatio(contentMode: .fill)
                } placeholder: {
                    Color.gray
                }
                .frame(width: 150, height: 225)
                .cornerRadius(10)
                
                Text(event.name)
                    .font(.caption)
                    .lineLimit(1)
                    .frame(maxWidth: 150)

                if let date = event.startDate {
                    Text(date)
                        .font(.caption2)
                        .foregroundColor(.gray)
                }
            }
        }
    }
    
    // Загрузка данных
    private func loadContent() {
        movieService.fetchPopularMovies { fetchedMovies in
            if let fetchedMovies = fetchedMovies {
                DispatchQueue.main.async {
                    self.movies = fetchedMovies
                }
            }
        }
        
        eventService.fetchTheaterEvents { fetchedEvents in
            if let fetchedEvents = fetchedEvents {
                DispatchQueue.main.async {
                    self.events = fetchedEvents
                }
            }
        }
    }
}
