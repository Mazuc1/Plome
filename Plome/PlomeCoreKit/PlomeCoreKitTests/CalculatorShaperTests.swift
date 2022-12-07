//
//  CalculatorShaperTests.swift
//  PlomeCoreKitTests
//
//  Created by Loic Mazuc on 07/12/2022.
//

@testable import PlomeCoreKit
import XCTest

final class CalculatorShaperTests: XCTestCase {
    private var calculatorShaper: CalculatorShaper!
    
    override func setUp() {
        super.setUp()
        let trials: [Exam] = [
            .init(name: "", coefficient: 4, grade: "14/20", type: .trial),
            .init(name: "", coefficient: 2, grade: "6/20", type: .trial),
            .init(name: "", coefficient: 7, grade: "13/20", type: .trial),
            .init(name: "", coefficient: 3, grade: "18/20", type: .trial),
        ]

        let continuousControl: [Exam] = [
            .init(name: "", coefficient: 2, grade: "02/20", type: .continuousControl),
            .init(name: "", coefficient: 5, grade: "15/20", type: .continuousControl),
            .init(name: "", coefficient: 1, grade: "11/20", type: .continuousControl),
            .init(name: "", coefficient: 8, grade: "13/20", type: .continuousControl),
        ]

        let options: [Exam] = [
            .init(name: "", coefficient: 1, grade: "12/20", type: .option),
            .init(name: "", coefficient: 1, grade: "6/20", type: .option),
            .init(name: "", coefficient: 1, grade: "13.45/20", type: .option),
            .init(name: "", coefficient: 1, grade: "08.22/20", type: .option),
        ]

        let simulation = Simulation(name: "", date: nil, exams: .init(), type: .custom)
        _ = trials.map { simulation.add(exam: $0) }
        _ = continuousControl.map { simulation.add(exam: $0) }
        _ = options.map { simulation.add(exam: $0) }
        
        let calculator = Calculator(simulation: simulation)
        calculatorShaper = CalculatorShaper(calculator: calculator)
    }
    
    func testReturnsOfFinalGradeOutOfTwenty() {
        // Act
        let result = calculatorShaper.finalGradeOutOfTwenty()
        
        // Assert
        XCTAssertEqual(result, "12.40/20")
    }

}

/*
 XCTAssertEqual(calculator.finalGrade.truncate(places: 2), 12.40)

 XCTAssertEqual(calculator.totalGrade.truncate(places: 2), 446.67)
 XCTAssertEqual(calculator.totalOutOf, 720)
 XCTAssertEqual(calculator.totalCoefficient, 36)

 XCTAssertEqual(calculator.trialsGrade, 13.3125)
 XCTAssertEqual(calculator.continousControlGrade, 12.125)
 XCTAssertEqual(calculator.optionsGrade!.truncate(places: 2), 9.91)
 */

/*
 /// Get the final grade out of twenty, truncate by two places
 /// - Returns: Eg: "13.45/20"
 public func finalGradeOutOfTwenty() -> String {
     "\(calculator.finalGrade.truncate(places: 2))/20"
 }

 /// Get the progress of the final grade
 /// - Returns: Eg: 0.63
 public func finalGradeProgress() -> Float {
     calculator.finalGrade.truncate(places: 2) / 20
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

 /// Get the progress of the trials grade
 /// - Returns: Eg: 0.63
 public func trialsGradeProgress() -> Float? {
     guard let grade = calculator.trialsGrade else { return nil }
     return grade / 20
 }

 /// Get continuousControl grade out of twenty, truncated by two places
 /// - Returns: Eg: "13.45/20"
 public func continousControlGrade() -> String {
     guard let grade = calculator.continousControlGrade else { return "" }
     return "\(grade.truncate(places: 2))/20"
 }

 /// Get the progress of the continuous control grade
 /// - Returns: Eg: 0.63
 public func continuousControlGradeProgress() -> Float? {
     guard let grade = calculator.continousControlGrade else { return nil }
     return grade / 20
 }

 /// Get options grade out of twenty, truncated by two places
 /// - Returns: Eg: "13.45/20"
 public func optionGrade() -> String {
     guard let grade = calculator.optionsGrade else { return "" }
     return "\(grade.truncate(places: 2))/20"
 }

 /// Get the progress of the continuous control grade
 /// - Returns: Eg: 0.63
 public func optionsGradeProgress() -> Float? {
     guard let grade = calculator.optionsGrade else { return nil }
     return grade / 20
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

 /// Get exam depends of paramters
 /// - Parameter type: Type of exam grade: worst or better
 /// - Returns: Returns the better or worst exam grade
 public func getExamGradeWhere(is type: GradeType) -> Exam? {
     calculator.getExamWhereGrade(is: type)
 }
 */
