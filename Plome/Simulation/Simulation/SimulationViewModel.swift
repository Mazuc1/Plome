//
//  SimulationViewModel.swift
//  Plome
//
//  Created by Loic Mazuc on 31/10/2022.
//

import Combine
import Foundation
import PlomeCoreKit

protocol SimulationViewModelInput: AnyObject {
    func userDidChangeValue()
}

final class SimulationViewModel: ObservableObject {
    // MARK: - Properties

    private let router: SimulationsRouter

    let simulation: Simulation
    @Published var canCalculate: Bool = false

    // MARK: - Init

    init(router: SimulationsRouter, simulation: Simulation) {
        self.router = router
        self.simulation = simulation

        // Needed when user remake a simulation from details to allow calculation.
        // Without this, the user need to edit one field to enable button
        userDidChangeValue()
    }

    // MARK: - Methods

    func userDidTapCalculate() {
        router.openSimulationResult(with: simulation)
    }

    func autoFillExams() {
        _ = simulation.exams!.map { $0.grade = Float.random(in: 1 ... 20).truncate(places: 2) }
        userDidChangeValue()
    }
}

// MARK: - SimulationViewModelInput

extension SimulationViewModel: SimulationViewModelInput {
    func userDidChangeValue() {
        canCalculate = simulation.gradeIsSetForAllExams()
    }
}
