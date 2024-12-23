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

 
