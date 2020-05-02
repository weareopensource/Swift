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
  /// this is the first page of the application, it will only be affixed once after installation. We call it onBoarding. We will not be able to recover them.
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
  /// Blog
  internal static let userBlog = L10n.tr("Localizable", "user_blog")
  /// Contact us
  internal static let userContact = L10n.tr("Localizable", "user_contact")
  /// Request my data
  internal static let userData = L10n.tr("Localizable", "user_data")
  /// Delete account and data
  internal static let userDelete = L10n.tr("Localizable", "user_delete")
  /// Edit
  internal static let userEdit = L10n.tr("Localizable", "user_edit")
  /// Firstname
  internal static let userEditFirstname = L10n.tr("Localizable", "user_edit_firstname")
  /// iPhone Gallery
  internal static let userEditImage = L10n.tr("Localizable", "user_edit_image")
  /// Gravatar
  internal static let userEditImageGravatar = L10n.tr("Localizable", "user_edit_image_gravatar")
  /// Lastname
  internal static let userEditLastname = L10n.tr("Localizable", "user_edit_lastname")
  /// Email
  internal static let userEditMail = L10n.tr("Localizable", "user_edit_mail")
  /// Account
  internal static let userEditSection = L10n.tr("Localizable", "user_edit_section")
  /// Profile picture
  internal static let userEditSectionImage = L10n.tr("Localizable", "user_edit_section_image")
  /// You must configure mail on your phone for this.
  internal static let userErrorMail = L10n.tr("Localizable", "user_error_mail")
  /// Help
  internal static let userHelp = L10n.tr("Localizable", "user_help")
  /// Logout
  internal static let userLogout = L10n.tr("Localizable", "user_logout")
  /// We will send you all of your data by email. Do not hesitate to write to us if necessary.
  internal static let userModalConfirmationDataMessage = L10n.tr("Localizable", "user_modal_confirmation_data_message")
  /// Are you sure? your account and all your data will be deleted.
  internal static let userModalConfirmationDeleteMessage = L10n.tr("Localizable", "user_modal_confirmation_delete_message")
  /// Privacy policy
  internal static let userPrivacyPolicy = L10n.tr("Localizable", "user_privacy_policy")
  /// Report a bug
  internal static let userReport = L10n.tr("Localizable", "user_report")
  /// Other
  internal static let userSectionActions = L10n.tr("Localizable", "user_section_actions")
  /// Waos
  internal static let userSectionApp = L10n.tr("Localizable", "user_section_app")
  /// Contact
  internal static let userSectionContact = L10n.tr("Localizable", "user_section_contact")
  /// Information
  internal static let userSectionInformation = L10n.tr("Localizable", "user_section_information")
  /// Terms of service
  internal static let userTermsOfService = L10n.tr("Localizable", "user_terms_of_service")
  /// Profile
  internal static let userTitle = L10n.tr("Localizable", "user_title")
  /// Us ?
  internal static let userUs = L10n.tr("Localizable", "user_us")
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
