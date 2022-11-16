//
//  CalculatorTests.swift
//  PlomeCoreKitTests
//
//  Created by Loic Mazuc on 16/11/2022.
//

@testable import PlomeCoreKit
import XCTest

final class CalculatorTests: XCTestCase {
    override func setUp() {
        super.setUp()
    }

    // MARK: - setMention

    func testWhenInitCalculatorWithCustomSimulationTypeThenMentionScoreIsSet() {
        // Arrange
        let simulation = Simulation(name: "", date: nil, exams: nil, type: .custom)

        // Act
        let calculator = Calculator(simulation: simulation)

        // Assert

        XCTAssertEqual(calculator.withoutMentionScore, 1000)
        XCTAssertEqual(calculator.ABMentionScore, 1200)
        XCTAssertEqual(calculator.BMentionScore, 1400)
        XCTAssertEqual(calculator.TBMentionScore, 1600)
    }

    func testWhenInitCalculatorWithGeneralBACSimulationTypeThenMentionScoreIsSet() {
        // Arrange
        let simulation = Simulation(name: "", date: nil, exams: nil, type: .generalBAC)

        // Act
        let calculator = Calculator(simulation: simulation)

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

        // Assert

        XCTAssertEqual(calculator.withoutMentionScore, 400)
        XCTAssertEqual(calculator.ABMentionScore, 480)
        XCTAssertEqual(calculator.BMentionScore, 560)
        XCTAssertEqual(calculator.TBMentionScore, 640)
    }

    // MARK: - Mention set

    func testWhenCalculateWithSimulationFinalGradeIsLowerThanAnyMentionScoreThenMentionIsNotSet() {
        // Arrange
        let simulation = TestSimulations.generalBACSimulation(targetedMention: .failure)
        let calculator = Calculator(simulation: simulation)

        // Act
        _ = calculator.calculate()

        // Assert
        XCTAssertNil(calculator.mention)
    }

    func testWhenCalculateWithSimulationFinalGradeIsLowerThanABMentionScoreAndUpperThanWithoutMentionScoreThenMentionIsSetToWithout() {
        // Arrange
        let simulation = TestSimulations.generalBACSimulation(targetedMention: .without)
        let calculator = Calculator(simulation: simulation)

        // Act
        _ = calculator.calculate()

        // Assert
        XCTAssertEqual(calculator.mention!, .without)
    }

    func testWhenCalculateWithSimulationFinalGradeIsLowerThanBMentionScoreAndUpperThanABMentionScoreThenMentionIsSetToAB() {
        // Arrange
        let simulation = TestSimulations.generalBACSimulation(targetedMention: .AB)
        let calculator = Calculator(simulation: simulation)

        // Act
        _ = calculator.calculate()

        // Assert
        XCTAssertEqual(calculator.mention!, .AB)
    }

    func testWhenCalculateWithSimulationFinalGradeIsLowerThanTBMentionScoreAndUpperThanBMentionScoreThenMentionIsSetToB() {
        // Arrange
        let simulation = TestSimulations.generalBACSimulation(targetedMention: .B)
        let calculator = Calculator(simulation: simulation)

        // Act
        _ = calculator.calculate()

        // Assert
        XCTAssertEqual(calculator.mention!, .B)
    }

    func testWhenCalculateWithSimulationFinalGradeIsUpperThanTBMentionScoreThenMentionIsSetToTB() {
        // Arrange
        let simulation = TestSimulations.generalBACSimulation(targetedMention: .TB)
        let calculator = Calculator(simulation: simulation)

        // Act
        _ = calculator.calculate()

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
        let result = calculator.calculate()

        // Assert
        XCTAssertEqual(result.truncate(places: 2), 12.40)

        XCTAssertEqual(calculator.totalGrade.truncate(places: 2), 446.67)
        XCTAssertEqual(calculator.totalOutOf, 720)
        XCTAssertEqual(calculator.totalCoefficient, 36)

        XCTAssertEqual(calculator.trialsGrade, 13.3125)
        XCTAssertEqual(calculator.continousControlGrade, 12.125)
        XCTAssertEqual(calculator.optionsGrade!.truncate(places: 2), 9.91)
    }
}
