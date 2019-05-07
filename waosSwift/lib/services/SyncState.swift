struct SynchronisationState {
    var tasks: [Task]
}
let syncState = Variable<SynchronisationState>(SynchronisationState(tasks: []))
