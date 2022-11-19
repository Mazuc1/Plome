//
//  SimulationListViewController.swift
//  Plome
//
//  Created by Loic Mazuc on 09/10/2022.
//

import Combine
import PlomeCoreKit
import UIKit

final class SimulationListViewController: AppViewController {
    // MARK: - Properties

    private let viewModel: SimulationListViewModel
    private var cancellables: Set<AnyCancellable> = []

    private lazy var dataSource: UITableViewDiffableDataSource<Int, Simulation> = self.createDataSource()

    // MARK: - UI

    private lazy var tableView = UITableView(frame: .zero, style: .grouped).configure { [weak self] in
        $0.delegate = self
        $0.register(SimulationCell.self, forCellReuseIdentifier: SimulationCell.reuseIdentifier)
        $0.backgroundColor = .clear
        $0.separatorStyle = .none
        $0.translatesAutoresizingMaskIntoConstraints = false
    }

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

        bindSnapshot()
        viewModel.updateSnapshot()
    }

    // MARK: - Methods

    private func setupLayout() {
        view.addSubview(labelTitleView)

        NSLayoutConstraint.activate([
            labelTitleView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: AppStyles.defaultSpacing),
            labelTitleView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: AppStyles.defaultSpacing(factor: 2)),
        ])

        view.addSubview(primaryCTANewSimulation)

        NSLayoutConstraint.activate([
            primaryCTANewSimulation.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: AppStyles.defaultSpacing(factor: 2)),
            view.safeAreaLayoutGuide.bottomAnchor.constraint(equalTo: primaryCTANewSimulation.bottomAnchor, constant: AppStyles.defaultSpacing(factor: 2)),
            view.trailingAnchor.constraint(equalTo: primaryCTANewSimulation.trailingAnchor, constant: AppStyles.defaultSpacing(factor: 2)),
            primaryCTANewSimulation.heightAnchor.constraint(equalToConstant: AppStyles.primaryCTAHeight),
        ])

        view.addSubview(tableView)

        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: labelTitleView.bottomAnchor, constant: AppStyles.defaultSpacing(factor: 2)),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: AppStyles.defaultSpacing(factor: 2)),
            view.trailingAnchor.constraint(equalTo: tableView.trailingAnchor, constant: AppStyles.defaultSpacing(factor: 2)),
            tableView.bottomAnchor.constraint(equalTo: primaryCTANewSimulation.topAnchor, constant: AppStyles.defaultSpacing(factor: 2)),
        ])
    }

    @objc private func userDidTapNewSimulation() {
        viewModel.userDidTapNewSimulation()
    }

    private func bindSnapshot() {
        viewModel.$snapshot
            .receive(on: RunLoop.main)
            .sink { [weak self] in
                self?.applySnapshotIfNeeded(snapshot: $0)
            }
            .store(in: &cancellables)
    }

    private func applySnapshotIfNeeded(snapshot: SimulationListViewModel.TableViewSnapshot) {
        if snapshot.numberOfItems == 0 {
            tableView.backgroundView = emptySimulationListView
        } else {
            tableView.backgroundView = nil
            dataSource.apply(snapshot, animatingDifferences: false, completion: nil)
        }
    }

    private func createDataSource() -> UITableViewDiffableDataSource<Int, Simulation> {
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

extension SimulationListViewController: UITableViewDelegate {
    func tableView(_: UITableView, didSelectRowAt _: IndexPath) {
        // viewModel.userDidTapOnSimulation(at: indexPath)
    }

//    func tableView(_: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
//        let deleteAction = AppContextualAction.deleteAction { [weak self] in
//            self?.viewModel.userDidTapDeleteSimulationModel(at: indexPath.row)
//        }
//        return UISwipeActionsConfiguration(actions: [deleteAction])
//    }
}
