//
//  SettingsViewModel.swift
//  Plome
//
//  Created by Loic Mazuc on 28/11/2022.
//

import CoreData
import Foundation
import PlomeCoreKit

final class SettingsViewModel {
    // MARK: - Properties

    private let router: SettingsRouter
    private let simulationRepository: CoreDataRepository<CDSimulation>
    private let defaultSimulationModelsProvider: DefaultSimulationModelsProvider

    // MARK: - Init

    init(router: SettingsRouter, simulationRepository: CoreDataRepository<CDSimulation>, defaultSimulationModelsProvider: DefaultSimulationModelsProvider) {
        self.router = router
        self.simulationRepository = simulationRepository
        self.defaultSimulationModelsProvider = defaultSimulationModelsProvider
    }

    // MARK: - Methods

    func getVersion() -> String {
        let bundleShortVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "9.99"
        return "Version \(bundleShortVersion)"
    }

    func userDidTapContactAssistance() {
        router.openMailApp()
    }

    func userDidTapDeleteSimulations() {
        router.alertWithAction(title: "Attention", message: "Vous vous apprêtez à supprimer toutes les simulations, êtes-vous sur de vouloir continuer ?") { [simulationRepository, router] in
            do {
                try simulationRepository.delete(predicate: CDSimulation.withDatePredicate, sortDescriptors: [])
                router.alert(title: "Toutes les simulations ont bien été supprimées.", message: "")
            } catch {
                router.alert(title: "Oups...", message: "Une erreur est survenu 😕")
            }
        }
    }

    func userDidTapAddDefaultSimulationModel() {
        defaultSimulationModelsProvider.simulations
            .forEach { simulation in
                do {
                    let _mergeAndConvertExams = mergeAndConvertExams
                    try simulationRepository.add { cdSimulation, context in
                        cdSimulation.name = simulation.name
                        cdSimulation.type = simulation.type
                        cdSimulation.exams = _mergeAndConvertExams(simulation, context, cdSimulation)
                    }
                } catch {
                    router.alert(title: "Oups...", message: "Une erreur est survenu 😕")
                }
            }
    }

    func userDidTapReinitializeApplication() {
        router.alertWithAction(title: "Attention", message: "Vous vous apprêtez à supprimer toutes les données de l'application, êtes-vous sur de vouloir continuer ?") { [simulationRepository, router] in
            do {
                try simulationRepository.deleteAll()
                router.alert(title: "L'application à bien été réinitialisé.", message: "")
            } catch {
                router.alert(title: "Oups...", message: "Une erreur est survenu 😕")
            }
        }
    }

    private func mergeAndConvertExams(of simulation: Simulation, in context: NSManagedObjectContext, for cdSimulation: CDSimulation) -> Set<CDExam> {
        var cdExams: Set<CDExam> = .init()

        let trials = simulation.exams(of: .trial)
        let continousControls = simulation.exams(of: .continuousControl)
        let options = simulation.exams(of: .option)

        _ = trials.map { cdExams.insert($0.toCoreDataModel(in: context, for: cdSimulation)) }
        _ = continousControls.map { cdExams.insert($0.toCoreDataModel(in: context, for: cdSimulation)) }
        _ = options.map { cdExams.insert($0.toCoreDataModel(in: context, for: cdSimulation)) }

        return cdExams
    }
}
