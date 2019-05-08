/**
 * Dependencies
 */

import UIKit
import Reusable
import ReactorKit

/**
 * Crontroller
 */

final class OnboardingController: CoreController, View, Stepper {

    // MARK: UI

    let introLabel = UILabel().then {
        $0.numberOfLines = 4
    }
    let completeButton = UIButton().then {
        $0.setTitle(L10n.onBoardingValidation, for: .normal)
        $0.layer.cornerRadius = 5
        $0.backgroundColor = UIColor.gray
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

        self.view.backgroundColor = .white
        self.scrollView.contentSize = CGSize(width: view.frame.width * CGFloat(3), height: view.frame.height)

        self.view.addSubview(self.scrollView)
        self.view.addSubview(self.completeButton)
        self.view.addSubview(self.pageControl)
        self.view.addSubview(self.introLabel)
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
        introLabel.snp.makeConstraints { (make) -> Void in
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
        pageControl.rx.controlEvent(.valueChanged)
            .subscribe(onNext: { [weak self] in
                guard let currentPage = self?.pageControl.currentPage else {
                    return
                }
                self?.scrollView.setCurrentPage(currentPage, animated: true)
            })
            .disposed(by: self.disposeBag)

        scrollView.rx.currentPage
            .subscribe(onNext: { [weak self] in
                self?.pageControl.currentPage = $0
            })
            .disposed(by: self.disposeBag)
    }

    // MARK: actions (View -> Reactor)

    func bindAction(_ reactor: OnboardingReactor) {
        completeButton.rx.tap
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
        reactor.state
            .map { $0.step }
            .bind(to: self.steps)
            .disposed(by: disposeBag)

        reactor.state.asObservable().map { $0.content }
            .distinctUntilChanged()
            .bind(to: self.introLabel.rx.text)
            .disposed(by: self.disposeBag)
    }
}

extension Reactive where Base: UIScrollView {
    var currentPage: Observable<Int> {
        return didEndDecelerating.map({
            let pageWidth = self.base.frame.width
            let page = floor((self.base.contentOffset.x - pageWidth / 2) / pageWidth) + 1
            return Int(page)
        })
    }
}

extension UIScrollView {
    func setCurrentPage(_ page: Int, animated: Bool) {
        var rect = bounds
        rect.origin.x = rect.width * CGFloat(page)
        rect.origin.y = 0
        scrollRectToVisible(rect, animated: animated)
    }
}
