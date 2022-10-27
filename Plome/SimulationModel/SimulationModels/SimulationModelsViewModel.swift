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

    private let router: SimulationModelsRouter

    typealias TableViewSnapshot = NSDiffableDataSourceSnapshot<SimulationModelsSection, Simulation>
    private let defaultSimulationModelsProvider: DefaultSimulationModelsProvider
    private let simulationRepository: CoreDataRepository<CDSimulation>
    
    private var coreDataSimulations: [CDSimulation]?

    @Published var snapshot: TableViewSnapshot = .init()

    // MARK: - Init

    init(router: SimulationModelsRouter, defaultSimulationModelsProvider: DefaultSimulationModelsProvider, simulationRepository: CoreDataRepository<CDSimulation>) {
        self.router = router
        self.defaultSimulationModelsProvider = defaultSimulationModelsProvider
        self.simulationRepository = simulationRepository
    }

    // MARK: - Methods

    func bindDataSource() {
        let coreDataSimulations = try? simulationRepository.list()
        var simulations: [Simulation]?
        
        if let coreDataSimulations {
            simulations = coreDataSimulations
                .map {
                var examSet: Set<Exam>?
                if let exams = $0.exams?.map({ Exam(name: $0.name, coefficient: $0.coefficient, grade: $0.grade, type: $0.type) }) {
                    examSet = Set(exams)
                }
                return Simulation(name: $0.name, date: $0.date ?? Date(), exams: examSet)
            }
        }
        
        snapshot = makeTableViewSnapshot(coreDataSimulations: simulations)
    }

    private func makeTableViewSnapshot(coreDataSimulations: [Simulation]?) -> TableViewSnapshot {
        var snapshot: TableViewSnapshot = .init()
        snapshot.appendSections([.default])
        snapshot.appendItems(defaultSimulationModelsProvider.simulations, toSection: .default)

        if let coreDataSimulations {
            snapshot.appendSections([.coreData])
            snapshot.appendItems(coreDataSimulations, toSection: .coreData)
        }

        return snapshot
    }

    func userDidTapAddSimulationModel() {
        router.openAddSimulationModel()
    }
}
