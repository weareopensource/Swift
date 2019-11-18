/**
 * functions
 */

/**
 * @desc Calc and return the state of the token absed on CookieExpire var
 * @return {TokenState}
 */
func getTokenStatus() -> TokenState {
    if let result = UserDefaults.standard.value(forKey: "CookieExpire") {
        let expireIn = config["jwt"]["expireIn"].int ?? (7 * 24 * 60 * 60)
        let renewIn = config["jwt"]["renewIn"].int ?? (60 * 60)

        let tokenLife = Int64(expireIn * 1000)
        let limitToReset = Int64(renewIn * 1000)
        let currentTime = Int64(NSDate().timeIntervalSince1970 * 1000)
        let expireTime = result as! Int64
        let tokenTimeSpent = tokenLife-(expireTime-currentTime)

        if (currentTime > expireTime) {
            return TokenState.toDefine
        } else if( tokenTimeSpent > limitToReset ) {
            return TokenState.toRenew
        } else {
            return TokenState.isOk
        }
    } else {
        return TokenState.toDefine
    }
}

/**
 * Enum
 */

enum TokenState {
    case toDefine
    case isOk
    case toRenew
}
