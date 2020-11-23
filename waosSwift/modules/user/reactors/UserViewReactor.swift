/**
 * Dependencies
 */

import ReactorKit

/**
 * Reactor
 */

final class UserViewReactor: Reactor {

    // MARK: Constants

    // user actions
    enum Action {
        // inputs
        case updateFirstName(String)
        case validateFirstName(String)
        case updateLastName(String)
        case validateLastName(String)
        case updateEmail(String)
        case validateEmail(String)
        // extra
        case updateBio(String)
        case validateBio(String)
        // avatar
        case updateAvatar(Data)
        case deleteAvatar
        // social Networks
        case updateInstagram(String?)
        case validateInstagram(String)
        case updateTwitter(String?)
        case validateTwitter(String)
        case updateFacebook(String?)
        case validateFacebook(String)
        // default
        case done
    }

    // state changes
    enum Mutation {
        // inputs
        case updateFirstName(String)
        case updateLastName(String)
        case updateEmail(String)
        // extra
        case updateBio(String)
        // avatar
        case updateAvatar(String)
        // social Networks
        case updateInstagram(String?)
        case updateTwitter(String?)
        case updateFacebook(String?)
        // default
        case dismiss
        case setRefreshing(Bool)
        case validationError(CustomError)
        case success(String)
        case error(CustomError)
    }

    // the current view state
    struct State {
        var user: User
        var isDismissed: Bool
        var isRefreshing: Bool
        var errors: [DisplayError]
        var error: DisplayError?

        init(user: User) {
            self.user = user
            self.isDismissed = false
            self.isRefreshing = false
            self.errors = []
        }
    }

    // MARK: Properties

    let provider: AppServicesProviderType
    let initialState: State

    // MARK: Initialization

    init(provider: AppServicesProviderType, user: User) {
        self.provider = provider
        self.initialState = State(user: user)
    }

