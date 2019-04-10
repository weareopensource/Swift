// swiftlint:disable all
// Generated using SwiftGen — https://github.com/SwiftGen/SwiftGen

import Foundation

// swiftlint:disable superfluous_disable_command
// swiftlint:disable file_length

// MARK: - Strings

// swiftlint:disable explicit_type_interface function_parameter_count identifier_name line_length
// swiftlint:disable nesting type_body_length type_name
internal enum L10n {
  /// title 1
  internal static let firstTitle = L10n.tr("Localizable", "first_title")
  /// this is the first page of the application, it will only be affixed once after installation. We call it onBoarding.
  internal static let onBoardingIntroduction = L10n.tr("Localizable", "onBoarding_introduction")
  /// onBoarding
  internal static let onBoardingTitle = L10n.tr("Localizable", "onBoarding_title")
  /// I'm in !
  internal static let onBoardingValidation = L10n.tr("Localizable", "onBoarding_validation")
  /// title 2
  internal static let secondTitle = L10n.tr("Localizable", "second_title")
}
// swiftlint:enable explicit_type_interface function_parameter_count identifier_name line_length
// swiftlint:enable nesting type_body_length type_name

// MARK: - Implementation Details

extension L10n {
  private static func tr(_ table: String, _ key: String, _ args: CVarArg...) -> String {
    // swiftlint:disable:next nslocalizedstring_key
    let format = NSLocalizedString(key, tableName: table, bundle: Bundle(for: BundleToken.self), comment: "")
    return String(format: format, locale: Locale.current, arguments: args)
  }
}

private final class BundleToken {}
