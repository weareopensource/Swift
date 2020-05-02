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
        case updateLastName(String)
        case updateEmail(String)
        case updateAvatar(Data)
        case deleteAvatar
        // default
        case done
    }

    // state changes
    enum Mutation {
        // inputs
        case updateFirstName(String)
        case updateLastName(String)
        case updateEmail(String)
        // default
        case dismiss
        case setRefreshing(Bool)
        case success(String)
        case error(CustomError)
    }

    // the current view state
    struct State {
        var user: User
        var isDismissed: Bool
        var isRefreshing: Bool
        var error: DisplayError?

        init(user: User) {
            self.user = user
            self.isDismissed = false
            self.isRefreshing = false
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
        // firstName
        case let .updateFirstName(firstName):
            return .just(.updateFirstName(firstName))
            // update password
        // lastname
        case let .updateLastName(lastName):
            return .just(.updateLastName(lastName))
        // email
        case let .updateEmail(email):
            return .just(.updateEmail(email))
        // avatar
        case let .updateAvatar(data):
            log.verbose("♻️ Action -> Mutation : update Avatar")
            return .concat([
                .just(.setRefreshing(true)),
                self.provider.userService
                    .updateAvatar(file: data, partName: "img", fileName: "test.png", mimeType: data.mimeType)
                    .map { result in
                        switch result {
                        case .success: return .success("avatar updated")
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
        // update firstname
        case let .updateFirstName(firstName):
            state.user.firstName = firstName
        // update lastname
        case let .updateLastName(lastName):
            state.user.lastName = lastName
        // update email
        case let .updateEmail(email):
            state.user.email = email
            // set
        case let .success(success):
            log.verbose("♻️ Mutation -> State : succes \(success)")
            state.error = nil
        // refreshing
        case let .setRefreshing(isRefreshing):
            state.isRefreshing = isRefreshing
        // dissmiss
        case .dismiss:
            log.verbose("♻️ Mutation -> State : dismiss")
            state.isDismissed = true
            state.error = nil
        // error
        case let .error(error):
            log.verbose("♻️ Mutation -> State : error \(error)")
            if error.code == 401 {
                self.provider.preferencesService.isLogged = false
            } else {
                state.error = DisplayError(title: error.message, description: (error.description ?? "Unknown error"))
            }
        }
        return state
    }

}
