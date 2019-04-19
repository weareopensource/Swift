/**
 * Dependencies
 */

import ReactorKit

/**
 * Reactor
 */

final class SecondViewReactor: Reactor {

    // MARK: Constants

    // user actions
    enum Action {
    }

    // state changes
    enum Mutation {
    }

    // the current view state
    struct State {
    }

    // MARK: Properties

    let initialState = State()

    // MARK: Action -> Mutation (mutate() receives an Action and generates an Observable<Mutation>)
    //
    //    func mutate(action: Action) -> Observable<Mutation> {
    //        switch action {
    //
    //        }
    //    }

    // MARK: Mutation -> State (reduce() generates a new State from a previous State and a Mutation)

    //    func reduce(state: State, mutation: Mutation) -> State {
    //        var state = state
    //        switch mutation {
    //
    //        }
    //        return state
    //    }

}
