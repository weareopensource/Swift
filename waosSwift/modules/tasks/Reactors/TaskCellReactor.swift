/**
 * Dependencies
 */

import ReactorKit

/**
 * Reactor
 */

final class TaskCellReactor: Reactor {

    // MARK: Constants

    // user actions
    typealias Action = NoAction

    // MARK: Properties

    let initialState: Task

    // MARK: Initialization

    init(task: Task) {
        self.initialState = task
    }

}
