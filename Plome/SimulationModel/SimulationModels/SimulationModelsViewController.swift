//
//  SimulationModelsViewController.swift
//  Plome
//
//  Created by Loic Mazuc on 09/10/2022.
//

import Combine
import PlomeCoreKit
import UIKit

final class SimulationModelsViewController: AppViewController {
    // MARK: - Properties

    private let viewModel: SimulationModelsViewModel

    private lazy var dataSource: SimulationModelsTableViewDataSource = self.createDataSource()
    private var cancellables: Set<AnyCancellable> = []

    // MARK: - UI

    private lazy var tableView = UITableView(frame: .zero, style: .grouped).configure { [weak self] in
        $0.delegate = self
        $0.register(SimulationCell.self, forCellReuseIdentifier: SimulationCell.reuseIdentifier)
        $0.backgroundColor = .clear
        $0.separatorStyle = .none
        $0.translatesAutoresizingMaskIntoConstraints = false
    }

    private lazy var primaryCTAAddModel: PrimaryCTA = .init(title: "Nouveau modèle").configure { [weak self] in
        $0.addTarget(self, action: #selector(userDidTapAddModel), for: .touchUpInside)
        $0.translatesAutoresizingMaskIntoConstraints = false
    }

    // MARK: - Init

    required init(viewModel: SimulationModelsViewModel) {
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

        setupConstraint()

        bindSnapshot()
        viewModel.updateSnapshot()
    }

    // Set observer and remove it in viewWillDisappear to avoid reload when it's not neccessary
    // For example, when user make a simulation
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        NotificationCenter.default.addObserver(self, selector: #selector(contextObjectsDidChange(_:)), name: .NSManagedObjectContextObjectsDidChange, object: nil)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self, name: .NSManagedObjectContextObjectsDidChange, object: nil)
    }

    // MARK: - Methods

    private func setupConstraint() {
        view.addSubview(primaryCTAAddModel)

        NSLayoutConstraint.activate([
            primaryCTAAddModel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: AppStyles.defaultSpacing(factor: 3)),
            view.safeAreaLayoutGuide.bottomAnchor.constraint(equalTo: primaryCTAAddModel.bottomAnchor, constant: AppStyles.defaultSpacing(factor: 3)),
            view.trailingAnchor.constraint(equalTo: primaryCTAAddModel.trailingAnchor, constant: AppStyles.defaultSpacing(factor: 3)),
            primaryCTAAddModel.heightAnchor.constraint(equalToConstant: AppStyles.primaryCTAHeight),
        ])

        view.addSubview(tableView)

        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 0),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: AppStyles.defaultSpacing(factor: 3)),
            view.trailingAnchor.constraint(equalTo: tableView.trailingAnchor, constant: AppStyles.defaultSpacing(factor: 3)),
            primaryCTAAddModel.topAnchor.constraint(equalTo: tableView.bottomAnchor, constant: AppStyles.defaultSpacing(factor: 2)),
        ])
    }

    private func bindSnapshot() {
        viewModel.$snapshot
            .receive(on: RunLoop.main)
            .sink { [weak self] in
                self?.dataSource.apply($0, animatingDifferences: false, completion: nil)
            }
            .store(in: &cancellables)
    }

    @objc private func userDidTapAddModel() {
        viewModel.userDidTapAddSimulationModel()
    }

    @objc private func contextObjectsDidChange(_: Notification) {
        viewModel.updateSnapshot()
    }

    private func createDataSource() -> SimulationModelsTableViewDataSource {
        return .init(tableView: tableView) { tableView, _, itemIdentifier in
            if let cell = tableView.dequeueReusableCell(withIdentifier: SimulationCell.reuseIdentifier) as? SimulationCell {
                cell.setup(with: itemIdentifier)
                return cell
            }
            return UITableViewCell()
        }
    }
}

// MARK: - Table View Delegate

extension SimulationModelsViewController: UITableViewDelegate {
    func tableView(_: UITableView, didSelectRowAt indexPath: IndexPath) {
        viewModel.userDidTapOnSimulation(at: indexPath)
    }

    func tableView(_: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = AppContextualAction.deleteAction { [weak self] in
            self?.viewModel.userDidTapDeleteSimulationModel(at: indexPath.row)
        }
        return UISwipeActionsConfiguration(actions: [deleteAction])
    }
}
