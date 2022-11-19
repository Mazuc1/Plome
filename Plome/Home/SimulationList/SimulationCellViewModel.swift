//
//  SimulationCellViewModel.swift
//  Plome
//
//  Created by Loic Mazuc on 19/11/2022.
//

import Foundation
import PlomeCoreKit

final class SimulationCellViewModel {
    // MARK: - Properties

    let simulation: Simulation
    private let calculator: Calculator

    // MARK: - Init

    init(simulation: Simulation) {
        self.simulation = simulation
        calculator = Calculator(simulation: simulation)
    }

    // MARK: - Methods

    func finalGradeOutOfTwenty() -> String {
        "\(calculator.calculate().truncate(places: 2))/20"
    }

    private func hasSucceedExam() -> Bool {
        calculator.hasSucceed()
    }

    func admissionSentence() -> String {
        hasSucceedExam() ? "Admis" : "Non admis"
    }

    func mentionSentence() -> String {
        guard let mention = calculator.mention else { return "Sans mention" }
        return mention.name
    }

    func bestGrade() -> String {
        guard let bestExamGrade = simulation.bestExamGrade() else { return "--" }
        return "\(bestExamGrade)"
    }

    func worstGrade() -> String {
        guard let worstExamGrade = simulation.worstExamGrade() else { return "--" }
        return "\(worstExamGrade)"
    }
}
