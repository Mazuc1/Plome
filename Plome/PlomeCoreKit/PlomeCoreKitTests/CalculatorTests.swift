//
//  CalculatorTests.swift
//  PlomeCoreKitTests
//
//  Created by Loic Mazuc on 16/11/2022.
//

@testable import PlomeCoreKit
import PlomeCoreKitTestsHelpers
import XCTest

final class CalculatorTests: XCTestCase {
    override func setUp() {
        super.setUp()
    }

    // MARK: - setMentionScore

    func testWhenInitCalculatorWithCustomSimulationTypeThenMentionScoreIsSet() {
        // Arrange
        let trials: [Exam] = [
            .init(name: "", coefficient: 1, grade: "14/20", type: .trial),
            .init(name: "", coefficient: 1, grade: "6/20", type: .trial),
            .init(name: "", coefficient: 1, grade: "13/20", type: .trial),
            .init(name: "", coefficient: 1, grade: "18/20", type: .trial),
            .init(name: "", coefficient: 1, grade: "15/20", type: .trial),
        ]
        let simulation = Simulation(name: "", date: nil, exams: .init(), type: .custom)
        _ = trials.map { simulation.add(exam: $0) }

        // Act
        let calculator = Calculator(simulation: simulation)
        calculator.calculate()

        // Assert
        XCTAssertEqual(calculator.withoutMentionScore, 50)
        XCTAssertEqual(calculator.ABMentionScore, 60)
        XCTAssertEqual(calculator.BMentionScore, 70)
        XCTAssertEqual(calculator.TBMentionScore, 80)
    }

    func testWhenInitCalculatorWithGeneralBACSimulationTypeThenMentionScoreIsSet() {
        // Arrange
        let simulation = Simulation(name: "", date: nil, exams: nil, type: .generalBAC)

        // Act
        let calculator = Calculator(simulation: simulation)
        calculator.calculate()

        // Assert
        XCTAssertEqual(calculator.withoutMentionScore, 1000)
        XCTAssertEqual(calculator.ABMentionScore, 1200)
        XCTAssertEqual(calculator.BMentionScore, 1400)
        XCTAssertEqual(calculator.TBMentionScore, 1600)
    }

    func testWhenInitCalculatorWithTechnologicalBACSimulationTypeThenMentionScoreIsSet() {
        // Arrange
        let simulation = Simulation(name: "", date: nil, exams: nil, type: .technologicalBAC)

        // Act
        let calculator = Calculator(simulation: simulation)
        calculator.calculate()

        // Assert
        XCTAssertEqual(calculator.withoutMentionScore, 1000)
        XCTAssertEqual(calculator.ABMentionScore, 1200)
        XCTAssertEqual(calculator.BMentionScore, 1400)
        XCTAssertEqual(calculator.TBMentionScore, 1600)
    }

    func testWhenInitCalculatorWithBrevetSimulationTypeThenMentionScoreIsSet() {
        // Arrange
        let simulation = Simulation(name: "", date: nil, exams: nil, type: .brevet)

        // Act
        let calculator = Calculator(simulation: simulation)
        calculator.calculate()

        // Assert
        XCTAssertEqual(calculator.withoutMentionScore, 400)
        XCTAssertEqual(calculator.ABMentionScore, 480)
        XCTAssertEqual(calculator.BMentionScore, 560)
        XCTAssertEqual(calculator.TBMentionScore, 640)
    }

    // MARK: - Mention set

    func testWhenCalculateWithSimulationFinalGradeIsLowerThanAnyMentionScoreThenMentionIsNotSet() {
        // Arrange
        let simulation = TestSimulations.generalBACSimulation(targetedMention: .bigFailure)
        let calculator = Calculator(simulation: simulation)

        // Act
        calculator.calculate()

        // Assert
        XCTAssertNil(calculator.mention)
    }

    func testWhenCalculateWithSimulationFinalGradeIsLowerThanABMentionScoreAndUpperThanWithoutMentionScoreThenMentionIsSetToWithout() {
        // Arrange
        let simulation = TestSimulations.generalBACSimulation(targetedMention: .without)
        let calculator = Calculator(simulation: simulation)

        // Act
        calculator.calculate()

        // Assert
        XCTAssertEqual(calculator.mention!, .without)
    }

    func testWhenCalculateWithSimulationFinalGradeIsLowerThanBMentionScoreAndUpperThanABMentionScoreThenMentionIsSetToAB() {
        // Arrange
        let simulation = TestSimulations.generalBACSimulation(targetedMention: .AB)
        let calculator = Calculator(simulation: simulation)

        // Act
        calculator.calculate()

        // Assert
        XCTAssertEqual(calculator.mention!, .AB)
    }

    func testWhenCalculateWithSimulationFinalGradeIsLowerThanTBMentionScoreAndUpperThanBMentionScoreThenMentionIsSetToB() {
        // Arrange
        let simulation = TestSimulations.generalBACSimulation(targetedMention: .B)
        let calculator = Calculator(simulation: simulation)

        // Act
        calculator.calculate()

        // Assert
        XCTAssertEqual(calculator.mention!, .B)
    }

