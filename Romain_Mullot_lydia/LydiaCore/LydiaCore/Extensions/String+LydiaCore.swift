//
//  FormatterService.swift
//  LydiaCore
//
//  Created by Romain Mullot on 04/03/2020.
//  Copyright © 2020 Romain Mullot. All rights reserved.
//

import Foundation
import UIKit

public extension String {

    /// Return a boolean checking if the string is not empty
    var isNotEmpty: Bool {
        return !isEmpty
    }

    func isUrl(_ completionHandler: @escaping (Bool, URL?) -> Void ) {
       guard self.isNotEmpty, let url = URL(string: self) else {
         return completionHandler(false, nil)
       }
       return completionHandler(UIApplication.shared.canOpenURL(url), url)
     }

    /// Return a converted iso8601 Date
    var iso8601Date: Date {
        guard isNotEmpty else { return Date() }
        guard let date = FormatterService.sharedInstance.dateFormatterWith(key: .iso8601Date).date(from: self) else { return Date() }
        return date
    }

}
