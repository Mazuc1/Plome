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

    // MARK: - Initializer

    init(window: UIWindow, context: ContextProtocol, screens: Screens) {
        self.window = window
        self.context = context
        self.screens = screens
        
        window.makeKeyAndVisible()
        
        simulationModelsRouter = SimulationModelsRouter(screens: screens, rootTransition: EmptyTransition())
    }

    // MARK: - Methods

    func start() {
        tabBarController.viewControllers = [
            HomeViewController().configure { $0.tabBarItem = Tabs.home.item },
            simulationModelsRouter.makeRootViewController(),
            SettingsViewController().configure { $0.tabBarItem = Tabs.settings.item }
        ]

        tabBarController.selectedIndex = 0
        window.rootViewController = tabBarController
    }
}
