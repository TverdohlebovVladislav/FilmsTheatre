import Foundation

struct Event: Decodable {
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
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        id = try container.decode(String.self, forKey: .id)
        name = try container.decode(String.self, forKey: .name)
        eventUrl = try container.decodeIfPresent(String.self, forKey: .url)
        
        // Decode first image URL
        if let images = try? container.decodeIfPresent([Image].self, forKey: .images),
           let firstImage = images.first {
            imageUrl = firstImage.url
        } else {
            imageUrl = nil
        }
        
        // Decode start date
        if let dates = try? container.nestedContainer(keyedBy: DatesKeys.self, forKey: .dates),
           let start = try? dates.nestedContainer(keyedBy: StartKeys.self, forKey: .start) {
            startDate = try start.decodeIfPresent(String.self, forKey: .localDate)
        } else {
            startDate = nil
        }
        
        // Decode venue name
        if let embedded = try? container.nestedContainer(keyedBy: EmbeddedKeys.self, forKey: .embedded),
           let venues = try? embedded.decodeIfPresent([Venue].self, forKey: .venues),
           let firstVenue = venues.first {
            venueName = firstVenue.name
        } else {
            venueName = nil
        }
    }
}

struct Venue: Decodable {
    let name: String
}

struct Image: Decodable {
    let url: String
}

