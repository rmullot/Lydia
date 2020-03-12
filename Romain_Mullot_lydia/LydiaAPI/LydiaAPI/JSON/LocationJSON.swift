//
//  LocationJSON.swift
//  LydiaAPI
//
//  Created by Romain Mullot on 09/03/2020.
//  Copyright © 2020 Romain Mullot. All rights reserved.
//

import Foundation

public struct LocationJSON: Codable {
    public var street: String
    public var city: String
    public var state: String
    public var country: String
    public var postcode: String
    public var timezone: String
    public var longitude: Double
    public var latitude: Double
    private var coordinates: CoordinateJSON?

    enum CodingKeys: String, CodingKey {
        case street
        case city
        case state
        case country
        case postcode
        case timezone
        case coordinates
    }

    public init(street: String = "", city: String = "", state: String = "", country: String = "", postcode: String = "", timezone: String = "", longitude: Double = 0, latitude: Double = 0) {
        self.street = street
        self.city = city
        self.state = state
        self.country = country
        self.postcode = postcode
        self.timezone = timezone
        self.longitude = longitude
        self.latitude = latitude
    }

    public init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        let streetJSON = try values.decode(StreetJSON.self, forKey: .street)
        street = "\(streetJSON.number) \(streetJSON.name)"
        let timezoneJSON = try values.decode(TimezoneJSON.self, forKey: .timezone)
        timezone = "\(timezoneJSON.offset) \(timezoneJSON.description)"
        city = try values.decode(String.self, forKey: .city)
        state = try values.decode(String.self, forKey: .state)
        country = try values.decode(String.self, forKey: .country)

        //randomuser return sometimes an Int or a String ...
        do {
            let postcodeInt = try values.decodeIfPresent(Int.self, forKey: .postcode) ?? 0
            postcode = "\(postcodeInt)"

        } catch {
            postcode = try values.decode(String.self, forKey: .postcode)
        }
        let coordinateJSON = try values.decode(CoordinateJSON.self, forKey: .coordinates)
        longitude = Double(coordinateJSON.longitude) ?? 0
        latitude = Double(coordinateJSON.latitude) ?? 0
    }

}

private struct StreetJSON: Codable {
    public var number: Int
    public var name: String

    public init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        number = try values.decode(Int.self, forKey: .number)
        name = try values.decode(String.self, forKey: .name)
    }
}

private struct CoordinateJSON: Codable {
    public var latitude: String
    public var longitude: String

    public init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        latitude = try values.decode(String.self, forKey: .latitude)
        longitude = try values.decode(String.self, forKey: .longitude)
    }
}

private struct TimezoneJSON: Codable {
    public var offset: String
    public var description: String

    public init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        offset = try values.decode(String.self, forKey: .offset)
        description = try values.decode(String.self, forKey: .description)
    }
}
