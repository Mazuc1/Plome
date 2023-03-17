//
//  SimulationDetailsViewModel.swift
//  Plome
//
//  Created by Loic Mazuc on 24/11/2022.
//

import Dependencies
import Foundation
import PlomeCoreKit

final class SimulationDetailsViewModel {
    // MARK: - Properties

    private let router: SimulationsRouter
    private let calculator: Calculator
    private let cdSimulation: CDSimulation
    @Dependency(\.coreDataSimulationRepository) private var simulationRepository

    let simulation: Simulation
    let shaper: CalculatorShaper

    // MARK: - Init

    init(router: SimulationsRouter, simulation: Simulation, cdSimulation: CDSimulation) {
        self.router = router
        self.simulation = simulation
        self.cdSimulation = cdSimulation

        calculator = Calculator(simulation: simulation)

        shaper = CalculatorShaper(calculator: calculator)
        shaper.successAdmissionSentence = L10n.Home.admit
        shaper.failureAdmissionSentence = L10n.Home.unadmit

        calculator.calculate()
    }

    // MARK: - Methods

    func userDidTapDeleteSimulation() {
        do {
            try simulationRepository.delete(with: cdSimulation.objectID)
            router.popViewController()
        } catch {
            router.errorAlert()
        }
    }

    func userDidTapRemakeSimulation() {
        router.openSimulation(with: simulation)
    }
}
