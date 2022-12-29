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
        let bundleShortVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? L10n.Settings.errorAppVersion
        return L10n.Settings.version(bundleShortVersion)
    }

    func userDidTapContactAssistance() {
        router.openMailApp()
    }

    func userDidTapDeleteSimulations() {
        router.alertWithAction(title: PlomeCoreKit.L10n.General.warning, message: L10n.Settings.warningMessageRemoveSimulations) { [weak self] in
            self?.deleteSimulations()
        }
    }

    func userDidTapDownloadModel() {
        // Call gateway service + add to core data
    }

    func deleteSimulations() {
        do {
            try simulationRepository.deleteAll(where: CDSimulation.withDatePredicate, sortDescriptors: [])
            router.alert(title: L10n.Settings.allSimulationHasBeenDeleted, message: "")
        } catch {
            router.errorAlert()
        }
    }

    func userDidTapAddDefaultSimulationModel() {
        defaultSimulationModelsProvider.simulations
            .forEach { simulation in
                do {
                    try simulationRepository.add { cdSimulation, context in
                        cdSimulation.name = simulation.name
                        cdSimulation.type = simulation.type
                        cdSimulation.exams = simulation.mergeAndConvertExams(in: context, for: cdSimulation)
                    }
                    router.alert(title: L10n.Settings.defaultModelHasBeenAdded, message: "")
                } catch {
                    router.errorAlert()
                }
            }
    }

    func userDidTapReinitializeApplication() {
        router.alertWithAction(title: PlomeCoreKit.L10n.General.warning, message: L10n.Settings.warningMessageReinitialize) { [weak self] in
            self?.deleteAllSimulations()
        }
    }

    func deleteAllSimulations() {
        do {
            try simulationRepository.deleteAll()
            router.alert(title: L10n.Settings.appHasBeenReinitialized, message: "")
        } catch {
            router.errorAlert()
        }
    }
}
