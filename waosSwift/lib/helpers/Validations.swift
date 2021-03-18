/**
 * Dependencies
 */

import UIKit
import Validator

/**
 * functions
 */

public struct NameValidationPattern: ValidationPattern {
    public var pattern: String {
        return "[a-zA-ZàáâäãåąčćęèéêëėįìíîïłńòóôöõøùúûüųūÿýżźñçčšžÀÁÂÄÃÅĄĆČĖĘÈÉÊËÌÍÎÏĮŁŃÒÓÔÖÕØÙÚÛÜŲŪŸÝŻŹÑßÇŒÆČŠŽ∂ð ,.'-]*"
    }
}

public struct AccountValidationPattern: ValidationPattern {
    public var pattern: String {
        return "[a-zA-ZàáâäãåąčćęèéêëėįìíîïłńòóôöõøùúûüųūÿýżźñçčšžÀÁÂÄÃÅĄĆČĖĘÈÉÊËÌÍÎÏĮŁŃÒÓÔÖÕØÙÚÛÜŲŪŸÝŻŹÑßÇŒÆČŠŽ∂ð,.'-_]*"
    }
}

public struct UpperCaseValidationPattern: ValidationPattern {
    public var pattern: String {
        return "(?s)[^A-Z]*[A-Z].*"
    }
}

public struct DigitValidationPattern: ValidationPattern {
    public var pattern: String {
        return "(?s)[^0-9]*[0-9].*"
    }
}

func SpecialCharValidationCondition(_ string: String?) -> Bool {
    let characterset = CharacterSet(charactersIn: "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789")
    if string?.rangeOfCharacter(from: characterset.inverted) != nil {
        return true
    }
    return false
}
