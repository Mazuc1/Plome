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
        case .presentation: return "1"
        case .model: return "2"
        case .simulation: return "3"
        case .start: return "4"
        }
    }

    var image: UIImage {
        switch self {
        case .presentation: return UIImage(named: "model.png")!
        case .model: return .init()
        case .simulation: return .init()
        case .start: return .init()
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
        $0.view.backgroundColor = .black
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
        guard let currentVC = viewController as? OnboardingPageViewController else {
            return nil
        }

        var index = currentVC.page.rawValue

        if index == 0 {
            return nil
        }

        index -= 1

        let vc = OnboardingPageViewController(page: pages[index])

        return vc
    }

    func pageViewController(_: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let currentVC = viewController as? OnboardingPageViewController else {
            return nil
        }

        var index = currentVC.page.rawValue

        if index >= pages.count - 1 {
            return nil
        }

        index += 1

        let vc = OnboardingPageViewController(page: pages[index])

        return vc
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

    // MARK: - UI

    private let label: UILabel = .init().configure {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.font = PlomeFont.bodyL.font
        $0.textColor = PlomeColor.darkBlue.color
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
    }

    private func setupLayout() {
        label.text = page.text

        view.addSubview(label)

        NSLayoutConstraint.activate([
            label.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            label.centerYAnchor.constraint(equalTo: view.centerYAnchor),
        ])
    }
}
