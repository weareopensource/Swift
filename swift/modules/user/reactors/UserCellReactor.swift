/**
 * Dependencies
 */

import ReactorKit

/**
 * Reactor
 */

final class UserCellReactor: Reactor {

    // MARK: Constants

    // user actions
    typealias Action = NoAction

    // MARK: Properties

    let initialState: User

    // MARK: Initialization

    init(user: User) {
        self.initialState = user
    }

}
