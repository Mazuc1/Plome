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
    private let cdSimulation: CDSimulation
    private let simulationRepository: CoreDataRepository<CDSimulation>

    let simulation: Simulation
    let shaper: CalculatorShaper

    // MARK: - Init

    init(router: SimulationsRouter, simulation: Simulation, cdSimulation: CDSimulation, simulationRepository: CoreDataRepository<CDSimulation>) {
        self.router = router
        self.simulation = simulation
        self.cdSimulation = cdSimulation
        self.simulationRepository = simulationRepository

        calculator = Calculator(simulation: simulation)

        shaper = CalculatorShaper(calculator: calculator)
        shaper.successAdmissionSentence = "Admis"
        shaper.failureAdmissionSentence = "Non admis"

        calculator.calculate()
    }

    // MARK: - Methods

    func userDidTapDeleteSimulation() {
        do {
            try simulationRepository.delete(with: cdSimulation.objectID)
            router.popViewController()
        } catch {
            router.alert(title: "Oups...", message: "Impossible de supprimer la simulation pour le moment.")
        }
    }

    func userDidTapRemakeSimulation() {
        router.openSimulation(with: simulation)
    }
}
