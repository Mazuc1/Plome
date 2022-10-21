//
//  Screens.swift
//  PineappleCoreKit
//
//  Created by Loic Mazuc on 14/07/2022.
//

import Foundation
import UIKit

final class Screens {
    // MARK: - Properties

    public let context: ContextProtocol

    // MARK: - Init

    public init(context: ContextProtocol) {
        self.context = context
    }
}

// MARK: - Simulation Models

extension Screens {
    func createSimulationModelsTab(router: SimulationModelsRouter) -> UIViewController {
        let simulationModelsViewModel = SimulationModelsViewModel(router: router, defaultSimulationModelsProvider: context.defaultSimulationModelsProvider)
        let simulationModelsViewController = SimulationModelsViewController(viewModel: simulationModelsViewModel)
        simulationModelsViewController.tabBarItem = Tabs.model.item
        return simulationModelsViewController
    }
    
    func createAddSimulationModel(router: SimulationModelsRouter) -> UIViewController {
        let addSimulationViewModel = AddSimulationModelViewModel()
        let addSimulationViewController = AddSimulationModelViewController(viewModel: addSimulationViewModel)
        let navigationController = UINavigationController(rootViewController: addSimulationViewController)

        return navigationController
    }
}
