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
    let simulation: Simulation
    private let calculator: Calculator

    // MARK: - Init

    init(router: SimulationsRouter, simulation: Simulation) {
        self.router = router
        self.simulation = simulation

        calculator = Calculator(simulation: simulation)
        calculator.calculate()
    }

    // MARK: - Methods

    func finalGradeOutOfTwenty() -> String {
        "\(calculator.finalGrade.truncate(places: 2))/20"
    }

    func hasSucceedExam() -> Bool {
        calculator.hasSucceed()
    }

    func displayCatchUpSectionIfNeeded() -> Bool {
        !hasSucceedExam() && calculator.differenceAfterCatchUp != nil && calculator.gradeOutOfTwentyAfterCatchUp != nil
    }

    func getCatchUpInformations() -> (grade: Float, difference: [Exam: Int])? {
        guard let grade = calculator.gradeOutOfTwentyAfterCatchUp,
              let difference = calculator.differenceAfterCatchUp else { return nil }

        return (grade, difference)
    }

    func admissionSentence() -> String {
        hasSucceedExam() ? "Admis" : "Non admis"
    }

    func date() -> Date {
        guard let date = simulation.date else { return Date() }
        return date
    }

    func mention() -> Mention? {
        calculator.mention
    }
}
