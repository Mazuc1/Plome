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

    private let router: SimulationModelsRouter
    private let simulationRepository: CoreDataRepository<CDSimulation>

    var coreDataSimulationModels: [CDSimulation]?

    @Published var snapshot: TableViewSnapshot = .init()

    // MARK: - Init

    init(router: SimulationModelsRouter, simulationRepository: CoreDataRepository<CDSimulation>) {
        self.router = router
        self.simulationRepository = simulationRepository
    }

    // MARK: - Methods

    private func bindDataSource() {
        coreDataSimulationModels = try? simulationRepository.list(sortDescriptors: [CDSimulation.alphabeticDescriptor], predicate: CDSimulation.withoutDatePredicate)
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

    func userDidTapAddSimulationModel() {
        router.openAddSimulationModel(openAs: .add)
    }

    func userDidTapOnSimulation(at index: IndexPath) {
        if let simulation = coreDataSimulationModels?[index.row] {
            router.openAddSimulationModel(openAs: .edit(simulation))
        } else {
            router.alert(title: "Oups", message: "Une erreur est survenue 😕")
        }
    }

    func userDidTapDeleteSimulationModel(at index: Int) {
        router.alertWithAction(title: "Attention", message: "Vous vous apprêtez à supprimer ce modèle. Êtes vous sur de vouloir le supprimer ?") { [weak self] in
            self?.deleteSimulationModel(at: index)
        }
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
