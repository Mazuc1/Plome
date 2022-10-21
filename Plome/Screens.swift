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
        let simulationModelsViewController = SimulationModelsViewController()
        simulationModelsViewController.tabBarItem = Tabs.model.item
        return simulationModelsViewController
    }
}
