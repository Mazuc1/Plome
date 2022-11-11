//
//  SimulationResultViewModel.swift
//  Plome
//
//  Created by Loic Mazuc on 10/11/2022.
//

import Foundation
import PlomeCoreKit

final class SimulationResultViewModel {
    // MARK: - Properties

    private let router: SimulationsRouter
    let simulation: Simulation

    // MARK: - Init

    init(router: SimulationsRouter, simulation: Simulation) {
        self.router = router
        self.simulation = simulation
    }

    // MARK: - Methods

    func calculate() -> String {
        let calculator: Calculator = .init(simulation: simulation)

        return "\(calculator.calculate())"
    }
}
