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
        view.addSubview(secondaryCTASave)

        NSLayoutConstraint.activate([
            secondaryCTASave.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: AppStyles.defaultSpacing(factor: 2)),
            view.safeAreaLayoutGuide.bottomAnchor.constraint(equalTo: secondaryCTASave.bottomAnchor),
            view.trailingAnchor.constraint(equalTo: secondaryCTASave.trailingAnchor, constant: AppStyles.defaultSpacing(factor: 2)),
            secondaryCTASave.heightAnchor.constraint(equalToConstant: AppStyles.primaryCTAHeight),
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
