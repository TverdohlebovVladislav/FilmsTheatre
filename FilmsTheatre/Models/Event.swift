import Foundation

struct Event: Decodable, Encodable { // Добавлен протокол Encodable
    let id: String
    let name: String
    let imageUrl: String?
    let startDate: String?
    let eventUrl: String?
    let venueName: String? // Добавляем название места проведения
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case images
        case dates
        case url
        case embedded = "_embedded"
    }
    
    enum EmbeddedKeys: String, CodingKey {
        case venues
    }
    
    enum VenueKeys: String, CodingKey {
        case name
    }
    
    enum DatesKeys: String, CodingKey {
        case start
    }
    
    enum StartKeys: String, CodingKey {
        case localDate
    }
    
    // Преобразование данных из JSON
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        id = try container.decode(String.self, forKey: .id)
        name = try container.decode(String.self, forKey: .name)
        eventUrl = try container.decodeIfPresent(String.self, forKey: .url)
        
        // Декодируем URL изображения
        if let images = try? container.decodeIfPresent([Image].self, forKey: .images),
           let firstImage = images.first {
            imageUrl = firstImage.url
        } else {
            imageUrl = nil
        }
        
        // Декодируем дату начала
        if let dates = try? container.nestedContainer(keyedBy: DatesKeys.self, forKey: .dates),
           let start = try? dates.nestedContainer(keyedBy: StartKeys.self, forKey: .start) {
            startDate = try start.decodeIfPresent(String.self, forKey: .localDate)
        } else {
            startDate = nil
        }
        
        // Декодируем название места проведения
        if let embedded = try? container.nestedContainer(keyedBy: EmbeddedKeys.self, forKey: .embedded),
           let venues = try? embedded.decodeIfPresent([Venue].self, forKey: .venues),
           let firstVenue = venues.first {
            venueName = firstVenue.name
        } else {
            venueName = nil
        }
    }
    
    // Кодирование данных в JSON
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(name, forKey: .name)
        try container.encodeIfPresent(eventUrl, forKey: .url)
        try container.encodeIfPresent(imageUrl, forKey: .images)
        try container.encodeIfPresent(startDate, forKey: .dates)
    }
}

struct Venue: Decodable, Encodable {
    let name: String
}

struct Image: Decodable, Encodable {
    let url: String
}
