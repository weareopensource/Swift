// swiftlint:disable all
// Generated using SwiftGen — https://github.com/SwiftGen/SwiftGen

import Foundation

// swiftlint:disable superfluous_disable_command
// swiftlint:disable file_length

// MARK: - Strings

// swiftlint:disable explicit_type_interface function_parameter_count identifier_name line_length
// swiftlint:disable nesting type_body_length type_name
internal enum L10n {
  /// Firstname
  internal static let authFirstname = L10n.tr("Localizable", "auth_firstname")
  /// Lastname
  internal static let authLastname = L10n.tr("Localizable", "auth_lastname")
  /// Email
  internal static let authMail = L10n.tr("Localizable", "auth_mail")
  /// Password
  internal static let authPassword = L10n.tr("Localizable", "auth_password")
  /// Sign In
  internal static let authSignInTitle = L10n.tr("Localizable", "authSignIn_title")
  /// Sign Up
  internal static let authSignUpTitle = L10n.tr("Localizable", "authSignUp_title")
  /// Cancel
  internal static let modalConfirmationCancel = L10n.tr("Localizable", "modal_confirmation_cancel")
  /// are you sure ?
  internal static let modalConfirmationMessage = L10n.tr("Localizable", "modal_confirmation_message")
  /// Ok
  internal static let modalConfirmationOk = L10n.tr("Localizable", "modal_confirmation_ok")
  /// Remove
  internal static let modalConfirmationRemove = L10n.tr("Localizable", "modal_confirmation_remove")
  /// this is the first page of the application, it will only be affixed once after installation. We call it onBoarding.
  internal static let onBoardingIntroduction = L10n.tr("Localizable", "onBoarding_introduction")
  /// Welcome !
  internal static let onBoardingTitle = L10n.tr("Localizable", "onBoarding_title")
  /// I'm in !
  internal static let onBoardingValidation = L10n.tr("Localizable", "onBoarding_validation")
  /// Example
  internal static let secondTitle = L10n.tr("Localizable", "second_title")
  /// Tasks
  internal static let tasksTitle = L10n.tr("Localizable", "tasks_title")
  /// About
  internal static let userAbout = L10n.tr("Localizable", "user_about")
  /// Contact us
  internal static let userContact = L10n.tr("Localizable", "user_contact")
  /// Request my data
  internal static let userData = L10n.tr("Localizable", "user_data")
  /// Delete account
  internal static let userDelete = L10n.tr("Localizable", "user_delete")
  /// Edit
  internal static let userEdit = L10n.tr("Localizable", "user_edit")
  /// Firstname
  internal static let userEditFirstname = L10n.tr("Localizable", "user_edit_firstname")
  /// Lastname
  internal static let userEditLastname = L10n.tr("Localizable", "user_edit_lastname")
  /// Email
  internal static let userEditMail = L10n.tr("Localizable", "user_edit_mail")
  /// Account
  internal static let userEditSection = L10n.tr("Localizable", "user_edit_section")
  /// You must configure mail on your phone for this.
  internal static let userErrorMail = L10n.tr("Localizable", "user_error_mail")
  /// Help
  internal static let userHelp = L10n.tr("Localizable", "user_help")
  /// Logout
  internal static let userLogout = L10n.tr("Localizable", "user_logout")
  /// Privacy policy
  internal static let userPrivacyPolicy = L10n.tr("Localizable", "user_privacy_policy")
  /// Report a bug
  internal static let userReport = L10n.tr("Localizable", "user_report")
  /// Actions
  internal static let userSectionActions = L10n.tr("Localizable", "user_section_actions")
  /// Waos
  internal static let userSectionApp = L10n.tr("Localizable", "user_section_app")
  /// Waos
  internal static let userSectionContact = L10n.tr("Localizable", "user_section_contact")
  /// Terms of service
  internal static let userTermsOfService = L10n.tr("Localizable", "user_terms_of_service")
  /// Profile
  internal static let userTitle = L10n.tr("Localizable", "user_title")
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
