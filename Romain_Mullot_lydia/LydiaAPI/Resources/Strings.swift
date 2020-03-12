// swiftlint:disable all
// Generated using SwiftGen, by O.Halligon — https://github.com/SwiftGen/SwiftGen

import Foundation

// swiftlint:disable superfluous_disable_command
// swiftlint:disable file_length

// MARK: - Strings

// swiftlint:disable explicit_type_interface function_parameter_count identifier_name line_length
// swiftlint:disable nesting type_body_length type_name
public enum L10n {
  /// Bad Network
  public static let badNetworkMessage = L10n.tr("Localizable", "badNetworkMessage")
  /// Error
  public static let errorTitle = L10n.tr("Localizable", "errorTitle")
  /// Unavailable or lost Network.
  public static let errorUnavailableNetwork = L10n.tr("Localizable", "errorUnavailableNetwork")
  /// Network available
  public static let networkAvailableMessage = L10n.tr("Localizable", "networkAvailableMessage")
  /// No results available
  public static let noResults = L10n.tr("Localizable", "noResults")
  /// No
  public static let noTitle = L10n.tr("Localizable", "noTitle")
  /// OK
  public static let okTitle = L10n.tr("Localizable", "okTitle")
  /// Yes
  public static let yesTitle = L10n.tr("Localizable", "yesTitle")
}
// swiftlint:enable explicit_type_interface function_parameter_count identifier_name line_length
// swiftlint:enable nesting type_body_length type_name

// MARK: - Implementation Details

extension L10n {
  private static func tr(_ table: String, _ key: String, _ args: CVarArg...) -> String {
    let format = NSLocalizedString(key, tableName: table, bundle: Bundle(for: BundleToken.self), comment: "")
    return String(format: format, locale: Locale.current, arguments: args)
  }
}

private final class BundleToken {}
