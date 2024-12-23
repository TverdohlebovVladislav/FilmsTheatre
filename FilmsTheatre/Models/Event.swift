import Foundation

struct Event: Identifiable, Codable {
    let id: String
    let name: String
    let imageUrl: String?
    let startDate: String?
    let eventUrl: String? 
    let venueName: String?
    
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
         
        if let images = try? container.decodeIfPresent([Image].self, forKey: .images),
           let firstImage = images.first {
            imageUrl = firstImage.url
        } else {
            imageUrl = nil
        }
         
        if let dates = try? container.nestedContainer(keyedBy: DatesKeys.self, forKey: .dates),
           let start = try? dates.nestedContainer(keyedBy: StartKeys.self, forKey: .start) {
            startDate = try start.decodeIfPresent(String.self, forKey: .localDate)
        } else {
            startDate = nil
        }
         
        if let embedded = try? container.nestedContainer(keyedBy: EmbeddedKeys.self, forKey: .embedded),
           let venues = try? embedded.decodeIfPresent([Venue].self, forKey: .venues),
           let firstVenue = venues.first {
            venueName = firstVenue.name
        } else {
            venueName = nil
        }
          
    }
 
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(name, forKey: .name)
        try container.encodeIfPresent(eventUrl, forKey: .url)
         
        if let imageUrl = imageUrl {
            try container.encode([Image(url: imageUrl)], forKey: .images)
        }
         
        if let startDate = startDate {
            try container.encode([DateInfo(localDate: startDate)], forKey: .dates)
        }
    }
}

struct Venue: Codable {
    let name: String
}

struct Image: Codable {
    let url: String
}

struct DateInfo: Codable {
    let localDate: String
}
