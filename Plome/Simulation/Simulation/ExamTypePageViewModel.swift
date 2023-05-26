//
//  ExamTypePageViewModel.swift
//  Plome
//
//  Created by Loic Mazuc on 30/04/2023.
//

import Foundation
import PlomeCoreKit

final class ExamTypePageViewModel {
    // MARK: - Properties

    let simulation: Simulation
    weak var simulationViewModelInput: SimulationViewModelInput?

    lazy var examTypes: [ExamType] = simulation.examTypes()

    // MARK: - Init

    init(simulation: Simulation) {
        self.simulation = simulation
    }

    // MARK: - Methods

    func getExam(of type: ExamType) -> [Exam] {
        simulation.exams(of: type)
    }
}
