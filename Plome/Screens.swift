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
        let simulationListViewModel = SimulationListViewModel(router: router)
        let simulationsViewController = SimulationListViewController(viewModel: simulationListViewModel)
        simulationsViewController.tabBarItem = Tabs.home.item
        return simulationsViewController
    }

    func createSelectSimulationModel(router: SimulationsRouter) -> UIViewController {
        let selectSimulationModelViewModel = SelectSimulationModelViewModel(router: router, defaultSimulationModelsProvider: context.defaultSimulationModelsProvider, simulationRepository: context.simulationRepository)
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
        let simulationResultViewModel = SimulationResultViewModel(router: router, simulation: simulation)
        let simulationResultViewController = SimulationResultViewController(viewModel: simulationResultViewModel)
        return simulationResultViewController
    }
}

// MARK: - Simulation Models

extension Screens {
    func createSimulationModelsTab(router: SimulationModelsRouter) -> UIViewController {
        let simulationModelsViewModel = SimulationModelsViewModel(router: router, defaultSimulationModelsProvider: context.defaultSimulationModelsProvider, simulationRepository: context.simulationRepository)
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
