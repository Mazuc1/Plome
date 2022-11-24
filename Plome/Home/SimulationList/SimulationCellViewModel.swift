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
        calculator.calculate()
    }

    // MARK: - Methods

    func finalGradeOutOfTwenty() -> String {
        "\(calculator.finalGrade.truncate(places: 2))/20"
    }

    func finalGradeProgress() -> Float {
        calculator.finalGrade.truncate(places: 2) / 20
    }

    func hasSucceedExam() -> Bool {
        calculator.hasSucceed()
    }

    func admissionSentence() -> String {
        hasSucceedExam() ? "Admis" : "Non admis"
    }

    func date() -> String {
        guard let date = simulation.date else { return Date().toString(format: .classicPoint) }
        return date.toString(format: .classicPoint)
    }
}
