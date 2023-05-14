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
        navigationItem.rightBarButtonItems = []
        navigationItem.rightBarButtonItems?.append(createInfoBarButton())
        navigationItem.backButtonDisplayMode = .minimal

        #if DEBUG
            navigationItem.rightBarButtonItems?.append(createDebugBarButton())
        #endif

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
            pageViewControllerContainer.topAnchor.constraint(equalTo: simulationLiveInfosView.bottomAnchor, constant: AppStyles.defaultSpacing(factor: 2)),
            pageViewControllerContainer.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: AppStyles.defaultSpacing(factor: 2)),
            view.trailingAnchor.constraint(equalTo: pageViewControllerContainer.trailingAnchor, constant: AppStyles.defaultSpacing(factor: 2)),
            pageViewControllerContainer.bottomAnchor.constraint(equalTo: view.layoutMarginsGuide.bottomAnchor),

            examTypePageViewController.view.leadingAnchor.constraint(equalTo: pageViewControllerContainer.leadingAnchor),
            pageViewControllerContainer.trailingAnchor.constraint(equalTo: examTypePageViewController.view.trailingAnchor),
            examTypePageViewController.view.topAnchor.constraint(equalTo: pageViewControllerContainer.topAnchor),
            pageViewControllerContainer.bottomAnchor.constraint(equalTo: examTypePageViewController.view.bottomAnchor),
        ])

        examTypePageViewController.didMove(toParent: self)
    }

    private func createInfoBarButton() -> UIBarButtonItem {
        UIBarButtonItem(image: Icons.info.configure(weight: .regular, color: .lagoon, size: 16), style: .plain, target: self, action: #selector(userDidTapInfo))
    }

    @objc private func userDidTapInfo() {
        let alertController = UIAlertController(title: L10n.Home.howToCompleteSimulation,
                                                message: L10n.Home.simulationRules,
                                                preferredStyle: .actionSheet)
        alertController.addAction(UIAlertAction(title: PlomeCoreKit.L10n.General.ok, style: .cancel))
        alertController.view.tintColor = PlomeColor.lagoon.color

        present(alertController, animated: true)
    }

    private func createDebugBarButton() -> UIBarButtonItem {
        UIBarButtonItem(image: Icons.hare.configure(weight: .regular, color: .lagoon, size: 16), style: .plain, target: self, action: #selector(didTapFillSimulation))
    }

    @objc private func didTapFillSimulation() {
        viewModel.autoFillExams()
    }
}

// MARK: - LiveSimulationResultView

protocol SimulationLiveInfosInput: AnyObject {
    func didUpdate(simulationLiveInfos: (average: Float, isAllGradeSet: Bool))
}

private final class SimulationLiveInfosView: UIView, SimulationLiveInfosInput {
    
    // MARK: - Properties
    
    private enum GradesState {
        case filled, missing
        
        var description: String {
            switch self {
            case .filled: return "Toutes les note sont remplis !"
            case .missing: return "Toutes les note ne sont pas remplis."
            }
        }
        
        var icon: UIImage {
            switch self {
            case .filled: return Icons.success.configure(weight: .regular, color: .success, size: 15)
            case .missing: return Icons.fail.configure(weight: .regular, color: .fail, size: 15)
            }
        }
    }
    
    // MARK: - UI
    
    private let mentionView: MentionView = .init(frame: .zero, mention: .B)
    
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

    required override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    private func setupView() {
        gradeLabel.text = "-- / 20"
        gradesStateLabel.text = "Toutes les note ne sont pas remplis"
        imageView.image = Icons.fail.configure(weight: .regular, color: .fail, size: 15)
        
        topStackView.addArrangedSubviews([gradeLabel, spacer, mentionView])
        bottomStackView.addArrangedSubviews([imageView, gradesStateLabel])
        
        stackView.addArrangedSubviews([topStackView, bottomStackView])
        stackView.stretchInView(parentView: self)
    }
    
    func didUpdate(simulationLiveInfos: (average: Float, isAllGradeSet: Bool)) {
        if simulationLiveInfos.isAllGradeSet {
            gradesStateLabel.text = GradesState.filled.description
            imageView.image = GradesState.filled.icon
        } else {
            gradesStateLabel.text = GradesState.missing.description
            imageView.image = GradesState.missing.icon
        }
        
        let gradeText = simulationLiveInfos.average == -1 ? "-- / 20" : "\(simulationLiveInfos.average.truncate(places: 2)) / 20"
        gradeLabel.text = gradeText
    }
}
