/**
 * Service
 */

protocol AuthServiceType {
    func signIn(email: String, password: String) -> Observable<MyResult<SignInResponse, CustomError>>
    func me() -> Observable<MyResult<MeResponse, CustomError>>
    func token() -> Observable<MyResult<TokenResponse, CustomError>>
}

final class AuthService: CoreService, AuthServiceType {
    fileprivate let networking = Networking<AuthApi>(plugins: [CookiePlugin()])

    fileprivate let userSubject = ReplaySubject<User?>.create(bufferSize: 1)
    lazy var currentUser: Observable<User?> = self.userSubject.asObservable()
        .startWith(nil)
        .share(replay: 1)

    func signIn(email: String, password: String) -> Observable<MyResult<SignInResponse, CustomError>> {
        log.verbose("🔌 service : signIn")
        return self.networking
            .request(.signin(email: email, password: password))
            .map(SignInResponse.self)
            .map { response in
                self.userSubject.onNext(response.user)
                return response
            }
            .asObservable()
            .map(MyResult.success)
            .catchError { err in .just(.error(getNetworkError(err)))}
    }

    func me() -> Observable<MyResult<MeResponse, CustomError>> {
        log.verbose("🔌 service : me")
        return self.networking
            .request(.me)
            .map(MeResponse.self)
            .map { response in
                self.userSubject.onNext(response.data)
                return response
            }
            .asObservable()
            .map(MyResult.success)
            .catchError { err in .just(.error(getNetworkError(err)))}
    }

    func token() -> Observable<MyResult<TokenResponse, CustomError>> {
        log.verbose("🔌 service : me")
        return self.networking
            .request(.token)
            .map(TokenResponse.self)
            .map { response in
                self.userSubject.onNext(response.user)
                return response
            }
            .asObservable()
            .map(MyResult.success)
            .catchError { err in .just(.error(getNetworkError(err)))}
    }
}
