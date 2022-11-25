//
//  CalculatorShaper.swift
//  PlomeCoreKit
//
//  Created by Loic Mazuc on 24/11/2022.
//

import Foundation

public final class CalculatorShaper {
    // MARK: - Properties

    private let calculator: Calculator

    public var successAdmissionSentence: String = "Vous êtes admis ! 🥳"
    public var failureAdmissionSentence: String = "Vous n'êtes pas admis 😕"

    // MARK: - Init

    public init(calculator: Calculator) {
        self.calculator = calculator
    }

    // MARK: - Methods

    /// Get the final grade out of twenty, truncate by two places
    /// - Returns: Eg: "13.45/20"
    public func finalGradeOutOfTwenty() -> String {
        "\(calculator.finalGrade.truncate(places: 2))/20"
    }

    /// Get the final grade, truncate by two places
    /// - Returns: Eg: "1200.34/2000.0"
    public func finalGradeBeforeTwentyConform() -> String {
        "\(calculator.totalGrade.truncate(places: 2))/\(calculator.totalOutOf.truncate(places: 0))"
    }

    /// Returns if the exam succeed or failed
    /// - Returns: Bool
    public func hasSucceedExam() -> Bool {
        calculator.hasSucceed()
    }

    /// Returns if the exam need to be catchUp
    /// - Returns: Bool
    public func displayCatchUpSectionIfNeeded() -> Bool {
        !hasSucceedExam() && calculator.differenceAfterCatchUp != nil && calculator.gradeOutOfTwentyAfterCatchUp != nil
    }

    /// Get the catchUp informations. Returns tuple
    /// - Returns: Tuple.grade, the final grade after catchUp. Tuple.difference, dictionnary of Exam & Int. It contains all exam which points has been added and the difference in point between exam before and after catchUp
    public func getCatchUpInformations() -> (grade: Float, difference: [Exam: Int])? {
        guard let grade = calculator.gradeOutOfTwentyAfterCatchUp,
              let difference = calculator.differenceAfterCatchUp else { return nil }

        return (grade, difference)
    }

    /// Get the admission sentence depends of success of Exam
    /// - Returns: Eg: "Vous êtes admis"
    public func admissionSentence() -> String {
        hasSucceedExam() ? successAdmissionSentence : failureAdmissionSentence
    }

    /// Get the result sentence depends of success of Exam
    /// - Returns: "Féliciation" or "Oups..."
    public func resultSentence() -> String {
        hasSucceedExam() ? "Félicitation !" : "Oups..."
    }

    /// Get the mention sentence depends of Mention. If there are no mention, returns "Sans mention"
    /// - Returns: Eg: "Mention très bien"
    public func mentionSentence() -> String {
        guard let mention = calculator.mention else { return "Sans mention" }
        return mention.name
    }

    /// Get trials grade out of twenty, truncated by two places
    /// - Returns: Eg: "13.45/20"
    public func trialsGrade() -> String {
        guard let grade = calculator.trialsGrade else { return "" }
        return "\(grade.truncate(places: 2))/20"
    }

    /// Get continuousControl grade out of twenty, truncated by two places
    /// - Returns: Eg: "13.45/20"
    public func continousControlGrade() -> String {
        guard let grade = calculator.continousControlGrade else { return "" }
        return "\(grade.truncate(places: 2))/20"
    }

    /// Get options grade out of twenty, truncated by two places
    /// - Returns: Eg: "13.45/20"
    public func optionGrade() -> String {
        guard let grade = calculator.optionsGrade else { return "" }
        return "\(grade.truncate(places: 2))/20"
    }

    /// Returns if the simulation contains Trials
    /// - Returns: Bool
    public func simulationContainTrials() -> Bool {
        calculator.simulation.examsContainTrials()
    }

    /// Returns if the simulation contains Continuous control
    /// - Returns: Bool
    public func simulationContainContinousControls() -> Bool {
        calculator.simulation.examsContainContinuousControls()
    }

    /// Returns if the simulation contains Options
    /// - Returns: Bool
    public func simulationContainOptions() -> Bool {
        calculator.simulation.examsContainOptions()
    }

    /// Get the simulation date. If there no date, return current date
    /// - Parameter format: Format of the date
    /// - Returns: Date convert to string with the desire format
    public func date(with format: Date.DateFormat) -> String {
        guard let date = calculator.simulation.date else { return Date().toString(format: format) }
        return date.toString(format: format)
    }

    /// Returns the mention is there is any one
    /// - Returns: Optional mention
    public func mention() -> Mention? {
        calculator.mention
    }
}
