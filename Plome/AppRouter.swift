//
//  AppRouter.swift
//  Pineapple
//
//  Created by Loic Mazuc on 14/07/2022.
//

import Foundation
import PlomeCoreKit
import UIKit
import Dependencies

final class AppRouter {
    // MARK: - Properties

    private let screens: Screens
    
    @Dependency(\.userDefault) private var userDefault
    @Dependency(\.defaultSimulationModelStorageService) private var defaultSimulationModelStorageService

    // MARK: - UI

    private let window: UIWindow
    private let tabBarController = MainTabBarController()

    private let simulationModelsRouter: SimulationModelsRouter
    private let simulationsRouter: SimulationsRouter
    private let settingsRouter: SettingsRouter
    private let onboardingFlowController: OnboardingFlowController

    // MARK: - Initializer

    init(window: UIWindow, screens: Screens) {
        self.window = window
        self.screens = screens

        window.makeKeyAndVisible()

        simulationsRouter = SimulationsRouter(screens: screens, rootTransition: EmptyTransition())
        simulationModelsRouter = SimulationModelsRouter(screens: screens, rootTransition: EmptyTransition())
        settingsRouter = SettingsRouter(screens: screens, rootTransition: EmptyTransition())

        onboardingFlowController = OnboardingFlowController(screens: screens)
    }

    // MARK: - Methods

    func start() {
        if !onboardingFlowController.shouldPresentOnboarding() {
            presentOnboardingIfNeeded()
        } else {
            startMainNavigation()
        }
    }

    private func startMainNavigation() {
        defaultSimulationModelStorageService.addDefaultSimulationModelIfNeeded()

        tabBarController.viewControllers = [
            simulationsRouter.makeRootViewController(),
            simulationModelsRouter.makeRootViewController(),
            settingsRouter.makeRootViewController(),
        ]

        tabBarController.selectedIndex = 0
        window.rootViewController = tabBarController
    }

    private func presentOnboardingIfNeeded() {
        onboardingFlowController.onFinished = { [weak self] in
            self?.userDefault.setData(value: true, key: .hasOnboardingBeenSeen)
            self?.startMainNavigation()
        }

        window.rootViewController = onboardingFlowController.start()
    }
}
