//
//  Location.swift
//  LydiaBridge
//
//  Created by Romain Mullot on 09/03/2020.
//  Copyright © 2020 Romain Mullot. All rights reserved.
//

import Foundation
import LydiaCoreData

final public class Location {

    public let address: String
    public let longitude: Double
    public let latitude: Double
    public let timezone: String

    public init(address: String = "", longitude: Double = 0, latitude: Double = 0, timezone: String = "") {
        self.address = address
        self.longitude = longitude
        self.latitude = latitude
        self.timezone = timezone
    }

    init(location: LocationCoreData) {
        address = "\(location.street) \(location.city) \(location.postcode), \(location.state), \(location.country)"
        timezone = location.timezone
        longitude = location.longitude
        latitude = location.latitude
    }

}
