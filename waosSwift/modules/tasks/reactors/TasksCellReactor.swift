/**
 * Dependencies
 */

import ReactorKit

/**
 * Reactor
 */

final class TasksCellReactor: Reactor {

    // MARK: Constants

    // user actions
    typealias Action = NoAction

    // MARK: Properties

    let initialState: Tasks

    // MARK: Initialization

    init(task: Tasks) {
        self.initialState = task
    }

}
