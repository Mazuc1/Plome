//
//  SimulationViewController.swift
//  Plome
//
//  Created by Loic Mazuc on 31/10/2022.
//

import Combine
import PlomeCoreKit
import UIKit

final class SimulationViewController: AppViewController {
    // MARK: - Properties

    private let viewModel: SimulationViewModel
    private var cancellables: Set<AnyCancellable> = .init()

    private static let liveSimulationResultViewHeight: CGFloat = 70

    // MARK: - UI

    private let pageViewControllerContainer: UIView = .init().configure {
        $0.translatesAutoresizingMaskIntoConstraints = false
    }

    private lazy var examTypePageViewController: ExamTypePageViewController = .init(viewModel: viewModel.examTypePageViewModel).configure {
        $0.view.translatesAutoresizingMaskIntoConstraints = false
        viewModel.examTypePageViewControllerInput = $0
    }

    private let simulationLiveInfosView: SimulationLiveInfosView = .init(frame: .zero).configure {
        $0.translatesAutoresizingMaskIntoConstraints = false
    }

    // MARK: - Init

    required init(viewModel: SimulationViewModel) {
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
        viewModel.simulationLiveInfosInput = simulationLiveInfosView

        navigationItem.title = viewModel.simulation.name
        navigationItem.backButtonDisplayMode = .minimal
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Menu",
                                                            image: Icons.ellipsisMenu.configure(weight: .medium, color: .lagoon, size: 16),
                                                            primaryAction: nil,
                                                            menu: createBarButtonMenu())

        setupConstraint()
    }

    // MARK: - Methods

    private func setupConstraint() {
        view.addSubview(simulationLiveInfosView)

        NSLayoutConstraint.activate([
            simulationLiveInfosView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: AppStyles.defaultSpacing(factor: 2)),
            view.trailingAnchor.constraint(equalTo: simulationLiveInfosView.trailingAnchor, constant: AppStyles.defaultSpacing(factor: 2)),
            simulationLiveInfosView.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor, constant: AppStyles.defaultSpacing(factor: 2)),
        ])

        view.addSubview(pageViewControllerContainer)
        addChild(examTypePageViewController)
        pageViewControllerContainer.addSubview(examTypePageViewController.view)

        NSLayoutConstraint.activate([
            pageViewControllerContainer.topAnchor.constraint(equalTo: simulationLiveInfosView.bottomAnchor),
            pageViewControllerContainer.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: AppStyles.defaultSpacing(factor: 2)),
            view.trailingAnchor.constraint(equalTo: pageViewControllerContainer.trailingAnchor, constant: AppStyles.defaultSpacing),
            pageViewControllerContainer.bottomAnchor.constraint(equalTo: view.layoutMarginsGuide.bottomAnchor),

            examTypePageViewController.view.leadingAnchor.constraint(equalTo: pageViewControllerContainer.leadingAnchor),
            pageViewControllerContainer.trailingAnchor.constraint(equalTo: examTypePageViewController.view.trailingAnchor),
            examTypePageViewController.view.topAnchor.constraint(equalTo: pageViewControllerContainer.topAnchor),
            pageViewControllerContainer.bottomAnchor.constraint(equalTo: examTypePageViewController.view.bottomAnchor),
        ])

        examTypePageViewController.didMove(toParent: self)
    }
    
    private func createBarButtonMenu() -> UIMenu {
        var menuItems: [UIAction] = [UIAction(title: "Partager",
                                              image: Icons.share.configure(weight: .regular, color: .lagoon, size: 16),
                                              handler: { [weak self] _ in
            guard let self else { return }
            self.viewModel.userDidTapShareResult(screenshot: self.simulationLiveInfosView.takeScreenshot())
        }),
                                     UIAction(title: "Sauvegarder",
                                              image: Icons.download.configure(weight: .regular, color: .lagoon, size: 16),
                                              handler: { (_) in
        }),
                                     UIAction(title: "Brouillon",
                                              image: Icons.cached.configure(weight: .regular, color: .lagoon, size: 16),
                                              handler: { (_) in
        })]
        
        #if DEBUG
        menuItems.append(UIAction(title: "Fulfill",
                                  image: Icons.hare.configure(weight: .regular, color: .lagoon, size: 16),
                                  handler: { [weak self] _ in self?.viewModel.autoFillExams() }))
        #endif
        
        return UIMenu(title: "Options", image: nil, identifier: nil, options: [], children: menuItems)
    }
}

// MARK: - LiveSimulationResultView

protocol SimulationLiveInfosInput: AnyObject {
    func didUpdate(simulationLiveInfos: SimulationLiveInfos)
}

private final class SimulationLiveInfosView: UIView, SimulationLiveInfosInput {
    // MARK: - UI

    private let mentionView: MentionView = .init(frame: .zero, mention: .cannotBeCalculated)

    private let gradeLabel: UILabel = .init().configure {
        $0.font = PlomeFont.demiBoldL.font
        $0.textColor = PlomeColor.darkBlue.color
    }

    private let imageView: UIImageView = .init()

    private let gradesStateLabel: UILabel = .init().configure {
        $0.font = PlomeFont.bodyS.font
        $0.textColor = PlomeColor.darkGray.color
    }

    private let spacer: UIView = .init().configure {
        let spacerWidthConstraint = $0.widthAnchor.constraint(equalToConstant: .greatestFiniteMagnitude)
        spacerWidthConstraint.priority = .defaultLow
        spacerWidthConstraint.isActive = true
    }

    private let topStackView: UIStackView = .init().configure {
        $0.axis = .horizontal
        $0.distribution = .equalSpacing
        $0.spacing = AppStyles.defaultSpacing
        $0.alignment = .center
    }

    private let bottomStackView: UIStackView = .init().configure {
        $0.axis = .horizontal
        $0.distribution = .equalSpacing
        $0.spacing = AppStyles.defaultSpacing(factor: 0.5)
        $0.alignment = .center
    }

    private let stackView: UIStackView = .init().configure {
        $0.axis = .vertical
        $0.distribution = .fill
        $0.spacing = AppStyles.defaultSpacing
        $0.alignment = .top
        $0.isLayoutMarginsRelativeArrangement = true
        $0.layoutMargins = .init(top: AppStyles.defaultSpacing,
                                 left: AppStyles.defaultSpacing,
                                 bottom: AppStyles.defaultSpacing,
                                 right: AppStyles.defaultSpacing)
        $0.backgroundColor = .white
        $0.layer.cornerRadius = AppStyles.defaultRadius
    }

    // MARK: - Init

    override required init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    private func setupView() {
        gradeLabel.text = L10n.Home.placeholerGrade
        gradesStateLabel.text = L10n.Home.notAllGradeFill
        imageView.image = Icons.warning.configure(weight: .regular, color: .warning, size: 15)

        topStackView.addArrangedSubviews([gradeLabel, spacer, mentionView])
        bottomStackView.addArrangedSubviews([imageView, gradesStateLabel])

        stackView.addArrangedSubviews([topStackView, bottomStackView])
        stackView.stretchInView(parentView: self)
    }

    func didUpdate(simulationLiveInfos: SimulationLiveInfos) {
        gradesStateLabel.text = simulationLiveInfos.gradesState.description
        imageView.image = simulationLiveInfos.gradesState.icon
        gradeLabel.text = simulationLiveInfos.averageText
        mentionView.update(mention: simulationLiveInfos.mention)
    }
}
