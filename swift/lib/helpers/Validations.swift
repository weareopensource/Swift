/**
 * functions
 */

public struct AlphaNumValidationPattern: ValidationPattern {
    public var pattern: String {
        return "[a-zA-Z0-9]*"
    }
}
