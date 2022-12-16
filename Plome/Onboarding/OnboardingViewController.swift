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
    private var currentIndex: Int = 0

    // MARK: - UI

    private lazy var pageController: UIPageViewController = .init(transitionStyle: .scroll, navigationOrientation: .horizontal).configure {
        $0.delegate = self
        $0.dataSource = self
        $0.view.backgroundColor = .clear
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
    }
}

// MARK: PageViewController delegate & data source

extension OnboardingViewController: UIPageViewControllerDataSource, UIPageViewControllerDelegate {
    func pageViewController(_: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let currentVC = viewController as? OnboardingPageViewController else { return nil }

        var index = currentVC.page.rawValue

        if index == 0 {
            return nil
        }

        index -= 1

        return OnboardingPageViewController(page: pages[index])
    }

    func pageViewController(_: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let currentVC = viewController as? OnboardingPageViewController else { return nil }

        var index = currentVC.page.rawValue

        if index >= pages.count - 1 {
            return nil
        }

        index += 1

        return OnboardingPageViewController(page: pages[index])
    }

    func presentationCount(for _: UIPageViewController) -> Int {
        pages.count
    }

    func presentationIndex(for _: UIPageViewController) -> Int {
        currentIndex
    }
}

final class OnboardingPageViewController: AppViewController {
    // MARK: - Properties

    let page: OnboardingPages
    private static let imageSize: CGSize = .init(width: 250, height: 250)

    // MARK: - UI

    private let titleLabel: UILabel = .init().configure {
        $0.font = PlomeFont.demiBoldL.font
        $0.textColor = PlomeColor.darkBlue.color
    }

    private let descriptionLabel: UILabel = .init().configure {
        $0.font = PlomeFont.bodyL.font
        $0.textColor = PlomeColor.darkBlue.color
        $0.numberOfLines = 0
        $0.textAlignment = .center
    }

    private let imageView: UIImageView = .init()

    private let stackView: UIStackView = .init().configure {
        $0.axis = .vertical
        $0.alignment = .center
        $0.distribution = .fillProportionally
        $0.spacing = AppStyles.defaultSpacing(factor: 3)
        $0.translatesAutoresizingMaskIntoConstraints = false
    }

    // MARK: - Init

    required init(page: OnboardingPages) {
        self.page = page
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
        fillUI()
    }

    private func fillUI() {
        titleLabel.text = page.title
        descriptionLabel.text = page.text
        imageView.image = page.image.imageResize(sizeChange: OnboardingPageViewController.imageSize)
    }

    private func setupLayout() {
        stackView.addArrangedSubviews([imageView, titleLabel, descriptionLabel])

        view.addSubview(stackView)
        NSLayoutConstraint.activate([
            stackView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            stackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            stackView.widthAnchor.constraint(equalToConstant: 250),
        ])
    }
}