    // MARK: Action -> Mutation (mutate() receives an Action and generates an Observable<Mutation>)

    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        // inputs
        case let .updateFirstName(firstName):
            return .just(.updateFirstName(firstName))
        case let .validateFirstName(section):
            switch currentState.user.validate(.firstname, section) {
            case .valid: return .just(.success("\(User.Validators.firstname)"))
            case let .invalid(err): return .just(.validationError(err[0] as! CustomError))
            }
        case let .updateLastName(lastName):
            return .just(.updateLastName(lastName))
        case let .validateLastName(section):
            switch currentState.user.validate(.lastname, section) {
            case .valid: return .just(.success("\(User.Validators.lastname)"))
            case let .invalid(err): return .just(.validationError(err[0] as! CustomError))
            }
        case let .updateEmail(email):
            return .just(.updateEmail(email))
        case let .validateEmail(section):
            switch currentState.user.validate(.email, section) {
            case .valid: return .just(.success("\(User.Validators.email)"))
            case let .invalid(err): return .just(.validationError(err[0] as! CustomError))
            }
        // extra
        case let .updateBio(bio):
            return .just(.updateBio(bio))
        case let .validateBio(section):
            switch currentState.user.validate(.bio, section) {
            case .valid: return .just(.success("\(User.Validators.bio)"))
            case let .invalid(err): return .just(.validationError(err[0] as! CustomError))
            }
        // avatar
        case let .updateAvatar(data):
            log.verbose("♻️ Action -> Mutation : update Avatar")
            return .concat([
                .just(.setRefreshing(true)),
                self.provider.userService
                    .updateAvatar(file: data, partName: "img", fileName: "test.\(data.imgExtension)", mimeType: data.mimeType)
                    .map { result in
                        switch result {
                        case let .success(result):
                            return .updateAvatar(result.data.avatar)
                        case let .error(err): return .error(err)
                        }
                },
                .just(.setRefreshing(false))
            ])
        case .deleteAvatar:
            log.verbose("♻️ Action -> Mutation : delete Avatar")
            return .concat([
                .just(.setRefreshing(true)),
                self.provider.userService
                    .deleteAvatar()
                    .map { result in
                        switch result {
                        case .success: return .success("avatar deleted")
                        case let .error(err): return .error(err)
                        }
                },
                .just(.setRefreshing(false))
            ])
        // social networks
        case let .updateInstagram(avatar):
            return .just(.updateInstagram(avatar))
        case let .validateInstagram(section):
            switch currentState.user.validate(.instagram, section) {
            case .valid: return .just(.success("\(User.Validators.instagram)"))
            case let .invalid(err): return .just(.validationError(err[0] as! CustomError))
            }
        case let .updateTwitter(firstName):
            return .just(.updateTwitter(firstName))
        case let .validateTwitter(section):
            switch currentState.user.validate(.twitter, section) {
            case .valid: return .just(.success("\(User.Validators.twitter)"))
            case let .invalid(err): return .just(.validationError(err[0] as! CustomError))
            }
        case let .updateFacebook(firstName):
            return .just(.updateFacebook(firstName))
        case let .validateFacebook(section):
            switch currentState.user.validate(.facebook, section) {
            case .valid: return .just(.success("\(User.Validators.facebook)"))
            case let .invalid(err): return .just(.validationError(err[0] as! CustomError))
            }
        // done
        case .done:
            return self.provider.userService
                .update(self.currentState.user)
                .map { result in
                    switch result {
                    case .success: return .dismiss
                    case let .error(err): return .error(err)
                    }
            }
        }
    }

    // MARK: Mutation -> State (reduce() generates a new State from a previous State and a Mutation)

    func reduce(state: State, mutation: Mutation) -> State {
        var state = state
        switch mutation {
        // inputs
        case let .updateFirstName(firstName):
            state.user.firstName = firstName
        case let .updateLastName(lastName):
            state.user.lastName = lastName
        case let .updateEmail(email):
            state.user.email = email
        // extra
        case let .updateBio(bio):
            state.user.bio = bio
        // avatar
        case let .updateAvatar(avatar):
            state.user.avatar = avatar
        // social networks
        case let .updateInstagram(instagram):
            if state.user.complementary != nil {
                if state.user.complementary!.socialNetworks != nil {
                    state.user.complementary?.socialNetworks?.instagram = instagram?.lowercased()
                } else {
                    state.user.complementary?.socialNetworks = SocialNetworks(instagram: instagram?.lowercased())
                }
            } else {
                state.user.complementary = Complementary(socialNetworks: SocialNetworks(instagram: instagram?.lowercased()))
            }
        case let .updateTwitter(twitter):
            if state.user.complementary != nil {
                if state.user.complementary!.socialNetworks != nil {
                    state.user.complementary?.socialNetworks?.twitter = twitter?.lowercased()
                } else {
                    state.user.complementary?.socialNetworks = SocialNetworks(twitter: twitter?.lowercased())
                }
            } else {
                state.user.complementary = Complementary(socialNetworks: SocialNetworks(twitter: twitter?.lowercased()))
            }
        case let .updateFacebook(facebook):
            if state.user.complementary != nil {
                if state.user.complementary!.socialNetworks != nil {
                    state.user.complementary?.socialNetworks?.facebook = facebook?.lowercased()
                } else {
                    state.user.complementary?.socialNetworks = SocialNetworks(facebook: facebook?.lowercased())
                }
            } else {
                state.user.complementary = Complementary(socialNetworks: SocialNetworks(facebook: facebook?.lowercased()))
            }
        // refreshing
        case let .setRefreshing(isRefreshing):
            state.isRefreshing = isRefreshing
        // dissmiss
        case .dismiss:
            log.verbose("♻️ Mutation -> State : dismiss")
            state.isDismissed = true
            state.errors = []
        // success
        case let .success(success):
            log.verbose("♻️ Mutation -> State : succes \(success)")
            state.errors = purgeErrors(errors: state.errors, specificTitles: [success])
        // error
        case let .validationError(error):
            log.verbose("♻️ Mutation -> State : validation error \(error)")
            if state.errors.firstIndex(where: { $0.title == error.message }) == nil {
                state.errors.insert(DisplayError(title: error.message, description: error.description, type: error.type, source: getRawError(error)), at: 0)
            }
        case let .error(error):
            log.verbose("♻️ Mutation -> State : error \(error)")
            let _error: DisplayError
            if error.code == 401 {
                self.provider.preferencesService.isLogged = false
                _error = DisplayError(title: "SignIn", description: L10n.popupLogout, type: error.type, source: getRawError(error))
            } else {
                _error = DisplayError(title: error.message, description: (error.description ?? "Unknown error"), type: error.type, source: getRawError(error))
            }
            state.error = _error
        }
        return state
    }

}
