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

//    private lazy var tableView = UITableView(frame: .zero, style: .plain).configure { [weak self] in
//        $0.delegate = self
//        $0.dataSource = self
//        $0.backgroundColor = .clear
//        $0.separatorStyle = .none
//        $0.showsVerticalScrollIndicator = false
//        $0.estimatedRowHeight = 50
//        $0.register(ExamTypeHeaderView.self, forHeaderFooterViewReuseIdentifier: ExamTypeHeaderView.reuseIdentifier)
//        $0.register(ExamCell.self, forCellReuseIdentifier: ExamCell.reuseIdentifier)
//        $0.translatesAutoresizingMaskIntoConstraints = false
//    }

    private lazy var secondaryCTASave: SecondaryCTA = .init(title: L10n.Home.calculate).configure { [weak self] in
        //$0.addTarget(self, action: #selector(self?.userDidTapCalculate), for: .touchUpInside)
        $0.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private let liveSimulationResultView: LiveSimulationResultView = .init(frame: .zero).configure {
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
        navigationItem.title = viewModel.simulation.name

        navigationItem.rightBarButtonItems = []
        navigationItem.rightBarButtonItems?.append(createInfoBarButton())

        #if DEBUG
            navigationItem.rightBarButtonItems?.append(createDebugBarButton())
        #endif

        navigationItem.backButtonDisplayMode = .minimal

        setupConstraint()
    }

    // MARK: - Methods

    private func setupConstraint() {
        view.addSubview(liveSimulationResultView)

        NSLayoutConstraint.activate([
            liveSimulationResultView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: AppStyles.defaultSpacing(factor: 2)),
            liveSimulationResultView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: AppStyles.defaultSpacing(factor: 2)),
            view.trailingAnchor.constraint(equalTo: liveSimulationResultView.trailingAnchor, constant: AppStyles.defaultSpacing(factor: 2)),
            liveSimulationResultView.heightAnchor.constraint(equalToConstant: Self.liveSimulationResultViewHeight),
        ])
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

private final class LiveSimulationResultView: UIView {
    
    // MARK: - Properties
    
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

    public required override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    private func setupView() {
        gradeLabel.text = "13.23 / 20"
        gradesStateLabel.text = "Toutes les note ne sont pas remplis"
        imageView.image = Icons.fail.configure(weight: .regular, color: .fail, size: 15)
        
        topStackView.addArrangedSubviews([gradeLabel, spacer, mentionView])
        bottomStackView.addArrangedSubviews([imageView, gradesStateLabel])
        
        stackView.addArrangedSubviews([topStackView, bottomStackView])
        stackView.stretchInView(parentView: self)
    }
}
