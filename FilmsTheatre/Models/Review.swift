struct Review: Identifiable, Decodable {
    let id: String
    let author: String
    let content: String
}

struct ReviewsResponse: Decodable {
    let results: [Review]
}
