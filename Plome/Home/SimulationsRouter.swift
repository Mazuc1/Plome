//
//  SimulationsRouter.swift
//  Plome
//
//  Created by Loic Mazuc on 30/10/2022.
//

import Foundation
import PlomeCoreKit
import UIKit

final class SimulationsRouter: DefaultRouter {
    // MARK: - Properties

    let screens: Screens

    // MARK: - Init

    init(screens: Screens, rootTransition: Transition) {
        self.screens = screens
        super.init(rootTransition: rootTransition)
    }

    // MARK: - Methods

    func makeRootViewController() -> UIViewController {
        let router = SimulationsRouter(screens: screens, rootTransition: EmptyTransition())
        let simulationsViewController = screens.createSimulationsTab(router: router)
        router.rootViewController = simulationsViewController

        return simulationsViewController
    }

    func openSelectSimulationModel() {
        let transition = ModalTransition()
        let router = SimulationsRouter(screens: screens, rootTransition: transition)
        let selectSimulationViewController = screens.createSelectSimulationModel(router: router)
        router.rootViewController = selectSimulationViewController

        route(to: selectSimulationViewController, as: transition)
    }

    func openSimulation(with simulation: Simulation) {
        let transition = PushTransition()
        let router = SimulationsRouter(screens: screens, rootTransition: transition)
        let simulationViewController = screens.createSimulation(router: router, with: simulation)

        router.rootViewController = simulationViewController

        route(to: simulationViewController, as: transition)
    }

    func openSimulationResult(with simulation: Simulation) {
        let transition = PushTransition()
        let router = SimulationsRouter(screens: screens, rootTransition: transition)
        let simulationResultViewController = screens.createSimulationResult(router: router, with: simulation)

        router.rootViewController = simulationResultViewController

        route(to: simulationResultViewController, as: transition)
    }
}
