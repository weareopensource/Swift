/**
 * Dependencies
 */

import ReactorKit

/**
 * Service
 */

protocol AuthServiceType {
    func signIn(email: String, password: String) -> Observable<MyResult<SignInResponse, CustomError>>
}

final class AuthService: CoreService, AuthServiceType {
    fileprivate let networking = Networking<AuthApi>(plugins: [CookiePlugin()])

    func signIn(email: String, password: String) -> Observable<MyResult<SignInResponse, CustomError>> {
        log.verbose("🔌 service : signIn")
        return self.networking
            .request(.signin(email: email, password: password))
            .map(SignInResponse.self)
            .asObservable()
            .map(MyResult.success)
            .catchError { err in .just(.error(getNetworkError(err)))}
    }
}
