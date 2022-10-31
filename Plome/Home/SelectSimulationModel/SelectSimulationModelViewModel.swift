//
//  SelectSimulationModelViewModel.swift
//  Plome
//
//  Created by Loic Mazuc on 30/10/2022.
//

import Foundation
import PlomeCoreKit
import UIKit

final class SelectSimulationModelViewModel: ObservableObject {
    // MARK: - Properties

    typealias TableViewSnapshot = NSDiffableDataSourceSnapshot<SimulationModelsSection, Simulation>

    private let router: SimulationsRouter
    private let defaultSimulationModelsProvider: DefaultSimulationModelsProvider
    private let simulationRepository: CoreDataRepository<CDSimulation>

    @Published var snapshot: TableViewSnapshot = .init()

    // MARK: - Init

    init(router: SimulationsRouter, defaultSimulationModelsProvider: DefaultSimulationModelsProvider, simulationRepository: CoreDataRepository<CDSimulation>) {
        self.router = router
        self.defaultSimulationModelsProvider = defaultSimulationModelsProvider
        self.simulationRepository = simulationRepository
    }

    // MARK: - Methods

    private func bindDataSource() {
        let coreDataSimulationModels = try? simulationRepository.list(sortDescriptors: [CDSimulation.alphabeticDescriptor], predicate: CDSimulation.withoutDatePredicate)
        var simulations: [Simulation]?

        if let coreDataSimulationModels {
            simulations = coreDataSimulationModels
                .map {
                    var examSet: Set<Exam>?
                    if let exams = $0.exams?.map({ Exam(name: $0.name, coefficient: $0.coefficient, grade: $0.grade, type: $0.type) }) {
                        examSet = Set(exams)
                    }
                    return Simulation(name: $0.name, date: $0.date, exams: examSet)
                }
        }

        snapshot = makeTableViewSnapshot(with: simulations)
    }

    func updateSnapshot() {
        bindDataSource()
    }

    private func makeTableViewSnapshot(with simulations: [Simulation]?) -> TableViewSnapshot {
        var snapshot: TableViewSnapshot = .init()
        snapshot.appendSections([.default])
        snapshot.appendItems(defaultSimulationModelsProvider.simulations, toSection: .default)

        if let simulations, !simulations.isEmpty {
            snapshot.appendSections([.coreData])
            snapshot.appendItems(simulations, toSection: .coreData)
        }

        return snapshot
    }

    func userDidTapCloseButton() {
        router.dismiss()
    }

    func userDidSelectSimulationModel(at indexPath: IndexPath) {
        var simulation: Simulation?

        if indexPath.section == 0 {
            simulation = defaultSimulationModelsProvider.simulations[indexPath.row]
        } else if indexPath.section == 1 {
            simulation = snapshot.itemIdentifiers(inSection: .coreData)[indexPath.row]
        }

        guard let simulation else {
            router.alert(title: "Oups", message: "Une erreur est survenue 😕")
            return
        }

        router.openSimulationViewModel(with: simulation)
    }
}
