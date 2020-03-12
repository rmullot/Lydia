//
//  User.swift
//  test_Romain_MULLOT
//
//  Created by Romain Mullot on 04/03/2020.
//  Copyright © 2020 Romain Mullot. All rights reserved.
//

import Foundation
import LydiaCoreData

public enum UserImageSize: String {
    case thumbnail
    case medium
    case large
}

final public class User {

    public let gender: String
    public let email: String
    public let phone: String
    public let cell: String
    public let nationality: String
    public let identity: String
    public let birthdayDate: Date
    public let registeredDate: Date
    public let imageUrls: [String: String]
    public let location: Location

    public init(gender: String = "", email: String = "", phone: String = "", cell: String = "", nationality: String = "", identity: String = "", birthdayDate: Date = Date(), registeredDate: Date = Date(), imageUrls: [String: String], location: Location) {
        self.gender = gender
        self.email = email
        self.phone = phone
        self.cell = cell
        self.nationality = nationality
        self.identity = identity
        self.birthdayDate = birthdayDate
        self.registeredDate = registeredDate
        self.imageUrls = imageUrls
        self.location = location
    }

    init(user: UserCoreData) {
        gender = user.gender
        email = user.email
        phone = user.phone
        cell = user.cell
        identity = user.identity
        nationality = user.nationality
        birthdayDate = user.birthdayDate
        registeredDate = user.registeredDate
        if let images = user.images {
            var imageTmpUrls: [String: String] = [:]
            images.forEach { (imageCoreData) in
                imageTmpUrls[imageCoreData.type] = imageCoreData.url
            }
            imageUrls = imageTmpUrls
        } else {
            imageUrls = [:]
        }
        location = Location(location: user.location)
    }

}
