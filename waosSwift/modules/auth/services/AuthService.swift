/**
 * Service
 */

protocol AuthServiceType {
    func signUp(firstName: String, lastName: String, email: String, password: String) -> Observable<MyResult<SignResponse, NetworkError>>
    func signIn(email: String, password: String) -> Observable<MyResult<SignResponse, NetworkError>>
    func me() -> Observable<MyResult<MeResponse, NetworkError>>
    func token() -> Observable<MyResult<TokenResponse, NetworkError>>
}

final class AuthService: CoreService, AuthServiceType {
    fileprivate let networking = Networking<AuthApi>(plugins: [CookiePlugin()])

    fileprivate let userSubject = ReplaySubject<User?>.create(bufferSize: 1)
    lazy var currentUser: Observable<User?> = self.userSubject.asObservable()
        .startWith(nil)
        .share(replay: 1)

    func signUp(firstName: String, lastName: String, email: String, password: String) -> Observable<MyResult<SignResponse, NetworkError>> {
        log.verbose("🔌 service : signIn")
        return self.networking
            .request(.signUp(firstName: firstName, lastName: lastName, email: email, password: password))
            .map(SignResponse.self)
            .map { response in
                self.userSubject.onNext(response.user)
                return response
            }
            .asObservable()
            .map(MyResult.success)
            .catchError { err in .just(.error(getNetworkError(err)))}
    }

    func signIn(email: String, password: String) -> Observable<MyResult<SignResponse, NetworkError>> {
        log.verbose("🔌 service : signIn")
        return self.networking
            .request(.signIn(email: email, password: password))
            .map(SignResponse.self)
            .map { response in
                self.userSubject.onNext(response.user)
                return response
            }
            .asObservable()
            .map(MyResult.success)
            .catchError { err in .just(.error(getNetworkError(err)))}
    }

    func me() -> Observable<MyResult<MeResponse, NetworkError>> {
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

    func token() -> Observable<MyResult<TokenResponse, NetworkError>> {
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
