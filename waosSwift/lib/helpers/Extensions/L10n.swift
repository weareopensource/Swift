/**
* Extension
*/

extension L10n {

   static func get(_ table: String, _ key: String) -> String {
    // swiftlint:disable:next nslocalizedstring_key
    let format = NSLocalizedString(key, tableName: table, comment: "")
    return String(format: format, locale: Locale.current)
  }

}
