//
//  SimulationModelViewController.swift
//  Plome
//
//  Created by Loic Mazuc on 09/10/2022.
//

import PlomeCoreKit
import UIKit

final class SimulationModelViewController: AppViewController {
    
    // MARK: - Properties
    
    typealias DataSourceSnapshot = UITableViewDiffableDataSource<Int, String>
    private lazy var dataSource: DataSourceSnapshot = self.createDataSource()
    
    // MARK: - UI
    
    lazy var tableView = UITableView(frame: .zero, style: .plain).configure { [weak self] in
        $0.delegate = self
        $0.backgroundColor = .black
        $0.translatesAutoresizingMaskIntoConstraints = false
    }
    
    lazy var primaryCTAAddModel: PrimaryCTA = PrimaryCTA(title: "Nouveau modèle").configure { [weak self] in
        $0.addTarget(self, action: #selector(userDidTapAddModel), for: .touchUpInside)
        $0.translatesAutoresizingMaskIntoConstraints = false
    }
    
    // MARK: - Init
    
    // MARK: - Life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupConstraint()
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
    
    @objc private func userDidTapAddModel() {
        print("🏹")
    }
    
    private func createDataSource() -> DataSourceSnapshot {
        return .init(tableView: tableView) { tableView, indexPath, itemIdentifier in
            return UITableViewCell()
        }
    }
}

// MARK: - Table View Delegate

extension SimulationModelViewController: UITableViewDelegate {}


