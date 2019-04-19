/**
 * Dependencies
 */

import UIKit
import Reusable
import ReactorKit

/**
 * Crontroller
 */

final class OnboardingIntroViewController: CoreViewController, StoryboardView, StoryboardBased, Stepper {

    // MARK: UI

    @IBOutlet weak var completeButton: UIButton!

    // MARK: Properties

    let steps = PublishRelay<Step>()

    // MARK: Initializing

    override func viewDidLoad() {
        super.viewDidLoad()

        self.reactor = OnboardingIntroViewReactor()
    }

    // MARK: Binding

    func bind(reactor: OnboardingIntroViewReactor) {
        bindAction(reactor)
        bindState(reactor)
    }
}

/**
 * Extensions
 */

private extension OnboardingIntroViewController {

    // MARK: actions (View -> Reactor)

    func bindAction(_ reactor: OnboardingIntroViewReactor) {
        completeButton.rx.tap
            .map { _ in Reactor.Action.introIsComplete }
            .bind(to: reactor.action)
            .disposed(by: self.disposeBag)
    }

    // MARK: states (Reactor -> View)

    func bindState(_ reactor: OnboardingIntroViewReactor) {
        reactor.state
            .map { $0.step }
            .bind(to: self.steps)
            .disposed(by: disposeBag)
    }
}
