//
//  OnboardingViewController.swift
//  Plome
//
//  Created by Loic Mazuc on 16/12/2022.
//

import PlomeCoreKit
import UIKit

enum OnboardingPages: Int, CaseIterable {
    case presentation = 0
    case model = 1
    case simulation = 2
    case start = 3

    var text: String {
        switch self {
        case .presentation: return "Bienvenue sur Plôme, l'application qui vous permet de simuler vos examens."
        case .model: return "Créez vos propres modèles d'examen en plus de ce déjà disponible."
        case .simulation: return "Rentrez vos notes et coefficients pour avoir le résultat."
        case .start: return "Vous savez tout !"
        }
    }

    var title: String {
        switch self {
        case .presentation: return "Hello !"
        case .model: return "Créez tes modèles"
        case .simulation: return "Fait des simulations"
        case .start: return "Let's go !"
        }
    }

    var image: UIImage {
        switch self {
        case .presentation: return Asset.student.image
        case .model: return Asset.model.image
        case .simulation: return Asset.calcul.image
        case .start: return Asset.target.image
        }
    }
}

final class OnboardingViewController: AppViewController {
    // MARK: - Properties

    private let viewModel: OnboardingViewModel
    private var pages: [OnboardingPages] = OnboardingPages.allCases

    // MARK: - UI

    private lazy var pageController: UIPageViewController = .init(transitionStyle: .scroll, navigationOrientation: .horizontal).configure {
        $0.delegate = self
        $0.dataSource = self
        $0.view.backgroundColor = .clear
        $0.isPagingEnabled = false
    }
    
    private var pageControl: UIPageControl = .init().configure {
        $0.pageIndicatorTintColor = PlomeColor.darkBlue.color.withAlphaComponent(0.4)
        $0.currentPageIndicatorTintColor = PlomeColor.darkBlue.color
        $0.numberOfPages = 4
        $0.currentPage = 0
        $0.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private lazy var tertiaryCTASkip: TertiaryCTA = .init(title: "Passer").configure { [weak self] in
        $0.addTarget(self, action: #selector(userDidTapSkip), for: .touchUpInside)
        $0.setTitleColor(PlomeColor.darkGray.color, for: .normal)
        $0.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private lazy var primaryCTANext: PrimaryCTA = .init(title: "Suivant").configure { [weak self] in
        $0.addTarget(self, action: #selector(userDidTapNext), for: .touchUpInside)
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
    }

    // MARK: - Methods

    private func setupLayout() {
        addChild(pageController)
        pageController.view.stretchInView(parentView: view)

        let initialVC = OnboardingPageViewController(page: pages[0])
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
    
    @objc private func userDidTapSkip() {
        viewModel.userDidFinishOnboarding()
    }
    
    @objc private func userDidTapNext() {
        guard let page = OnboardingPages(rawValue: pageControl.currentPage) else { return }

        switch page {
        case .start: viewModel.userDidFinishOnboarding()
        default: pageController.goToNextPage()
        }
        
        updateNextButtonTitleIfNeeded()
    }
    
    private func updateNextButtonTitleIfNeeded() {
        guard let page = OnboardingPages(rawValue: pageControl.currentPage) else { return }
        if page == .start {
            primaryCTANext.setTitle("Terminé", for: .normal)
        }
    }
}

// MARK: PageViewController delegate & data source

extension OnboardingViewController: UIPageViewControllerDataSource, UIPageViewControllerDelegate {
    // No need to implement this method because we disable to go back
    func pageViewController(_: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        return nil
    }

    func pageViewController(_: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let currentVC = viewController as? OnboardingPageViewController else { return nil }

        var index = currentVC.page.rawValue
        if index >= pages.count - 1 { return nil }
        index += 1
        
        pageControl.currentPage = index

        return OnboardingPageViewController(page: pages[index])
    }
}
