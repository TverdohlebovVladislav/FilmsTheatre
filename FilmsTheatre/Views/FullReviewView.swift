import SwiftUI

struct FullReviewView: View {
    let review: Review

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                Text(review.author)
                    .font(.headline)
                    .foregroundColor(.blue)

                Text(review.content)
                    .font(.body)
            }
            .padding()
        }
        .navigationTitle("Полный отзыв")
    }
}
