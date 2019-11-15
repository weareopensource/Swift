/**
 * Model Me Response
 */

struct UserResponse {
    var data: User
}
extension UserResponse: Codable {
    enum MeResponseCodingKeys: String, CodingKey {
        case data
    }
}

/**
 * Model User
 */

struct User {
    var id: String?
    var firstName: String
    var lastName: String
    var email: String
    var roles: [String]?
}

extension User: Codable {
    enum UserCodingKeys: String, CodingKey {
        case id
        case firstName
        case lastName
        case email
        case roles
    }
}

extension User: Validatable {

    enum Validators: String {
        case firstname = "Wrong firstname format"
        case lastname = "Wrong lastname format"
        case email = "Wrong email format"
    }

    func validate(_ validator: Validators) -> ValidationResult {
        // default error
        let err = CustomError(message: "\(validator)", description: validator.rawValue, type: "ValidationError")
        // rules
        let ruleEmail = ValidationRulePattern(pattern: EmailValidationPattern.standard, error: err)
        let ruleMinLength = ValidationRuleLength(min: 1, error: err)
        let ruleMaxLength = ValidationRuleLength(max: 30, error: err)
        let alphaNum = ValidationRulePattern(pattern: AlphaNumValidationPattern(), error: err)

        var names = ValidationRuleSet<String>()
        names.add(rule: alphaNum)
        names.add(rule: ruleMinLength)
        names.add(rule: ruleMaxLength)

        // validator
        switch validator {
        case .firstname:
            return firstName.validate(rules: names)
        case .lastname:
            return lastName.validate(rules: names)
        case .email:
            return email.validate(rule: ruleEmail)
        }
    }
}
