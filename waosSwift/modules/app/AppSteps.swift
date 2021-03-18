/**
 * Dependencies
 */

import RxFlow

/**
 * Steps
 */

enum Steps: Step {
    case onboardingIsRequired
    case onboardingIsComplete

    case authIsRequired
    case authIsComplete

    case dashboardIsRequired

    case tasksIsRequired

    case secondIsRequired

    case userIsRequired
}
