import SwiftUI

struct EventRow: View {
    let event: Event

    var body: some View {
        HStack {
            AsyncImage(url: URL(string: event.imageUrl ?? "")) { image in
                image.resizable().aspectRatio(contentMode: .fill)
            } placeholder: {
                Color.gray
            }
            .frame(width: 50, height: 75)
            .cornerRadius(5)

            VStack(alignment: .leading) {
                Text(event.name)
                    .font(.headline)
                if let date = event.startDate {
                    Text(date)
                        .font(.subheadline)
                        .foregroundColor(.gray)
                }
            }
        }
    }
}
