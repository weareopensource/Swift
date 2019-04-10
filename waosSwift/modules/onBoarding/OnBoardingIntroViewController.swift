import UIKit
import Reusable
import ReactorKit

final class OnboardingIntroViewController: CoreViewController, StoryboardView, StoryboardBased, Stepper {
    let steps = PublishRelay<Step>()

    @IBOutlet weak var completeButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()

        self.reactor = OnboardingIntroViewReactor()
    }

    func bind(reactor: OnboardingIntroViewReactor) {
        bindAction(reactor)
        bindState(reactor)
    }
}

private extension OnboardingIntroViewController {
    func bindAction(_ reactor: OnboardingIntroViewReactor) {
        completeButton.rx.tap
            .map { _ in Reactor.Action.introIsComplete }
            .bind(to: reactor.action)
            .disposed(by: self.disposeBag)
    }

    func bindState(_ reactor: OnboardingIntroViewReactor) {
        reactor.state
            .map { $0.step }
            .bind(to: self.steps)
            .disposed(by: disposeBag)
    }
}
