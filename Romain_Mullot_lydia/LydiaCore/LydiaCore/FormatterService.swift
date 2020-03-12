//
//  FormatterService.swift
//  LydiaCore
//
//  Created by Romain Mullot on 04/03/2020.
//  Copyright © 2020 Romain Mullot. All rights reserved.
//

import Foundation

protocol FormatterServiceProtocol {
    func rebootCache()
    func dateFormatterWith(key: FormatterKey) -> DateFormatter
}

public enum FormatterKey: String {
    case iso8601Date
    case descriptionDate
}

public final class FormatterService: FormatterServiceProtocol {

    public static let sharedInstance = FormatterService()

    // MARK: Properties

    private var cachedFormatters = [String: Formatter]()

    // MARK: Initialization

    private init() {
        NotificationCenter.default.addObserver(self, selector: #selector(FormatterService.rebootCache), name: NSLocale.currentLocaleDidChangeNotification, object: nil)
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    // MARK: Cache
    @objc
    public func rebootCache() {
        cachedFormatters.removeAll()
    }

    // MARK: Getting formatters

    public func dateFormatterWith(key: FormatterKey) -> DateFormatter {

        if let cachedDateFormatter = cachedFormatters[key.rawValue] as? DateFormatter {
            return cachedDateFormatter
        } else {
            guard let newDateFormatter = getFormatter(key: key) as? DateFormatter else {
                return DateFormatter()
            }
            cachedFormatters[key.rawValue] = newDateFormatter
            return newDateFormatter
        }
    }

}

private extension FormatterService {

    func getFormatter(key: FormatterKey) -> Formatter {
        switch key {
        case .iso8601Date:
            let formatter = DateFormatter()
            formatter.locale = Locale(identifier: "en_US_POSIX")
            formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
            return formatter
        case .descriptionDate:
            let formatter = DateFormatter()
            formatter.locale = Locale(identifier: "en_US_POSIX")
            formatter.dateFormat = "yyyy MMM EEEE HH:mm"
            return formatter
        }
    }
}
