//
//  SimulationModelsViewModel.swift
//  Plome
//
//  Created by Loic Mazuc on 21/10/2022.
//

import Foundation
import PlomeCoreKit
import UIKit

final class SimulationModelsViewModel: ObservableObject {
    
    // MARK: - Properties
    
    typealias TableViewSnapshot = NSDiffableDataSourceSnapshot<Int, Simulation>
    private let defaultSimulationModelsProvider: DefaultSimulationModelsProvider
    
    @Published var snapshot: TableViewSnapshot = .init()
    
    // MARK: - Init
    
    init(defaultSimulationModelsProvider: DefaultSimulationModelsProvider) {
        self.defaultSimulationModelsProvider = defaultSimulationModelsProvider
    }
    
    // MARK: - Methods
    
    func bindDataSource() {
        snapshot = makeTableViewSnapshot()
    }
    
    private func makeTableViewSnapshot() -> TableViewSnapshot {
        var snapshot: TableViewSnapshot = .init()
        snapshot.appendSections([1])
        snapshot.appendItems(defaultSimulationModelsProvider.simulations, toSection: 1)
        
        return snapshot
    }
}