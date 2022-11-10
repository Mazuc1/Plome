//
//  SimulationListViewController.swift
//  Plome
//
//  Created by Loic Mazuc on 09/10/2022.
//

import PlomeCoreKit
import UIKit

final class SimulationListViewController: AppViewController {
    // MARK: - Properties

    private let viewModel: SimulationListViewModel

    // MARK: - UI

    private let labelTitleView: UILabel = .init().configure {
        $0.text = "Accueil"
        $0.font = PlomeFont.title.font
        $0.textColor = PlomeColor.darkBlue.color
        $0.textAlignment = .left
        $0.translatesAutoresizingMaskIntoConstraints = false
    }

    private lazy var primaryCTANewSimulation: PrimaryCTA = .init(title: "Nouvelle simulation").configure { [weak self] in
        $0.addTarget(self, action: #selector(userDidTapNewSimulation), for: .touchUpInside)
        $0.translatesAutoresizingMaskIntoConstraints = false
    }

    private let emptySimulationListView: EmptySimulationListView = .init()

    // MARK: - Init

    required init(viewModel: SimulationListViewModel) {
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
        view.addSubview(labelTitleView)

        NSLayoutConstraint.activate([
            labelTitleView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: AppStyles.defaultSpacing),
            labelTitleView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: AppStyles.defaultSpacing(factor: 3)),
        ])

        view.addSubview(primaryCTANewSimulation)

        NSLayoutConstraint.activate([
            primaryCTANewSimulation.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: AppStyles.defaultSpacing(factor: 3)),
            view.safeAreaLayoutGuide.bottomAnchor.constraint(equalTo: primaryCTANewSimulation.bottomAnchor, constant: AppStyles.defaultSpacing(factor: 3)),
            view.trailingAnchor.constraint(equalTo: primaryCTANewSimulation.trailingAnchor, constant: AppStyles.defaultSpacing(factor: 3)),
            primaryCTANewSimulation.heightAnchor.constraint(equalToConstant: AppStyles.primaryCTAHeight),
        ])

        view.addSubview(emptySimulationListView)

        NSLayoutConstraint.activate([
            emptySimulationListView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            emptySimulationListView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            emptySimulationListView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: AppStyles.defaultSpacing(factor: 3)),
            view.trailingAnchor.constraint(equalTo: emptySimulationListView.trailingAnchor, constant: AppStyles.defaultSpacing(factor: 3)),
        ])
    }

    @objc private func userDidTapNewSimulation() {
        viewModel.userDidTapNewSimulation()
    }
}
