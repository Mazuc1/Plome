//
//  SettingsViewModel.swift
//  Plome
//
//  Created by Loic Mazuc on 28/11/2022.
//

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

    func userDidTapAddDefaultSimulationModel() {}

    func userDidTapReinitializeApplication() {
        router.alertWithAction(title: "Attention", message: "Vous vous apprêtez à supprimer toutes les données de l'application, êtes-vous sur de vouloir continuer ?") { [simulationRepository, router] in
            do {
                try simulationRepository.deleteAll()
                router.alert(title: "L'application à bien été réinitialisé.", message: "")
            } catch {
                router.alert(title: "Oups...", message: "Une erreur est survenue.")
            }
        }
    }
}
