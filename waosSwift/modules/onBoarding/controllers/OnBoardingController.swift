/**
 * Dependencies
 */

import UIKit
import RxRelay
import RxFlow
import ReactorKit
import SwiftyJSON

/**
 * Controller
 */

final class OnboardingController: CoreController, View, Stepper {

    // MARK: UI

    let labelIntro = CoreUILabel().then {
        $0.numberOfLines = 4
        $0.textAlignment = .center
    }
    let completeButton = CoreUIButton().then {
        $0.setTitle(L10n.onBoardingValidation, for: .normal)
    }
    let scrollView = UIScrollView().then {
        $0.isPagingEnabled = true
        $0.showsVerticalScrollIndicator = false
        $0.showsHorizontalScrollIndicator = false
        $0.backgroundColor = .clear
    }
    let pageControl = UIPageControl().then {
        //$0.frame = CGRect(x: 100, y: 100, width: 200, height: 600)
        $0.numberOfPages = 3
        $0.currentPage = 0
        $0.tintColor = .red
        $0.pageIndicatorTintColor = UIColor.lightGray
        $0.currentPageIndicatorTintColor = UIColor.gray
        $0.backgroundColor = .clear
    }

    // MARK: Properties

    let steps = PublishRelay<Step>()

    // MARK: Initializing

    init(reactor: OnboardingReactor) {
        super.init()
        self.reactor = reactor
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: View Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()

        self.scrollView.contentSize = CGSize(width: view.frame.width * CGFloat(3), height: view.frame.height)

        self.view.addSubview(self.scrollView)
        self.view.addSubview(self.completeButton)
        self.view.addSubview(self.pageControl)
        self.view.addSubview(self.labelIntro)
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }

    override func setupConstraints() {
        scrollView.snp.makeConstraints { (make) in
            make.bottom.equalTo(self.view.safeAreaLayoutGuide.snp.bottom)
            make.top.equalTo(self.view.safeAreaLayoutGuide.snp.top)
            make.left.equalTo(self.view.safeAreaLayoutGuide.snp.left)
            make.right.equalTo(self.view.safeAreaLayoutGuide.snp.right)
        }
        pageControl.snp.makeConstraints { (make) in
            make.bottom.equalTo(self.view.safeAreaLayoutGuide.snp.bottom).offset(-100)
            make.height.equalTo(50)
            make.left.equalTo(50)
            make.right.equalTo(-50)

        }
        labelIntro.snp.makeConstraints { (make) -> Void in
            make.width.height.equalTo(250)
            make.center.equalTo(self.view)
        }
        completeButton.snp.makeConstraints { (make) in
            make.bottom.equalTo(self.view.safeAreaLayoutGuide.snp.bottom).offset(-25)
            make.height.equalTo(50)
            make.left.equalTo(50)
            make.right.equalTo(-50)
        }
    }

    // MARK: Binding

    func bind(reactor: OnboardingReactor) {
        bindView(reactor)
        bindAction(reactor)
        bindState(reactor)
    }
}

/**
 * Extensions
 */

private extension OnboardingController {

    // MARK: views (View -> View)

    func bindView(_ reactor: OnboardingReactor) {
        self.pageControl.rx.controlEvent(.valueChanged)
            .subscribe(onNext: { [weak self] in
                self?.scrollView.setCurrentPage(self?.pageControl.currentPage ?? 0, animated: true)
            })
            .disposed(by: self.disposeBag)
        self.scrollView.rx.currentPage
            .bind(to: self.pageControl.rx.currentPage)
          .disposed(by: disposeBag)
    }

    // MARK: actions (View -> Reactor)

    func bindAction(_ reactor: OnboardingReactor) {
        completeButton.rx.tap
            .throttle(.milliseconds(Metric.timesButtonsThrottle), latest: false, scheduler: MainScheduler.instance)
            .map { _ in Reactor.Action.complete }
            .bind(to: reactor.action)
            .disposed(by: self.disposeBag)

        scrollView.rx.didEndDecelerating
            .map { _ in Reactor.Action.update(self.pageControl.currentPage) }
            .bind(to: reactor.action)
            .disposed(by: self.disposeBag)

    }

    // MARK: states (Reactor -> View)

    func bindState(_ reactor: OnboardingReactor) {
        // dissmiss
        reactor.state
            .map { $0.isDismissed }
            .distinctUntilChanged()
            .filter { $0 }
            .subscribe(onNext: { [weak self] _ in
                self?.steps.accept(Steps.onboardingIsComplete)
            })
            .disposed(by: self.disposeBag)
        // content
        reactor.state
            .map { $0.content }
            .distinctUntilChanged()
            .bind(to: self.labelIntro.rx.text)
            .disposed(by: self.disposeBag)
    }
}
