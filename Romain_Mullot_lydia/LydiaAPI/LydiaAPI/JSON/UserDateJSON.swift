//
//  UserDateJSON.swift
//  LydiaAPI
//
//  Created by Romain Mullot on 06/03/2020.
//  Copyright © 2020 Romain Mullot. All rights reserved.
//

import Foundation

public struct UserDateJSON: Codable {
    public var date: String
    public var age: Int

    enum CodingKeys: String, CodingKey {
        case date
        case age
    }

    public init(date: String = "", age: Int = 0) {
        self.date = date
        self.age = age
    }

    public init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        date = try values.decode(String.self, forKey: .date)
        age = try values.decode(Int.self, forKey: .age)
    }

}
