import Foundation


class MovieService {
    private let apiKey = Config.tmdbApiKey
    private let baseURL = "https://api.themoviedb.org/3"
    
    func fetchPopularMovies(completion: @escaping ([Movie]?) -> Void) {
        let urlString = "\(baseURL)/movie/popular?api_key=\(apiKey)&language=en-US&page=1"
        guard let url = URL(string: urlString) else {
            completion(nil)
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, _, error in
            if let error = error {
                print("Ошибка загрузки: \(error)")
                completion(nil)
                return
            }
            
            guard let data = data else {
                completion(nil)
                return
            }
            
            do {
                let response = try JSONDecoder().decode(MovieResponse.self, from: data)
                completion(response.results)
            } catch {
                print("Ошибка декодирования: \(error)")
                completion(nil)
            }
        }.resume()
    }
}

