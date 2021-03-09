/**
 * Service
 */

protocol UserServiceType {
    var user: Observable<User?> { get }

    func me() -> Observable<MyResult<UserResponse, CustomError>>
    func update(_ user: User) -> Observable<MyResult<UserResponse, CustomError>>
    func terms() -> Observable<MyResult<UserResponse, CustomError>>
    func delete() -> Observable<MyResult<DeleteDataResponse, CustomError>>
    func updateAvatar(file: Data, partName: String, fileName: String, mimeType: String) -> Observable<MyResult<UserResponse, CustomError>>
    func deleteAvatar() -> Observable<MyResult<UserResponse, CustomError>>
    func data() -> Observable<MyResult<MailResponse, CustomError>>

    func updateDeviceToken(_ deviceToken: String)

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
            .request(.update(user))
            .map(UserResponse.self)
            .map { response in
                self.userSubject.onNext(response.data)
                return response
            }
            .asObservable()
            .map(MyResult.success)
            .catchError { err in .just(.error(getError(err)))}
    }

    func terms() -> Observable<MyResult<UserResponse, CustomError>> {
        log.verbose("🔌 service : me")
        return self.networking
            .request(.terms)
            .map(UserResponse.self)
            .map { response in
                return response
            }
            .asObservable()
            .map(MyResult.success)
            .catchError { err in .just(.error(getError(err)))}
    }

    func delete() -> Observable<MyResult<DeleteDataResponse, CustomError>> {
        log.verbose("🔌 service : delete")
        return self.networking
            .request(.delete)
            .map(DeleteDataResponse.self)
            .map { response in
                self.userSubject.onNext(nil)
                return response
            }
            .asObservable()
            .map(MyResult.success)
            .catchError { err in .just(.error(getError(err)))}
    }

    func updateAvatar(file: Data, partName: String, fileName: String, mimeType: String) -> Observable<MyResult<UserResponse, CustomError>> {
        log.verbose("🔌 service : update avatar")
        return self.networking
            .request(.updateAvatar(file: file, partName: partName, fileName: fileName, mimeType: mimeType))
            .map(UserResponse.self)
            .map { response in
                self.userSubject.onNext(response.data)
                return response
            }
            .asObservable()
            .map(MyResult.success)
            .catchError { err in .just(.error(getError(err)))}
    }

    func deleteAvatar() -> Observable<MyResult<UserResponse, CustomError>> {
        log.verbose("🔌 service : delete avatar ")
        return self.networking
            .request(.deleteAvatar)
            .map(UserResponse.self)
            .map { response in
                self.userSubject.onNext(response.data)
                return response
            }
            .asObservable()
            .map(MyResult.success)
            .catchError { err in .just(.error(getError(err)))}
    }

    func data() -> Observable<MyResult<MailResponse, CustomError>> {
        log.verbose("🔌 service : data")
        return self.networking
            .request(.data)
            .map(MailResponse.self)
            .map { response in
                return response
            }
            .asObservable()
            .map(MyResult.success)
            .catchError { err in .just(.error(getError(err)))}
    }

    func updateDeviceToken(_ deviceToken: String) {
        self.networking.request(.me) { result in
            switch result {
            case let .success(moyaResponse):
                do {
                    let filteredResponse = try moyaResponse.filterSuccessfulStatusCodes()
                    var user = try filteredResponse.map(UserResponse.self)
                    var shouldUpdate = false
                    if let complementary = user.data.complementary {
                        if complementary.iosDevices != nil {
                            if let index = complementary.iosDevices?.firstIndex(where: { $0.token == deviceToken }) {
                                if user.data.complementary?.iosDevices![index].swift != UIDevice.current.systemVersion {
                                    user.data.complementary?.iosDevices![index].swift = UIDevice.current.systemVersion
                                    shouldUpdate = true
                                }
                            } else {
                                user.data.complementary?.iosDevices?.append(Devices(token: deviceToken, swift: UIDevice.current.systemVersion))
                                shouldUpdate = true
                            }
                        } else {
                           user.data.complementary?.iosDevices = [Devices(token: deviceToken, swift: UIDevice.current.systemVersion)]
                            shouldUpdate = true
                        }
                    } else {
                        user.data.complementary = Complementary(iosDevices: [Devices(token: deviceToken, swift: UIDevice.current.systemVersion)])
                        shouldUpdate = true
                    }
                    if shouldUpdate {
                        self.networking.request(.update(user.data)) { result in
                            switch result {
                            case  .success:
                                log.verbose("📱 Success update of user deviceToken")
                            case let .failure(error):
                                log.error("📱 Failed to update user deviceToken\(error) ")
                            }
                        }
                    }
                } catch let error {
                    log.error("📱 Failed to handle user deviceToken \(error)")
                }
            case let .failure(error):
                log.error("📱 Failed to get user deviceToken \(error)")
            }
        }
    }
}
