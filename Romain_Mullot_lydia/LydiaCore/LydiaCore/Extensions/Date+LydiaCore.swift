//
//  FormatterService.swift
//  LydiaCore
//
//  Created by Romain Mullot on 04/03/2020.
//  Copyright © 2020 Romain Mullot. All rights reserved.
//

import Foundation

extension Date {

    /// Format a date in a string used by iso 8601
    /// - Returns: A formatted string corresonding to iso 8601 configuration
    public var iso8601String: String {
        return FormatterService.sharedInstance.dateFormatterWith(key: .iso8601Date).string(from: self)
    }

    public var descriptionDateString: String {
        return FormatterService.sharedInstance.dateFormatterWith(key: .descriptionDate).string(from: self)
    }

}
