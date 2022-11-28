//
//  AppRouter.swift
//  Pineapple
//
//  Created by Loic Mazuc on 14/07/2022.
//

import Foundation
import PlomeCoreKit
import UIKit

final class AppRouter {
    // MARK: - Properties

    private let context: ContextProtocol
    let screens: Screens

    // MARK: - UI

    let window: UIWindow
    let tabBarController = MainTabBarController()

    let simulationModelsRouter: SimulationModelsRouter
    let simulationsRouter: SimulationsRouter
    let settingsRouter: SettingsRouter

    // MARK: - Initializer

    init(window: UIWindow, context: ContextProtocol, screens: Screens) {
        self.window = window
        self.context = context
        self.screens = screens

        window.makeKeyAndVisible()

        simulationsRouter = SimulationsRouter(screens: screens, rootTransition: EmptyTransition())
        simulationModelsRouter = SimulationModelsRouter(screens: screens, rootTransition: EmptyTransition())
        settingsRouter = SettingsRouter(screens: screens, rootTransition: EmptyTransition())
    }

    // MARK: - Methods

    func start() {
        tabBarController.viewControllers = [
            simulationsRouter.makeRootViewController(),
            simulationModelsRouter.makeRootViewController(),
            settingsRouter.makeRootViewController(),
        ]

        tabBarController.selectedIndex = 0
        window.rootViewController = tabBarController
    }
}
