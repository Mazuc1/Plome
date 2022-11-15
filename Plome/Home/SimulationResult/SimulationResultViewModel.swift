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
    private let calculator: Calculator

    // MARK: - Init

    init(router: SimulationsRouter, simulation: Simulation) {
        self.router = router
        self.simulation = simulation

        calculator = .init(simulation: simulation)
    }

    // MARK: - Methods

    func finalGradeOutOfTwenty() -> String {
        "\(calculator.calculate().truncate(places: 2))/20"
    }

    func finalGradeBeforeTwentyConform() -> String {
        "\(calculator.totalGrade.truncate(places: 2))/\(calculator.totalOutOf.truncate(places: 0))"
    }

    func hasSucceedExam() -> Bool {
        calculator.hasSucceed()
    }

    func admissionSentence() -> String {
        hasSucceedExam() ? "Vous êtes admis ! 🥳" : "Vous n'êtes pas admis 😕"
    }

    func resultSentence() -> String {
        hasSucceedExam() ? "Félicitation !" : "Oups..."
    }

    func mentionSentence() -> String {
        guard let mention = calculator.mention else { return "Sans mention" }
        return mention.name
    }

    func trialsGrade() -> String {
        guard let grade = calculator.trialsGrade else { return "" }
        return "\(grade.truncate(places: 2))"
    }

    func continousControlGrade() -> String {
        guard let grade = calculator.continousControlGrade else { return "" }
        return "\(grade.truncate(places: 2))"
    }

    func optionGrade() -> String {
        guard let grade = calculator.optionsGrade else { return "" }
        return "\(grade.truncate(places: 2))"
    }

    func simulationContainTrials() -> Bool {
        simulation.examsContainTrials()
    }

    func simulationContainContinousControls() -> Bool {
        simulation.examsContainContinuousControls()
    }

    func simulationContainOptions() -> Bool {
        simulation.examsContainOptions()
    }
}
