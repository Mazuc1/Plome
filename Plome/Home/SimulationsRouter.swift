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
}
