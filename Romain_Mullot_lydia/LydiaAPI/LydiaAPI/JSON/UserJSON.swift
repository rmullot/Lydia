//
//  UserJSON.swift
//  LydiaAPI
//
//  Created by Romain Mullot on 04/03/2020.
//  Copyright © 2020 Romain Mullot. All rights reserved.
//

import Foundation
import LydiaCore

public struct UserJSON: Codable {
    public var gender: String = ""
    public var email: String = ""
    public var phone: String = ""
    public var cell: String = ""
    public var imageUrls: ImagesJSON
    public var location: LocationJSON
    public var nationality: String = ""
    public var identity: String = ""
    public var birthdayDate: Date = Date()
    public var registeredDate: Date = Date()

    enum CodingKeys: String, CodingKey {
        case gender = "gender"
        case email = "email"
        case phone = "phone"
        case cell = "cell"
        case imageUrls = "picture"
        case nationality = "nat"
        case identity = "name"
        case birthdayDate = "dob"
        case registeredDate = "registered"
        case location = "location"

    }

    public init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        gender = try values.decode(String.self, forKey: .gender)
        email = try values.decode(String.self, forKey: .email)
        phone = try values.decode(String.self, forKey: .phone)
        nationality = try values.decode(String.self, forKey: .nationality)

        let identityJSON = try values.decode(IdentityJSON.self, forKey: .identity)
        identity = "\(identityJSON.title) \(identityJSON.first) \(identityJSON.last)"

        let birthdayDateString = try values.decode(UserDateJSON.self, forKey: .birthdayDate).date
        birthdayDate = birthdayDateString.iso8601Date

        let registeredDateString = try values.decode(UserDateJSON.self, forKey: .registeredDate).date
        registeredDate = registeredDateString.iso8601Date

        imageUrls = try values.decode(ImagesJSON.self, forKey: .imageUrls)
        location = try values.decode(LocationJSON.self, forKey: .location)
        cell = try values.decode(String.self, forKey: .cell)
    }

}
