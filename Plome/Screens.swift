//
//  Screens.swift
//  PineappleCoreKit
//
//  Created by Loic Mazuc on 14/07/2022.
//

import Foundation
import PlomeCoreKit
import UIKit

final class Screens {
    // MARK: - Init

    public init() {}
}

// MARK: - Simulations

extension Screens {
    func createSimulationsTab(router: SimulationsRouter) -> UIViewController {
        let simulationListViewModel = SimulationListViewModel(router: router)
        let simulationsViewController = SimulationListViewController(viewModel: simulationListViewModel)
        simulationsViewController.tabBarItem = Tabs.home.item

        let navigationController = UINavigationController(rootViewController: simulationsViewController)
        return navigationController
    }

    func createSelectSimulationModel(router: SimulationsRouter) -> UIViewController {
        let selectSimulationModelViewModel = SelectSimulationModelViewModel(router: router)
        let selectSimulationModelViewController = SelectSimulationModelViewController(viewModel: selectSimulationModelViewModel)
        let navigationController = UINavigationController(rootViewController: selectSimulationModelViewController)

        return navigationController
    }

    func createSimulation(router: SimulationsRouter, with simulation: Simulation, editing cdSimulation: CDSimulation? = nil) -> UIViewController {
        let simulationViewModel = SimulationViewModel(router: router, simulation: simulation, editing: cdSimulation)
        let simulationViewController = SimulationViewController(viewModel: simulationViewModel)
        return simulationViewController
    }

    func createSimulationDetails(router: SimulationsRouter, for simulation: Simulation, extract from: CDSimulation) -> UIViewController {
        let simulationDetailsViewModel = SimulationDetailsViewModel(router: router, simulation: simulation, cdSimulation: from)
        let simulationDetailsViewController = SimulationDetailsViewController(viewModel: simulationDetailsViewModel)
        return simulationDetailsViewController
    }
}

// MARK: - Simulation Models

extension Screens {
    func createSimulationModelsTab(router: SimulationModelsRouter) -> UIViewController {
        let simulationModelsViewModel = SimulationModelsViewModel(router: router)
        let simulationModelsViewController = SimulationModelsViewController(viewModel: simulationModelsViewModel)
        simulationModelsViewController.tabBarItem = Tabs.model.item
        return simulationModelsViewController
    }

    func createAddSimulationModel(router: SimulationModelsRouter, openAs: AddSimulationModelOpeningMode) -> UIViewController {
        let addSimulationViewModel = AddSimulationModelViewModel(router: router, openAs: openAs)
        let addSimulationViewController = AddSimulationModelViewController(viewModel: addSimulationViewModel)
        let navigationController = UINavigationController(rootViewController: addSimulationViewController)

        return navigationController
    }
}

// MARK: - Settings

extension Screens {
    func createSettingsTab(router: SettingsRouter) -> UIViewController {
        let settingsViewModel = SettingsViewModel(router: router)
        let settingsViewController = SettingsViewController(viewModel: settingsViewModel)
        settingsViewController.tabBarItem = Tabs.settings.item

        return UINavigationController(rootViewController: settingsViewController)
    }
}

// MARK: - Onboarding

extension Screens {
    func createOnboarding(router: OnboardingRouter) -> UIViewController {
        let onboardingViewModel = OnboardingViewModel(router: router)
        let onboardingViewController = OnboardingViewController(viewModel: onboardingViewModel)
        return onboardingViewController
    }
}
