enum Steps: Step {
    case onboardingIsRequired
    case onboardingIsComplete

    case splashIsRequired
    case splashIsComplete(_ result: Bool)

    case authIsRequired
    case authIsComplete

    case dashboardIsRequired

    case tasksIsRequired

    case secondIsRequired
}
