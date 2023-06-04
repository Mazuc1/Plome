//
//  SimulationListViewModel.swift
//  Plome
//
//  Created by Loic Mazuc on 30/10/2022.
//

import Factory
import Foundation
import PlomeCoreKit
import UIKit

final class SimulationListViewModel {
    // MARK: - Properties

    typealias TableViewSnapshot = NSDiffableDataSourceSnapshot<SimulationSection, SimulationItem>

    let router: SimulationsRouter

    @Injected(\CoreKitContainer.coreDataSimulationRepository) private var simulationRepository

    var coreDataSimulationModels: [CDSimulation]?

    @Published var snapshot: TableViewSnapshot = .init()

    // MARK: - Init

    init(router: SimulationsRouter) {
        self.router = router
    }

    // MARK: - Methods

    private func bindDataSource() {
        coreDataSimulationModels = try? simulationRepository.list(sortDescriptors: [CDSimulation.dateDescriptor], predicate: CDSimulation.withDatePredicate)
        var simulations: [Simulation]?

        if let coreDataSimulationModels {
            simulations = coreDataSimulationModels
                .map {
                    var examSet: Set<Exam>?
                    if let exams = $0.exams?.map({ Exam(name: $0.name, coefficient: $0.coefficient, grade: $0.grade, ratio: $0.ratio, type: $0.type) }) {
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

        guard let simulations,
              !simulations.isEmpty else { return snapshot }

        let defaultSimulation = simulations
            .filter { $0.isAllGradesSet() }
            .map { SimulationItem.default($0) }

        let cachedSimulation = simulations
            .filter { $0.isAtLeaseOneGradeNil() }
            .map { SimulationItem.draft($0) }

        if !defaultSimulation.isEmpty {
            snapshot.appendSections([.default])
            snapshot.appendItems(defaultSimulation, toSection: .default)
        }

        if !cachedSimulation.isEmpty {
            snapshot.appendSections([.draft])
            snapshot.appendItems(cachedSimulation, toSection: .draft)
        }

        return snapshot
    }

    func userDidTapNewSimulation() {
        router.openSelectSimulationModel()
    }

    func userDidTapDelete(simulationItem: SimulationItem) {
        guard let (_, cdSimulation) = getSimulationsFrom(simulationItem: simulationItem) else {
            router.errorAlert()
            return
        }

        delete(cdSimulation: cdSimulation)
    }

    func userDidSelect(simulationItem: SimulationItem) {
        guard let (simulation, cdSimulation) = getSimulationsFrom(simulationItem: simulationItem) else {
            router.errorAlert()
            return
        }

        // Action
        switch simulationItem {
        case .default: router.openSimulationDetails(for: simulation,
                                                    extract: cdSimulation)
        case .draft:
            simulation.replaceDefaultGradesValue()
            router.openSimulation(with: simulation,
                                  editing: cdSimulation)
        }
    }

    private func getSimulationsFrom(simulationItem: SimulationItem) -> (Simulation, CDSimulation)? {
        let extractedSimulation: Simulation

        // Get simulation
        switch simulationItem {
        case let .default(simulation): extractedSimulation = simulation
        case let .draft(simulation): extractedSimulation = simulation
        }

        guard let cdSimulation = coreDataSimulationModels?.first(where: { $0.date == extractedSimulation.date }) else { return nil }

        return (extractedSimulation, cdSimulation)
    }

    private func delete(cdSimulation: CDSimulation) {
        do {
            try simulationRepository.delete(with: cdSimulation.objectID)
        } catch {
            router.errorAlert()
        }
    }
}
