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
    // MARK: - Properties

    public let context: ContextProtocol

    // MARK: - Init

    public init(context: ContextProtocol) {
        self.context = context
    }
}

// MARK: - Simulations

extension Screens {
    func createSimulationsTab(router: SimulationsRouter) -> UIViewController {
        let simulationListViewModel = SimulationListViewModel(router: router, simulationRepository: context.simulationRepository)
        let simulationsViewController = SimulationListViewController(viewModel: simulationListViewModel)
        simulationsViewController.tabBarItem = Tabs.home.item

        return UINavigationController(rootViewController: simulationsViewController)
    }

    func createSelectSimulationModel(router: SimulationsRouter) -> UIViewController {
        let selectSimulationModelViewModel = SelectSimulationModelViewModel(router: router, simulationRepository: context.simulationRepository)
        let selectSimulationModelViewController = SelectSimulationModelViewController(viewModel: selectSimulationModelViewModel)
        let navigationController = UINavigationController(rootViewController: selectSimulationModelViewController)

        return navigationController
    }

    func createSimulation(router: SimulationsRouter, with simulation: Simulation) -> UIViewController {
        let simulationViewModel = SimulationViewModel(router: router, simulation: simulation)
        let simulationViewController = SimulationViewController(viewModel: simulationViewModel)
        simulationViewModel.viewControllerDelegate = simulationViewController
        return simulationViewController
    }

    func createSimulationResult(router: SimulationsRouter, with simulation: Simulation) -> UIViewController {
        let simulationResultViewModel = SimulationResultViewModel(router: router, simulation: simulation, simulationRepository: context.simulationRepository)
        let simulationResultViewController = SimulationResultViewController(viewModel: simulationResultViewModel)
        return simulationResultViewController
    }

    func createSimulationDetails(router: SimulationsRouter, for simulation: Simulation, extract from: CDSimulation) -> UIViewController {
        let simulationDetailsViewModel = SimulationDetailsViewModel(router: router, simulation: simulation, cdSimulation: from, simulationRepository: context.simulationRepository)
        let simulationDetailsViewController = SimulationDetailsViewController(viewModel: simulationDetailsViewModel)
        return simulationDetailsViewController
    }
}

// MARK: - Simulation Models

extension Screens {
    func createSimulationModelsTab(router: SimulationModelsRouter) -> UIViewController {
        let simulationModelsViewModel = SimulationModelsViewModel(router: router, simulationRepository: context.simulationRepository, shareSimulationModelService: context.shareSimulationModelService)
        let simulationModelsViewController = SimulationModelsViewController(viewModel: simulationModelsViewModel)
        simulationModelsViewController.tabBarItem = Tabs.model.item
        return simulationModelsViewController
    }

    func createAddSimulationModel(router: SimulationModelsRouter, openAs: AddSimulationModelOpeningMode) -> UIViewController {
        let addSimulationViewModel = AddSimulationModelViewModel(router: router, simulationRepository: context.simulationRepository, openAs: openAs)
        let addSimulationViewController = AddSimulationModelViewController(viewModel: addSimulationViewModel)
        let navigationController = UINavigationController(rootViewController: addSimulationViewController)

        return navigationController
    }
}

// MARK: - Settings

extension Screens {
    func createSettingsTab(router: SettingsRouter) -> UIViewController {
        let settingsViewModel = SettingsViewModel(router: router, simulationRepository: context.simulationRepository, defaultSimulationModelsProvider: context.defaultSimulationModelsProvider, shareSimulationModelService: context.shareSimulationModelService)
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
