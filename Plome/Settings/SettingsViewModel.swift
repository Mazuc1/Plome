//
//  SettingsViewModel.swift
//  Plome
//
//  Created by Loic Mazuc on 28/11/2022.
//

import CoreData
import Factory
import Foundation
import PlomeCoreKit

final class SettingsViewModel {
    // MARK: - Properties

    private let router: SettingsRouter
    @Injected(\CoreKitContainer.coreDataSimulationRepository) private var simulationRepository
    @Injected(\CoreKitContainer.defaultSimulationModelsProvider) private var defaultSimulationModelsProvider
    @Injected(\PlomeContainer.shareSimulationModelService) private var shareSimulationModelService

    // MARK: - Init

    init(router: SettingsRouter) {
        self.router = router
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
        router.alertWithAction(title: PlomeCoreKit.L10n.General.warning, message: L10n.Settings.warningMessageRemoveSimulations, isPrimaryDestructive: true) { [weak self] in
            self?.deleteSimulations()
        }
    }

    func userDidTapDownloadModel() {
        router.alertWithTextField(title: L10n.SimulationModels.downloadModel, message: L10n.SimulationModels.writeCode, buttonActionName: PlomeCoreKit.L10n.General.ok) { [weak self] key in
            self?.dowloadSimuationModel(with: key)
        }
    }

    func userDidTapPineapple() {
        router.openPineappleURL()
    }

    func dowloadSimuationModel(with key: String) {
        Task { @MainActor in
            do {
                let simulation = try await shareSimulationModelService.download(with: key)
                try simulationRepository.add { cdSimulation, context in
                    cdSimulation.name = simulation.name
                    cdSimulation.date = simulation.date
                    cdSimulation.type = simulation.type
                    cdSimulation.exams = simulation.mergeAndConvertExams(in: context, for: cdSimulation)
                }

                router.alert(title: L10n.SimulationModels.successDownloadTitle, message: L10n.SimulationModels.successDownloadMessage)
            } catch {
                router.alert(title: PlomeCoreKit.L10n.General.oups, message: PlomeCoreKit.L10n.General.commonErrorMessage)
            }
        }
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
        router.alertWithAction(title: PlomeCoreKit.L10n.General.warning, message: L10n.Settings.warningMessageReinitialize, isPrimaryDestructive: true) { [weak self] in
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
