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

    private let router: SimulationsRouter
    private let calculator: Calculator

    let simulation: Simulation
    let shaper: CalculatorShaper

    // MARK: - Init

    init(router: SimulationsRouter, simulation: Simulation) {
        self.router = router
        self.simulation = simulation

        calculator = Calculator(simulation: simulation)

        shaper = CalculatorShaper(calculator: calculator)
        shaper.successAdmissionSentence = "Admis"
        shaper.failureAdmissionSentence = "Non admis"

        calculator.calculate()
    }

    // MARK: - Methods
}
