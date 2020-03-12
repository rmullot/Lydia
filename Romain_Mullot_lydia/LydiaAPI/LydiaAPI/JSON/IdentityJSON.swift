//
//  IdentityJSON.swift
//  LydiaAPI
//
//  Created by Romain Mullot on 06/03/2020.
//  Copyright © 2020 Romain Mullot. All rights reserved.
//

import Foundation

public struct IdentityJSON: Codable {
    public var title: String
    public var first: String
    public var last: String

    enum CodingKeys: String, CodingKey {
        case title
        case first
        case last
    }

    public init(title: String = "", first: String = "", last: String = "") {
        self.title = title
        self.first = first
        self.last = last
    }

    public init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        title = try values.decode(String.self, forKey: .title)
        first = try values.decode(String.self, forKey: .first)
        last = try values.decode(String.self, forKey: .last)
    }

}
