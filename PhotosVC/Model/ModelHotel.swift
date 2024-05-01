
import Foundation

struct ModelHotel : Codable {
	let id : String?
	let name : String?
	let propertyType : String?
	let starRating : Int?
	let categories : [String]?
	let media : [Media]?
	let locationDetail : LocationDetail?
	let geoLocation : GeoLocation?
	let desc : String?

	enum CodingKeys: String, CodingKey {

		case id = "id"
		case name = "name"
		case propertyType = "propertyType"
		case starRating = "starRating"
		case categories = "categories"
		case media = "media"
		case locationDetail = "locationDetail"
		case geoLocation = "geoLocation"
		case desc = "desc"
	}

	init(from decoder: Decoder) throws {
		let values = try decoder.container(keyedBy: CodingKeys.self)
		id = try values.decodeIfPresent(String.self, forKey: .id)
		name = try values.decodeIfPresent(String.self, forKey: .name)
		propertyType = try values.decodeIfPresent(String.self, forKey: .propertyType)
		starRating = try values.decodeIfPresent(Int.self, forKey: .starRating)
		categories = try values.decodeIfPresent([String].self, forKey: .categories)
		media = try values.decodeIfPresent([Media].self, forKey: .media)
		locationDetail = try values.decodeIfPresent(LocationDetail.self, forKey: .locationDetail)
		geoLocation = try values.decodeIfPresent(GeoLocation.self, forKey: .geoLocation)
		desc = try values.decodeIfPresent(String.self, forKey: .desc)
	}

}

struct Media : Codable {
    let url : String?
    let mediaType : String?

    enum CodingKeys: String, CodingKey {

        case url = "url"
        case mediaType = "mediaType"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        url = try values.decodeIfPresent(String.self, forKey: .url)
        mediaType = try values.decodeIfPresent(String.self, forKey: .mediaType)
    }
}

struct LocationDetail : Codable {
    let id : String?
    let name : String?
    let type : String?
    let countryId : String?
    let countryName : String?

    enum CodingKeys: String, CodingKey {

        case id = "id"
        case name = "name"
        case type = "type"
        case countryId = "countryId"
        case countryName = "countryName"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decodeIfPresent(String.self, forKey: .id)
        name = try values.decodeIfPresent(String.self, forKey: .name)
        type = try values.decodeIfPresent(String.self, forKey: .type)
        countryId = try values.decodeIfPresent(String.self, forKey: .countryId)
        countryName = try values.decodeIfPresent(String.self, forKey: .countryName)
    }
}

struct GeoLocation : Codable {
    let latitude : Double?
    let longitude : Double?

    enum CodingKeys: String, CodingKey {

        case latitude = "latitude"
        case longitude = "longitude"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        latitude = try values.decodeIfPresent(Double.self, forKey: .latitude)
        longitude = try values.decodeIfPresent(Double.self, forKey: .longitude)
    }
}
