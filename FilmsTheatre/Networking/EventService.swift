import Foundation

class EventService {
    private let apiKey = Config.theatreApiKey
    private let baseURL = "https://app.ticketmaster.com/discovery/v2"

    func fetchTheaterEvents(completion: @escaping ([Event]?) -> Void) {
        let urlString = "\(baseURL)/events.json?keyword=theatre&apikey=\(apiKey)"
        
        guard let url = URL(string: urlString) else {
            print("Ошибка: Неверный URL")
            completion(nil)
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                print("Ошибка сети: \(error.localizedDescription)")
                completion(nil)
                return
            }
            
            guard let data = data else {
                print("Ошибка: Нет данных")
                completion(nil)
                return
            }
            
            do {
                let response = try JSONDecoder().decode(EventResponse.self, from: data)
                
                // Фильтруем уникальные мероприятия
                let uniqueEvents = self.filterUniqueEvents(events: response.embedded?.events ?? [])
                completion(uniqueEvents)
                
            } catch {
                print("Ошибка декодирования: \(error.localizedDescription)")
                completion(nil)
            }
        }.resume()
    }
    
    private func filterUniqueEvents(events: [Event]) -> [Event] {
        var groupedEvents = [String: Event]() // Храним уникальные события по имени
        
        for event in events {
            let eventName = event.name
            
            // Проверяем, есть ли уже событие с таким именем
            if let existingEvent = groupedEvents[eventName] {
                // Сравниваем даты и оставляем ближайшую
                if let existingDate = existingEvent.startDate,
                   let newDate = event.startDate,
                   newDate < existingDate {
                    groupedEvents[eventName] = event
                }
            } else {
                // Если событие с таким именем ещё не добавлено
                groupedEvents[eventName] = event
            }
        }
        
        return Array(groupedEvents.values) // Возвращаем уникальные события
    }
}

struct EventResponse: Decodable {
    let embedded: EmbeddedEvents?
    
    enum CodingKeys: String, CodingKey {
        case embedded = "_embedded"
    }
}

struct EmbeddedEvents: Decodable {
    let events: [Event]
}
