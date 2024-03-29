//
//  SelectSimulationModelViewModel.swift
//  Plome
//
//  Created by Loic Mazuc on 30/10/2022.
//

import Factory
import Foundation
import PlomeCoreKit
import UIKit

final class SelectSimulationModelViewModel: ObservableObject {
    // MARK: - Properties

    typealias TableViewSnapshot = NSDiffableDataSourceSnapshot<Int, Simulation>

    private let router: SimulationsRouter
    @Injected(\CoreKitContainer.coreDataSimulationRepository) private var simulationRepository

    @Published var snapshot: TableViewSnapshot = .init()

    // MARK: - Init

    init(router: SimulationsRouter) {
        self.router = router
    }

    // MARK: - Methods

    private func bindDataSource() {
        let coreDataSimulationModels = try? simulationRepository.list(sortDescriptors: [CDSimulation.alphabeticDescriptor], predicate: CDSimulation.withoutDatePredicate)
        var simulations: [Simulation]?

        if let coreDataSimulationModels {
            simulations = coreDataSimulationModels
                .map {
                    var examSet: Set<Exam>?
                    if let exams = $0.exams?.map({
                        let grade = $0.grade == Exam.defaultGradeValue ? nil : $0.grade
                        return Exam(name: $0.name, coefficient: $0.coefficient, grade: grade, ratio: $0.ratio, type: $0.type)
                    }) {
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

    func userDidTapCloseButton() {
        router.dismiss()
    }

    func userDidSelectSimulationModel(at indexPath: IndexPath) {
        guard let simulation = getSimulation(indexPath: indexPath) else {
            router.errorAlert()
            return
        }

        router.openSimulation(with: simulation,
                              editing: nil)
    }

    func getSimulation(indexPath: IndexPath) -> Simulation? {
        let simulation: Simulation = snapshot.itemIdentifiers(inSection: 0)[indexPath.row]

        guard let simulationCopy = simulation.copy() as? Simulation else { return nil }

        return simulationCopy
    }
}
