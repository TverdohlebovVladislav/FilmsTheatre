import SwiftUI

struct EventListView: View {
    let events: [Event] // Список событий

    var body: some View {
        NavigationView {
            List(events, id: \.id) { event in
                NavigationLink(destination: EventDetailView(event: event)) {
                    EventRow(event: event)
                }
            }
            .navigationTitle("События")
        }
    }
}

struct EventRow: View {
    let event: Event

    var body: some View {
        HStack {
            if let imageUrl = event.imageUrl, let url = URL(string: imageUrl) {
                AsyncImage(url: url) { image in
                    image
                        .resizable()
                        .scaledToFill()
                        .frame(width: 80, height: 80)
                        .clipped()
                        .cornerRadius(10)
                } placeholder: {
                    Color.gray
                        .frame(width: 80, height: 80)
                        .cornerRadius(10)
                }
            }

            VStack(alignment: .leading) {
                Text(event.name)
                    .font(.headline)
                if let startDate = event.startDate {
                    Text(startDate)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
            }
        }
    }
}
