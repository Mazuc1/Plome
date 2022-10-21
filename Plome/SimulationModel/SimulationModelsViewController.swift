//
//  SimulationModelsViewController.swift
//  Plome
//
//  Created by Loic Mazuc on 09/10/2022.
//

import PlomeCoreKit
import UIKit
import Combine

final class SimulationModelsViewController: AppViewController {
    
    // MARK: - Properties
    
    let viewModel: SimulationModelsViewModel
    
    typealias DataSourceSnapshot = UITableViewDiffableDataSource<Int, Simulation>
    private lazy var dataSource: DataSourceSnapshot = self.createDataSource()
    
    private var cancellables: Set<AnyCancellable> = []
    
    // MARK: - UI
    
    lazy var tableView = UITableView(frame: .zero, style: .plain).configure { [weak self] in
        $0.delegate = self
        $0.backgroundColor = .black.withAlphaComponent(0.1)
        $0.translatesAutoresizingMaskIntoConstraints = false
    }
    
    lazy var primaryCTAAddModel: PrimaryCTA = PrimaryCTA(title: "Nouveau modèle").configure { [weak self] in
        $0.addTarget(self, action: #selector(userDidTapAddModel), for: .touchUpInside)
        $0.translatesAutoresizingMaskIntoConstraints = false
    }
    
    // MARK: - Init
    
    required init(viewModel: SimulationModelsViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupConstraint()
        
        bindSnapshot()
        viewModel.bindDataSource()
    }
    
    // MARK: - Methods
    
    private func setupConstraint() {
        view.addSubview(primaryCTAAddModel)
        
        NSLayoutConstraint.activate([
            primaryCTAAddModel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: AppStyles.defaultSpacing(factor: 3)),
            view.safeAreaLayoutGuide.bottomAnchor.constraint(equalTo: primaryCTAAddModel.bottomAnchor, constant: AppStyles.defaultSpacing(factor: 3)),
            view.trailingAnchor.constraint(equalTo: primaryCTAAddModel.trailingAnchor, constant: AppStyles.defaultSpacing(factor: 3)),
            primaryCTAAddModel.heightAnchor.constraint(equalToConstant: PrimaryCTA.height),
        ])
        
        view.addSubview(tableView)
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: AppStyles.defaultSpacing(factor: 3)),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: AppStyles.defaultSpacing(factor: 3)),
            view.trailingAnchor.constraint(equalTo: tableView.trailingAnchor, constant: AppStyles.defaultSpacing(factor: 3)),
            primaryCTAAddModel.topAnchor.constraint(equalTo: tableView.bottomAnchor, constant: AppStyles.defaultSpacing(factor: 2))
        ])
    }
    
    private func bindSnapshot() {
        viewModel.$snapshot
            .receive(on: RunLoop.main)
            .sink { [weak self] in
                self?.dataSource.apply($0)
            }
            .store(in: &cancellables)
    }
    
    @objc private func userDidTapAddModel() {
        print("🏹")
    }
    
    private func createDataSource() -> DataSourceSnapshot {
        return .init(tableView: tableView) { tableView, indexPath, itemIdentifier in
            let cell = UITableViewCell()
            cell.textLabel?.text = itemIdentifier.name
            return cell
        }
    }
}

// MARK: - Table View Delegate

extension SimulationModelsViewController: UITableViewDelegate {}


