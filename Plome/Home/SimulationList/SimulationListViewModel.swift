//
//  SimulationListViewModel.swift
//  Plome
//
//  Created by Loic Mazuc on 30/10/2022.
//

import Foundation
import PlomeCoreKit
import UIKit

final class SimulationListViewModel {
    // MARK: - Properties

    typealias TableViewSnapshot = NSDiffableDataSourceSnapshot<Int, Simulation>

    let router: SimulationsRouter

    private let simulationRepository: CoreDataRepository<CDSimulation>

    var coreDataSimulationModels: [CDSimulation]?

    @Published var snapshot: TableViewSnapshot = .init()

    // MARK: - Init

    init(router: SimulationsRouter, simulationRepository: CoreDataRepository<CDSimulation>) {
        self.router = router
        self.simulationRepository = simulationRepository
    }

    // MARK: - Methods

    private func bindDataSource() {
        coreDataSimulationModels = try? simulationRepository.list(sortDescriptors: [CDSimulation.dateDescriptor], predicate: CDSimulation.withDatePredicate)
        var simulations: [Simulation]?

        if let coreDataSimulationModels {
            simulations = coreDataSimulationModels
                .map {
                    var examSet: Set<Exam>?
                    if let exams = $0.exams?.map({ Exam(name: $0.name, coefficient: $0.coefficient, grade: $0.grade, type: $0.type) }) {
                        examSet = Set(exams)
                    }
                    return Simulation(name: $0.name, date: $0.date, exams: examSet, type: $0.type)
                }
        }

        snapshot = makeTableViewSnapshot(with: simulations)
    }

    func updateSnapshot() {
        bindDataSource()
    }

    private func makeTableViewSnapshot(with simulations: [Simulation]?) -> TableViewSnapshot {
        var snapshot: TableViewSnapshot = .init()

        if let simulations, !simulations.isEmpty {
            snapshot.appendSections([0])
            snapshot.appendItems(simulations, toSection: 0)
        }

        return snapshot
    }

    func userDidTapNewSimulation() {
        router.openSelectSimulationModel()
    }

    func userDidTapDeleteSimulation(at index: Int) {
        deleteSimulationModel(at: index)
    }

    func userDidSelectSimulation(at index: IndexPath) {
        let simulation = snapshot.itemIdentifiers[index.row]
        router.openSimulationDetails(for: simulation)
    }

    private func deleteSimulationModel(at index: Int) {
        do {
            if let simulation = coreDataSimulationModels?[index] {
                try simulationRepository.delete(with: simulation.objectID)
            }
        } catch {
            router.alert(title: "Oups", message: "Une erreur est survenue 😕")
        }
    }
}
