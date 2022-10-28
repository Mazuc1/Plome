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

    typealias TableViewSnapshot = NSDiffableDataSourceSnapshot<SimulationModelsSection, Simulation>

    private let router: SimulationModelsRouter
    private let defaultSimulationModelsProvider: DefaultSimulationModelsProvider
    private let simulationRepository: CoreDataRepository<CDSimulation>

    private var coreDataSimulationModels: [CDSimulation]?

    @Published var snapshot: TableViewSnapshot = .init()

    // MARK: - Init

    init(router: SimulationModelsRouter, defaultSimulationModelsProvider: DefaultSimulationModelsProvider, simulationRepository: CoreDataRepository<CDSimulation>) {
        self.router = router
        self.defaultSimulationModelsProvider = defaultSimulationModelsProvider
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

    func userDidTapAddSimulationModel() {
        router.openAddSimulationModel(openAs: .add)
    }

    func userDidTapOnSimulation(at index: IndexPath) {
        if index.section == 0 {
            router.openAddSimulationModel(openAs: .editFromDefault(defaultSimulationModelsProvider.simulations[index.row]))
        } else if index.section == 1 {
            if let simulation = coreDataSimulationModels?[index.row] {
                router.openAddSimulationModel(openAs: .edit(simulation))
            } else {
                router.alert(title: "Oups", message: "Une erreur est survenue 😕")
            }
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
