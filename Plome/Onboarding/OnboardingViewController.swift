//
//  OnboardingViewController.swift
//  Plome
//
//  Created by Loic Mazuc on 16/12/2022.
//

import PlomeCoreKit
import UIKit

final class OnboardingViewController: AppViewController {
    // MARK: - Properties

    private let viewModel: OnboardingViewModel

    private let gradient: CAGradientLayer = .init().configure {
        $0.startPoint = CGPoint(x: 0.0, y: 0.0)
        $0.endPoint = CGPoint(x: 1.0, y: 1.0)
    }

    private let gradientColorSet: [[CGColor]] = PlomeColor.onboardingGradient
    private var colorIndex: Int = 0

    // MARK: - UI

    private lazy var pageController: UIPageViewController = .init(transitionStyle: .scroll, navigationOrientation: .horizontal).configure {
        $0.delegate = self
        $0.dataSource = self
        $0.view.backgroundColor = .clear
        $0.isPagingEnabled = false
    }

    private let pageControl: UIPageControl = .init().configure {
        $0.pageIndicatorTintColor = PlomeColor.darkBlue.color.withAlphaComponent(0.4)
        $0.currentPageIndicatorTintColor = PlomeColor.darkBlue.color
        $0.numberOfPages = 4
        $0.currentPage = 0
        $0.translatesAutoresizingMaskIntoConstraints = false
    }

    private lazy var tertiaryCTASkip: TertiaryCTA = .init(title: PlomeCoreKit.L10n.General.skip).configure { [weak self] in
        $0.addTarget(self, action: #selector(self?.userDidTapSkip), for: .touchUpInside)
        $0.setTitleColor(PlomeColor.darkGray.color, for: .normal)
        $0.translatesAutoresizingMaskIntoConstraints = false
    }

    private lazy var primaryCTANext: PrimaryCTA = .init(title: PlomeCoreKit.L10n.General.next).configure { [weak self] in
        $0.addTarget(self, action: #selector(self?.userDidTapNext), for: .touchUpInside)
        $0.contentEdgeInsets = .init(top: AppStyles.defaultSpacing,
                                     left: AppStyles.defaultSpacing,
                                     bottom: AppStyles.defaultSpacing,
                                     right: AppStyles.defaultSpacing)
        $0.translatesAutoresizingMaskIntoConstraints = false
    }

    // MARK: - Init

    required init(viewModel: OnboardingViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Life cycle

    override func viewDidLoad() {
        super.viewDidLoad()

        setupLayout()
        setupGradient()
        animateGradient()
    }

    // MARK: - Methods

    private func setupLayout() {
        addChild(pageController)
        pageController.view.stretchInView(parentView: view)

        let initialVC = OnboardingPageViewController(page: viewModel.pages[0])
        pageController.setViewControllers([initialVC], direction: .forward, animated: true, completion: nil)

        pageController.didMove(toParent: self)

        pageController.view.addSubview(tertiaryCTASkip)

        NSLayoutConstraint.activate([
            tertiaryCTASkip.leadingAnchor.constraint(equalTo: pageController.view.leadingAnchor, constant: AppStyles.defaultSpacing(factor: 2)),
            tertiaryCTASkip.topAnchor.constraint(equalTo: pageController.view.layoutMarginsGuide.topAnchor),
        ])

        pageController.view.addSubview(primaryCTANext)

        NSLayoutConstraint.activate([
            pageController.view.trailingAnchor.constraint(equalTo: primaryCTANext.trailingAnchor, constant: AppStyles.defaultSpacing(factor: 2)),
            pageController.view.layoutMarginsGuide.bottomAnchor.constraint(equalTo: primaryCTANext.bottomAnchor, constant: AppStyles.defaultSpacing),
        ])

        pageController.view.addSubview(pageControl)

        NSLayoutConstraint.activate([
            pageControl.centerXAnchor.constraint(equalTo: pageController.view.centerXAnchor),
            pageController.view.layoutMarginsGuide.bottomAnchor.constraint(equalTo: pageControl.bottomAnchor),
        ])
    }

    private func setupGradient() {
        gradient.frame = pageController.view.bounds
        pageController.view.layer.insertSublayer(gradient, at: 0)
    }

    @objc private func userDidTapSkip() {
        viewModel.userDidFinishOnboarding()
    }

    @objc private func userDidTapNext() {
        guard let page = OnboardingPage(rawValue: pageControl.currentPage) else { return }

        switch page {
        case .start: viewModel.userDidFinishOnboarding()
        default: pageController.goToNextPage()
        }

        updateNextButtonTitleIfNeeded()
    }

    private func updateNextButtonTitleIfNeeded() {
        guard let page = OnboardingPage(rawValue: pageControl.currentPage) else { return }
        if page == .start {
            primaryCTANext.setTitle(PlomeCoreKit.L10n.General.done, for: .normal)
        }
    }
}

// MARK: PageViewController delegate & data source

extension OnboardingViewController: UIPageViewControllerDataSource, UIPageViewControllerDelegate {
    // No need to implement this method because we disable to go back
    func pageViewController(_: UIPageViewController, viewControllerBefore _: UIViewController) -> UIViewController? {
        return nil
    }

    func pageViewController(_: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let currentVC = viewController as? OnboardingPageViewController else { return nil }

        var index = currentVC.page.rawValue
        if index >= viewModel.pages.count - 1 { return nil }
        index += 1

        pageControl.currentPage = index

        return OnboardingPageViewController(page: viewModel.pages[index])
    }
}

// MARK: - Animation delegate

extension OnboardingViewController: CAAnimationDelegate {
    func animationDidStop(_: CAAnimation, finished flag: Bool) {
        if flag {
            animateGradient()
        }
    }

    private func animateGradient() {
        gradient.colors = gradientColorSet[colorIndex]

        let gradientAnimation = CABasicAnimation(keyPath: "colors")
        gradientAnimation.duration = 3.0
        gradientAnimation.delegate = self

        updateColorIndex()

        gradientAnimation.toValue = gradientColorSet[colorIndex]
        gradientAnimation.fillMode = .forwards
        gradientAnimation.isRemovedOnCompletion = false

        gradient.add(gradientAnimation, forKey: "colors")
    }

    private func updateColorIndex() {
        if colorIndex < gradientColorSet.count - 1 {
            colorIndex += 1
        } else {
            colorIndex = 0
        }
    }
}
