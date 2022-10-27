//
//  SimulationModelsRouter.swift
//  Plome
//
//  Created by Loic Mazuc on 21/10/2022.
//

import Foundation
import PlomeCoreKit
import UIKit

final class SimulationModelsRouter: DefaultRouter {
    // MARK: - Properties

    let screens: Screens

    // MARK: - Init

    init(screens: Screens, rootTransition: Transition) {
        self.screens = screens
        super.init(rootTransition: rootTransition)
    }

    // MARK: - Methods

    func makeRootViewController() -> UIViewController {
        let router = SimulationModelsRouter(screens: screens, rootTransition: EmptyTransition())
        let simulationModelsViewController = screens.createSimulationModelsTab(router: router)
        router.rootViewController = simulationModelsViewController

        return simulationModelsViewController
    }

    func openAddSimulationModel() {
        let transition = ModalTransition()
        let router = SimulationModelsRouter(screens: screens, rootTransition: transition)
        let addSimulationViewController = screens.createAddSimulationModel(router: router)
        router.rootViewController = addSimulationViewController

        route(to: addSimulationViewController, as: transition)
    }
}
