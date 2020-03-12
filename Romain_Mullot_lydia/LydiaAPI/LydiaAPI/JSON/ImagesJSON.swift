//
//  ImagesJSON.swift
//  LydiaAPI
//
//  Created by Romain Mullot on 04/03/2020.
//  Copyright © 2020 Romain Mullot. All rights reserved.
//

import Foundation

public struct ImagesJSON: Codable {
    public var thumbnail: String
    public var medium: String
    public var large: String

    enum CodingKeys: String, CodingKey {
        case thumbnail
        case medium
        case large
    }

    public init(thumbnail: String = "", medium: String = "", large: String = "") {
        self.thumbnail = thumbnail
        self.medium = medium
        self.large = large
    }

    public init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        thumbnail = try values.decode(String.self, forKey: .thumbnail)
        medium = try values.decode(String.self, forKey: .medium)
        large = try values.decode(String.self, forKey: .large)
    }

}
