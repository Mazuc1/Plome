//
//  SimulationDetailsViewModel.swift
//  Plome
//
//  Created by Loic Mazuc on 24/11/2022.
//

import Foundation
import PlomeCoreKit

final class SimulationDetailsViewModel {
    // MARK: - Properties

    let router: SimulationsRouter
    let simulation: Simulation

    // MARK: - Init

    init(router: SimulationsRouter, simulation: Simulation) {
        self.router = router
        self.simulation = simulation
    }

    // MARK: - Methods
}
