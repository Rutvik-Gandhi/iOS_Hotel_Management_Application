
import Foundation

struct ModelHotel : Codable {
    var id : String?
    var name : String?
    var propertyType : String?
    var starRating : Int?
    var categories : [String]?
    var cat_spanish : [String]?
    var media : [String]?
    var locationDetail : LocationDetail?
    var geoLocation : GeoLocation?
    var desc : String?
    var desc_spanish : String?
    var isFavorite : Bool?

    enum CodingKeys: String, CodingKey {

        case id = "id"
        case name = "name"
        case propertyType = "propertyType"
        case starRating = "starRating"
        case categories = "categories"
        case cat_spanish = "cat_spanish"
        case media = "media"
        case locationDetail = "locationDetail"
        case geoLocation = "geoLocation"
        case desc = "desc"
        case desc_spanish = "desc_spanish"
        case isFavorite = "isFavorite"
    }
    
    init() {
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decodeIfPresent(String.self, forKey: .id)
        name = try values.decodeIfPresent(String.self, forKey: .name)
        propertyType = try values.decodeIfPresent(String.self, forKey: .propertyType)
        starRating = try values.decodeIfPresent(Int.self, forKey: .starRating)
        categories = try values.decodeIfPresent([String].self, forKey: .categories)
        cat_spanish = try values.decodeIfPresent([String].self, forKey: .cat_spanish)
        media = try values.decodeIfPresent([String].self, forKey: .media)
        locationDetail = try values.decodeIfPresent(LocationDetail.self, forKey: .locationDetail)
        geoLocation = try values.decodeIfPresent(GeoLocation.self, forKey: .geoLocation)
        desc = try values.decodeIfPresent(String.self, forKey: .desc)
        desc_spanish = try values.decodeIfPresent(String.self, forKey: .desc_spanish)
        isFavorite  = try values.decodeIfPresent(Bool.self, forKey: .isFavorite)
    }
}

struct LocationDetail : Codable {
    var name : String?
    var countryName : String?

    enum CodingKeys: String, CodingKey {

        case name = "name"
        case countryName = "countryName"
    }
    
    init() {
        
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        name = try values.decodeIfPresent(String.self, forKey: .name)
        countryName = try values.decodeIfPresent(String.self, forKey: .countryName)
    }
}

struct GeoLocation : Codable {
    var latitude : Double?
    var longitude : Double?

    enum CodingKeys: String, CodingKey {

        case latitude = "latitude"
        case longitude = "longitude"
    }
    
    init() {
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        latitude = try values.decodeIfPresent(Double.self, forKey: .latitude)
        longitude = try values.decodeIfPresent(Double.self, forKey: .longitude)
    }
}
