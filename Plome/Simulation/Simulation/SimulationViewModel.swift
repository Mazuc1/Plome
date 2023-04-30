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

    @Published var simulation: Simulation
    @Published var canCalculate: Bool = false
    
    weak var examTypePageViewControllerInput: ExamTypePageViewControllerInput?
    
    lazy var examTypePageViewModel: ExamTypePageViewModel = {
       return ExamTypePageViewModel(simulation: simulation)
    }()

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
        examTypePageViewControllerInput?.updateTableViews()
    }
}

// MARK: - SimulationViewModelInput

extension SimulationViewModel: SimulationViewModelInput {
    func userDidChangeValue() {
        // Update UI of synthesis view
        //canCalculate = simulation.gradeIsSetForAllExams()
    }
}
