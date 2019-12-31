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
    var roles: [String]
    var password: String?

    init(id: String = "", firstName: String = "", lastName: String = "", email: String = "", roles: [String] = [], password: String? = "") {
        self.id = id
        self.firstName = firstName
        self.lastName = lastName
        self.email = email
        self.roles = roles
        self.password = password
    }
}

extension User: Codable {
    enum UserCodingKeys: String, CodingKey {
        case id
        case firstName
        case lastName
        case email
        case roles
        case password
    }
}

extension User: Validatable {

    enum Validators: String {
        case firstname = "Wrong firstname format"
        case lastname = "Wrong lastname format"
        case email = "Wrong email format"
        case password = "Wrong password format (8 char, 1 number, 1 special)"
    }

    func validate(_ validator: Validators) -> ValidationResult {
        // default error
        let err = CustomError(message: "\(validator)", description: validator.rawValue, type: "ValidationError")
        // rules
        let emails = ValidationRulePattern(pattern: EmailValidationPattern.standard, error: err)

        var names = ValidationRuleSet<String>()
        names.add(rule: ValidationRulePattern(pattern: AlphaNumValidationPattern(), error: err))
        names.add(rule: ValidationRuleLength(min: 1, error: err))
        names.add(rule: ValidationRuleLength(max: 30, error: err))

        var passwords = ValidationRuleSet<String>()
        passwords.add(rule: ValidationRulePattern(pattern: PasswordValidationPattern(), error: err))
        passwords.add(rule: ValidationRuleLength(min: 8, error: err))
        passwords.add(rule: ValidationRuleLength(max: 128, error: err))

        // validator
        switch validator {
        case .firstname:
            return firstName.validate(rules: names)
        case .lastname:
            return lastName.validate(rules: names)
        case .email:
            return email.validate(rule: emails)
        case .password:
            return password?.validate(rules: passwords) ?? ValidationResult.valid
        }
    }
}
