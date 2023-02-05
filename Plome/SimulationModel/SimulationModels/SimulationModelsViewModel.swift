//
//  SimulationModelsViewModel.swift
//  Plome
//
//  Created by Loic Mazuc on 21/10/2022.
//

import Foundation
import PlomeCoreKit
import UIKit
import Dependencies

final class SimulationModelsViewModel: ObservableObject {
    // MARK: - Properties

    typealias TableViewSnapshot = NSDiffableDataSourceSnapshot<Int, Simulation>

    private let router: SimulationModelsRouter
    @Dependency(\.coreDataSimulationRepository) private var simulationRepository
    @Dependency(\.shareSimulationModelService) private var shareSimulationModelService

    var coreDataSimulationModels: [CDSimulation]?

    @Published var snapshot: TableViewSnapshot = .init()

    // MARK: - Init

    init(router: SimulationModelsRouter) {
        self.router = router
    }

    // MARK: - Methods

    private func bindDataSource() {
        coreDataSimulationModels = try? simulationRepository.list(sortDescriptors: [CDSimulation.alphabeticDescriptor], predicate: CDSimulation.withoutDatePredicate)
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
            router.errorAlert()
        }
    }

    func userDidTapDeleteSimulationModel(at index: Int) {
        router.alertWithAction(title: PlomeCoreKit.L10n.General.warning, message: L10n.SimulationModels.warningMessageRemoveModel) { [weak self] in
            self?.deleteSimulationModel(at: index)
        }
    }

    func userDidTapShareSimulationModel(at index: Int) {
        Task { @MainActor in
            if let simulation = coreDataSimulationModels?[index] {
                do {
                    let response = try await shareSimulationModelService.upload(simulationModel: simulation.toModelObject())
                    router.openActivityController(with: ["Plome", L10n.SimulationModels.sharingCodeMessage, response.key])
                } catch {
                    router.alert(title: PlomeCoreKit.L10n.General.oups, message: PlomeCoreKit.L10n.General.commonErrorMessage)
                }
            }
        }
    }

    private func deleteSimulationModel(at index: Int) {
        do {
            if let simulation = coreDataSimulationModels?[index] {
                try simulationRepository.delete(with: simulation.objectID)
            }
        } catch {
            router.errorAlert()
        }
    }
}
