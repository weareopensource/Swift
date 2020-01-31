/**
 * Service
 */

protocol UserServiceType {
    var user: Observable<User?> { get }

    func me() -> Observable<MyResult<UserResponse, CustomError>>
    func update(_ user: User) -> Observable<MyResult<UserResponse, CustomError>>
    func delete() -> Observable<MyResult<DeleteResponse, CustomError>>
}

final class UserService: CoreService, UserServiceType {
    fileprivate let networking = Networking<UserApi>(plugins: [CookiePlugin()])

    fileprivate let userSubject = ReplaySubject<User?>.create(bufferSize: 1)
    lazy var user: Observable<User?> = self.userSubject.asObservable()
        .startWith(nil)
        .share(replay: 1)

    func me() -> Observable<MyResult<UserResponse, CustomError>> {
        log.verbose("🔌 service : me")
        return self.networking
            .request(.me)
            .map(UserResponse.self)
            .map { response in
                return response
            }
            .asObservable()
            .map(MyResult.success)
            .catchError { err in .just(.error(getError(err)))}
    }

    func update(_ user: User) -> Observable<MyResult<UserResponse, CustomError>> {
        log.verbose("🔌 service : update ", user.firstName)
        return self.networking
            .request(.update(firstName: user.firstName, lastName: user.lastName, email: user.email))
            .map(UserResponse.self)
            .map { response in
                self.userSubject.onNext(response.data)
                return response
            }
            .asObservable()
            .map(MyResult.success)
            .catchError { err in .just(.error(getError(err)))}
    }

    func delete() -> Observable<MyResult<DeleteResponse, CustomError>> {
        log.verbose("🔌 service : delete")
        return self.networking
            .request(.delete)
            .map(DeleteResponse.self)
            .map { response in
                self.userSubject.onNext(nil)
                return response
            }
            .asObservable()
            .map(MyResult.success)
            .catchError { err in .just(.error(getError(err)))}
    }

}
