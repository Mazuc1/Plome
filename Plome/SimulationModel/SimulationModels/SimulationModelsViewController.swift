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

    private lazy var dataSource: UITableViewDiffableDataSource<Int, Simulation> = self.createDataSource()
    private var cancellables: Set<AnyCancellable> = []

    // MARK: - UI

    private lazy var tableView = UITableView(frame: .zero, style: .grouped).configure { [weak self] in
        $0.delegate = self
        $0.register(SimulationModelCell.self, forCellReuseIdentifier: SimulationModelCell.reuseIdentifier)
        $0.backgroundColor = .clear
        $0.separatorStyle = .none
        $0.translatesAutoresizingMaskIntoConstraints = false
    }

    private lazy var primaryCTAAddModel: PrimaryCTA = .init(title: L10n.SimulationModels.newModel).configure { [weak self] in
        $0.addTarget(self, action: #selector(self?.userDidTapAddModel), for: .touchUpInside)
        $0.translatesAutoresizingMaskIntoConstraints = false
    }

    private let emptySimulationModelListView: PlaceholderView = .init(frame: .zero, icon: .model, text: L10n.SimulationModels.emptyModelPlaceholder)

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
    }

    // Set observer and remove it in viewWillDisappear to avoid reload when it's not neccessary
    // For example, when user make a simulation
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        NotificationCenter.default.addObserver(self, selector: #selector(contextObjectsDidChange(_:)), name: .NSManagedObjectContextObjectsDidChange, object: nil)
        viewModel.updateSnapshot()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self, name: .NSManagedObjectContextObjectsDidChange, object: nil)
    }

    // MARK: - Methods

    private func setupConstraint() {
        view.addSubview(primaryCTAAddModel)

        NSLayoutConstraint.activate([
            primaryCTAAddModel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: AppStyles.defaultSpacing(factor: 2)),
            view.safeAreaLayoutGuide.bottomAnchor.constraint(equalTo: primaryCTAAddModel.bottomAnchor, constant: AppStyles.defaultSpacing(factor: 2)),
            view.trailingAnchor.constraint(equalTo: primaryCTAAddModel.trailingAnchor, constant: AppStyles.defaultSpacing(factor: 2)),
            primaryCTAAddModel.heightAnchor.constraint(equalToConstant: AppStyles.primaryCTAHeight),
        ])

        view.addSubview(tableView)

        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: AppStyles.defaultSpacing(factor: 2)),
            view.trailingAnchor.constraint(equalTo: tableView.trailingAnchor, constant: AppStyles.defaultSpacing(factor: 2)),
            primaryCTAAddModel.topAnchor.constraint(equalTo: tableView.bottomAnchor, constant: AppStyles.defaultSpacing(factor: 2)),
        ])

        view.addSubview(emptySimulationModelListView)

        NSLayoutConstraint.activate([
            emptySimulationModelListView.centerXAnchor.constraint(equalTo: tableView.centerXAnchor),
            emptySimulationModelListView.centerYAnchor.constraint(equalTo: tableView.centerYAnchor),
            emptySimulationModelListView.leadingAnchor.constraint(equalTo: tableView.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: emptySimulationModelListView.trailingAnchor),
        ])
    }

    private func bindSnapshot() {
        viewModel.$snapshot
            .receive(on: RunLoop.main)
            .sink { [weak self] in
                self?.applySnapshotIfNeeded(snapshot: $0)
            }
            .store(in: &cancellables)
    }

    private func applySnapshotIfNeeded(snapshot: SimulationModelsViewModel.TableViewSnapshot) {
        if snapshot.numberOfItems == 0 {
            emptySimulationModelListView.isHidden = false
        } else {
            emptySimulationModelListView.isHidden = true
        }
        dataSource.apply(snapshot, animatingDifferences: false, completion: nil)
    }

    @objc private func userDidTapAddModel() {
        viewModel.userDidTapAddSimulationModel()
    }

    @objc private func contextObjectsDidChange(_: Notification) {
        viewModel.updateSnapshot()
    }

    private func createDataSource() -> UITableViewDiffableDataSource<Int, Simulation> {
        return .init(tableView: tableView) { tableView, _, itemIdentifier in
            if let cell = tableView.dequeueReusableCell(withIdentifier: SimulationModelCell.reuseIdentifier) as? SimulationModelCell {
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
        let deleteAction = AppContextualAction.deleteAction { [viewModel] in
            viewModel.userDidTapDeleteSimulationModel(at: indexPath.row)
        }
        return UISwipeActionsConfiguration(actions: [deleteAction])
    }

    func tableView(_: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let shareAction = AppContextualAction.shareAction { [viewModel] in
            viewModel.userDidTapShareSimulationModel(at: indexPath.row)
        }
        return UISwipeActionsConfiguration(actions: [shareAction])
    }
}
