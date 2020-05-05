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
    var password: String?
    var avatar: String
    var bio: String?

    init(firstName: String = "", lastName: String = "", email: String = "", roles: [String]? = [], password: String? = "", avatar: String = "", bio: String? = "") {
        self.firstName = firstName
        self.lastName = lastName
        self.email = email
        self.roles = roles
        self.password = password
        self.avatar = avatar
        self.bio = bio
    }
}

extension User: Hashable, Codable {
    enum UserCodingKeys: String, CodingKey {
        case id
        case firstName
        case lastName
        case email
        case roles
        case password
        case avatar
        case bio
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: UserCodingKeys.self)

        id = try container.decodeIfPresent(String.self, forKey: .id)
        firstName = try container.decode(String.self, forKey: .firstName)
        lastName = try container.decode(String.self, forKey: .lastName)
        email = try container.decode(String.self, forKey: .email)
        roles = try container.decodeIfPresent([String].self, forKey: .roles)
        password = try container.decodeIfPresent(String.self, forKey: .password)
        avatar = try container.decode(String.self, forKey: .avatar)
        bio = try container.decodeIfPresent(String.self, forKey: .bio)
    }
}

extension User: Validatable {

    enum Validators: String {
        case firstname = "Wrong firstname (letters, 1 - 30)"
        case lastname = "Wrong lastname (letters, 1 - 30)"
        case email = "Wrong mail format"
        case password = "Wrong password (1 number, 1 special char, > 8)"
        case bio = "Wrong biography (< 200)"
    }

    func validate(_ validator: Validators, _ section: String? = nil) -> ValidationResult {
        // default error
        let err = CustomError(message: "\(validator)", description: validator.rawValue, type: section ?? "ValidationError")
        // rules
        let ruleEmails = ValidationRulePattern(pattern: EmailValidationPattern.standard, error: err)

        var rulesNames = ValidationRuleSet<String>()
        rulesNames.add(rule: ValidationRulePattern(pattern: NameValidationPattern(), error: err))
        rulesNames.add(rule: ValidationRuleLength(min: 1, error: err))
        rulesNames.add(rule: ValidationRuleLength(max: 30, error: err))

        var rulesPasswords = ValidationRuleSet<String>()
        rulesPasswords.add(rule: ValidationRulePattern(pattern: PasswordValidationPattern(), error: err))
        rulesPasswords.add(rule: ValidationRuleLength(min: 8, error: err))
        rulesPasswords.add(rule: ValidationRuleLength(max: 128, error: err))

        var rulesBios = ValidationRuleSet<String>()
        rulesBios.add(rule: ValidationRuleLength(max: 200, error: err))

        // validator
        switch validator {
        case .firstname:
            return firstName.validate(rules: rulesNames)
        case .lastname:
            return lastName.validate(rules: rulesNames)
        case .email:
            return email.validate(rule: ruleEmails)
        case .password:
            return password?.validate(rules: rulesPasswords) ?? ValidationResult.valid
        case .bio:
            return bio?.validate(rules: rulesBios) ?? ValidationResult.valid
        }
    }
}