    func testWhenCalculateWithSimulationFinalGradeIsUpperThanTBMentionScoreThenMentionIsSetToTB() {
        // Arrange
        let simulation = TestSimulations.generalBACSimulation(targetedMention: .TB)
        let calculator = Calculator(simulation: simulation)

        // Act
        calculator.calculate()

        // Assert
        XCTAssertEqual(calculator.mention!, .TB)
    }

    // MARK: - Calculate

    func testCalculation() {
        // Arrange
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

        // Act
        calculator.calculate()

        // Assert
        XCTAssertEqual(calculator.finalGrade.truncate(places: 2), 12.40)

        XCTAssertEqual(calculator.totalGrade.truncate(places: 2), 446.67)
        XCTAssertEqual(calculator.totalOutOf, 720)
        XCTAssertEqual(calculator.totalCoefficient, 36)

        XCTAssertEqual(calculator.trialsGrade, 13.3125)
        XCTAssertEqual(calculator.continousControlGrade, 12.125)
        XCTAssertEqual(calculator.optionsGrade!.truncate(places: 2), 9.91)
    }

    // MARK: - CatchUp

    func testCatchUp() {
        // Arrange
        let trials: [Exam] = [
            .init(name: "Math", coefficient: 4, grade: "7/20", type: .trial),
            .init(name: "Histoire", coefficient: 2, grade: "6/20", type: .trial),
            .init(name: "Sport", coefficient: 7, grade: "11/20", type: .trial),
            .init(name: "SVT", coefficient: 3, grade: "9/20", type: .trial),
        ]

        let continuousControl: [Exam] = [
            .init(name: "EMC", coefficient: 2, grade: "02/20", type: .continuousControl),
            .init(name: "Français", coefficient: 5, grade: "10/20", type: .continuousControl),
            .init(name: "Géo", coefficient: 1, grade: "8/20", type: .continuousControl),
            .init(name: "ToBeTest", coefficient: 8, grade: "9/20", type: .continuousControl),
        ]

        let options: [Exam] = [
            .init(name: "Latin", coefficient: 1, grade: "3/20", type: .option),
            .init(name: "Anglais", coefficient: 1, grade: "6/20", type: .option),
            .init(name: "Espagnol", coefficient: 1, grade: "13.45/20", type: .option),
            .init(name: "Allemand", coefficient: 1, grade: "08.22/20", type: .option),
        ]

        let simulation = Simulation(name: "", date: nil, exams: .init(), type: .custom)
        _ = trials.map { simulation.add(exam: $0) }
        _ = continuousControl.map { simulation.add(exam: $0) }
        _ = options.map { simulation.add(exam: $0) }

        let calculator = Calculator(simulation: simulation)

        // Act
        calculator.calculate()

        // Assert
        XCTAssertNotNil(calculator.gradeOutOfTwentyAfterCatchUp)
        XCTAssertNotNil(calculator.differenceAfterCatchUp)

        XCTAssertTrue(calculator.differenceAfterCatchUp!.count == 9)
        XCTAssertEqual(calculator.gradeOutOfTwentyAfterCatchUp!.truncate(places: 2), 10.07)

        let firstItem = calculator.differenceAfterCatchUp!.first { key, _ in
            key.name == "ToBeTest"
        }!

        XCTAssertEqual(firstItem.value, 3)
    }

    // MARK: - getExamWhereGrade

    func testThatGetWorstGradeReturnsTheWorstGrade() {
        // Arrange
        let trials: [Exam] = [
            .init(name: "", coefficient: 4, grade: "14/20", type: .trial),
            .init(name: "", coefficient: 2, grade: "6/20", type: .trial),
            .init(name: "", coefficient: 7, grade: "13/20", type: .trial),
            .init(name: "betterGrade", coefficient: 3, grade: "18/20", type: .trial),
        ]

        let continuousControl: [Exam] = [
            .init(name: "worstGrade", coefficient: 2, grade: "02/20", type: .continuousControl),
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

        // Act
        let result = calculator.getExamWhereGrade(is: .worst)

        // Assert
        XCTAssertEqual(result!.name, "worstGrade")
    }

    func testThatGetBetterGradeReturnsTheBetterGrade() {
        // Arrange
        let trials: [Exam] = [
            .init(name: "", coefficient: 4, grade: "14/20", type: .trial),
            .init(name: "", coefficient: 2, grade: "6/20", type: .trial),
            .init(name: "", coefficient: 7, grade: "13/20", type: .trial),
            .init(name: "betterGrade", coefficient: 3, grade: "18/20", type: .trial),
        ]

        let continuousControl: [Exam] = [
            .init(name: "worstGrade", coefficient: 2, grade: "02/20", type: .continuousControl),
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

        // Act
        let result = calculator.getExamWhereGrade(is: .better)

        // Assert
        XCTAssertEqual(result!.name, "betterGrade")
    }
}
