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
    }
    
    // MARK: - Init
    
    // MARK: - Life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    // MARK: - Methods
    
    private func createDataSource() -> DataSourceSnapshot {
        return .init(tableView: tableView) { tableView, indexPath, itemIdentifier in
            return UITableViewCell()
        }
    }
}

// MARK: - Table View Delegate

extension SimulationModelViewController: UITableViewDelegate {}


