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

    private lazy var dataSource: UICollectionViewDiffableDataSource<Int, Simulation> = self.createDataSource()

    // MARK: - UI

    private var collectionViewLayout: UICollectionViewFlowLayout = .init().configure {
        $0.itemSize = .init(width: 130, height: 200)
        $0.sectionInset = .init(top: 10, left: 10, bottom: 10, right: 10)
        $0.scrollDirection = .vertical
    }

    private lazy var collectionView = UICollectionView(frame: .zero, collectionViewLayout: collectionViewLayout).configure { [weak self] in
        $0.delegate = self
        $0.backgroundColor = .clear
        $0.register(SimulationCell.self, forCellWithReuseIdentifier: SimulationCell.reuseIdentifier)
        $0.translatesAutoresizingMaskIntoConstraints = false
    }

    private let labelTitleView: UILabel = .init().configure {
        $0.text = "Mes simulations"
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

        view.addSubview(collectionView)

        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: labelTitleView.bottomAnchor, constant: AppStyles.defaultSpacing(factor: 2)),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: AppStyles.defaultSpacing(factor: 2)),
            view.trailingAnchor.constraint(equalTo: collectionView.trailingAnchor, constant: AppStyles.defaultSpacing(factor: 2)),
            collectionView.bottomAnchor.constraint(equalTo: primaryCTANewSimulation.topAnchor, constant: AppStyles.defaultSpacing(factor: 2)),
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
            collectionView.backgroundView = emptySimulationListView
        } else {
            collectionView.backgroundView = nil
            dataSource.apply(snapshot, animatingDifferences: false, completion: nil)
        }
    }

    private func createDataSource() -> UICollectionViewDiffableDataSource<Int, Simulation> {
        return .init(collectionView: collectionView) { collectionView, indexPath, simulation in
            if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SimulationCell.reuseIdentifier, for: indexPath) as? SimulationCell {
                cell.setup(with: SimulationCellViewModel(simulation: simulation))
                return cell
            }
            return UICollectionViewCell()
        }
    }
}

// MARK: - Table View Delegate

extension SimulationListViewController: UICollectionViewDelegate {
    func collectionView(_: UICollectionView, didSelectItemAt _: IndexPath) {
        //
    }
}
