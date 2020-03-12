//
//  ResultJSON.swift
//  LydiaAPI
//
//  Created by Romain Mullot on 04/03/2020.
//  Copyright © 2020 Romain Mullot. All rights reserved.
//

import Foundation

public struct ResultJSON: Codable {
    public var users: [UserJSON]

    enum CodingKeys: String, CodingKey {
           case users = "results"
    }

    public init(users: [UserJSON] = []) {
        self.users = users
    }

    public init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        users = try values.decode([UserJSON].self, forKey: .users)
    }

}
