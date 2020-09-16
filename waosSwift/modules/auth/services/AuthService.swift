/**
 * Service
 */

protocol AuthServiceType {
    func signUp(firstName: String, lastName: String, email: String, password: String) -> Observable<MyResult<SignResponse, CustomError>>
    func signIn(email: String, password: String) -> Observable<MyResult<SignResponse, CustomError>>
    func token() -> Observable<MyResult<TokenResponse, CustomError>>
    func forgot(email: String) -> Observable<MyResult<ForgotResponse, CustomError>>
    func oauth(strategy: Bool, key: String, value: String, firstName: String, lastName: String, email: String) -> Observable<MyResult<SignResponse, CustomError>>

    var user: Observable<User?> { get }
}

final class AuthService: CoreService, AuthServiceType {

    fileprivate let networking = Networking<AuthApi>(plugins: [CookiePlugin()])

    fileprivate let userSubject = ReplaySubject<User?>.create(bufferSize: 1)
    lazy var user: Observable<User?> = self.userSubject.asObservable()
        .share(replay: 1)

    func signUp(firstName: String, lastName: String, email: String, password: String) -> Observable<MyResult<SignResponse, CustomError>> {
        log.verbose("🔌 service : signIn")
        return self.networking
            .request(.signUp(firstName: firstName, lastName: lastName, email: email, password: password))
            .map(SignResponse.self)
            .map { response in
                self.userSubject.on(.next(response.user))
                return response
            }
            .asObservable()
            .map(MyResult.success)
            .catchError { err in .just(.error(getError(err)))}
    }

    func signIn(email: String, password: String) -> Observable<MyResult<SignResponse, CustomError>> {
        log.verbose("🔌 service : signIn")
        return self.networking
            .request(.signIn(email: email, password: password))
            .map(SignResponse.self)
            .map { response in
                self.userSubject.on(.next(response.user))
                return response
            }
            .asObservable()
            .map(MyResult.success)
            .catchError { err in .just(.error(getError(err)))}
    }

    func token() -> Observable<MyResult<TokenResponse, CustomError>> {
        log.verbose("🔌 service : me")
        return self.networking
            .request(.token)
            .map(TokenResponse.self)
            .map { response in
                self.userSubject.on(.next(response.user))
                return response
            }
            .asObservable()
            .map(MyResult.success)
            .catchError { err in .just(.error(getError(err)))}
    }

    func forgot(email: String) -> Observable<MyResult<ForgotResponse, CustomError>> {
        log.verbose("🔌 service : forgot")
        return self.networking
            .request(.forgot(email: email))
            .map(ForgotResponse.self)
            .map { response in
                return response
            }
            .asObservable()
            .map(MyResult.success)
            .catchError { err in .just(.error(getError(err)))}
    }

    func oauth(strategy: Bool, key: String, value: String, firstName: String, lastName: String, email: String) -> Observable<MyResult<SignResponse, CustomError>> {
           log.verbose("🔌 service : signIn")
           return self.networking
            .request(.oauth(strategy:strategy, key:key, value:value, firstName:firstName, lastName:lastName, email: email))
               .map(SignResponse.self)
               .map { response in
                   self.userSubject.on(.next(response.user))
                   return response
               }
               .asObservable()
               .map(MyResult.success)
               .catchError { err in .just(.error(getError(err)))}
       }

}
