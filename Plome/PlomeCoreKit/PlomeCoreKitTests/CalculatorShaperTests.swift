//
//  CalculatorShaperTests.swift
//  PlomeCoreKitTests
//
//  Created by Loic Mazuc on 07/12/2022.
//

@testable import PlomeCoreKit
@testable import PlomeCoreKitTestsHelpers
import XCTest

final class CalculatorShaperTests: XCTestCase {
    override func setUp() {
        super.setUp()
    }

    func testReturnsOfFinalGradeOutOfTwenty() {
        // Arrange
        let calculatorShaper = CalculatorShaperProvider.calculatorShaperWithExamSucceed()

        // Act
        let result = calculatorShaper.finalGradeOutOfTwenty()

        // Assert
        XCTAssertEqual(result, "12.4/20")
    }

    func testReturnsOfFinalGradeProgress() {
        // Arrange
        let calculatorShaper = CalculatorShaperProvider.calculatorShaperWithExamSucceed()

        // Act
        let result = calculatorShaper.finalGradeProgress()

        // Assert
        XCTAssertEqual(result, 0.62)
    }

    func testReturnsOfFinalGradeBeforeTwentyConform() {
        // Arrange
        let calculatorShaper = CalculatorShaperProvider.calculatorShaperWithExamSucceed()

        // Act
        let result = calculatorShaper.finalGradeBeforeTwentyConform()

        // Assert
        XCTAssertEqual(result, "446.67/720.0")
    }

    func testReturnsOfHasSucceedExamWithExamSuccess() {
        // Arrange
        let calculatorShaper = CalculatorShaperProvider.calculatorShaperWithExamSucceed()

        // Act
        let result = calculatorShaper.hasSucceedExam()

        // Assert
        XCTAssertTrue(result)
    }

    func testReturnsOfHasSucceedExamWithExamFailure() {
        // Arrange
        let calculatorShaper = CalculatorShaperProvider.calculatorShaperWithExamFailure()

        // Act
        let result = calculatorShaper.hasSucceedExam()

        // Assert
        XCTAssertFalse(result)
    }

    func testReturnsOfDisplayCatchUpSectionIfNeededWithExamSuccess() {
        // Arrange
        let calculatorShaper = CalculatorShaperProvider.calculatorShaperWithExamSucceed()

        // Act
        let result = calculatorShaper.displayCatchUpSectionIfNeeded()

        // Assert
        XCTAssertFalse(result)
    }

    func testReturnsOfDisplayCatchUpSectionIfNeededWithExamFailure() {
        // Arrange
        let calculatorShaper = CalculatorShaperProvider.calculatorShaperWithExamFailure()

        // Act
        let result = calculatorShaper.displayCatchUpSectionIfNeeded()

        // Assert
        XCTAssertTrue(result)
    }

    func testReturnsOfGetCatchUpInformationsWithExamSuccess() {
        // Arrange
        let calculatorShaper = CalculatorShaperProvider.calculatorShaperWithExamSucceed()

        // Act
        let result = calculatorShaper.getCatchUpInformations()

        // Assert
        XCTAssertNil(result)
    }

    func testReturnsOfGetCatchUpInformationsWithExamFailure() {
        // Arrange
        let calculatorShaper = CalculatorShaperProvider.calculatorShaperWithExamFailure()

        // Act
        let result = calculatorShaper.getCatchUpInformations()

        // Assert
        XCTAssertEqual(result?.grade.truncate(places: 2), 10.07)
        XCTAssertEqual(result?.difference.count, 11)
    }

    func testReturnsOfAdmissionSentenceWithExamSuccess() {
        // Arrange
        let calculatorShaper = CalculatorShaperProvider.calculatorShaperWithExamSucceed()

        // Act
        let result = calculatorShaper.admissionSentence()

        // Assert
        XCTAssertEqual(result, "You are admitted! 🥳")
    }

    func testReturnsOfAdmissionSentenceWithExamFailure() {
        // Arrange
        let calculatorShaper = CalculatorShaperProvider.calculatorShaperWithExamFailure()

        // Act
        let result = calculatorShaper.admissionSentence()

        // Assert
        XCTAssertEqual(result, "You are not admitted 😕")
    }

    func testReturnsOfResultSentenceWithExamSuccess() {
        // Arrange
        let calculatorShaper = CalculatorShaperProvider.calculatorShaperWithExamSucceed()

        // Act
        let result = calculatorShaper.resultSentence()

        // Assert
        XCTAssertEqual(result, "Congratulation !")
    }

    func testReturnsOfResultSentenceWithExamFailure() {
        // Arrange
        let calculatorShaper = CalculatorShaperProvider.calculatorShaperWithExamFailure()

        // Act
        let result = calculatorShaper.resultSentence()

        // Assert
        XCTAssertEqual(result, "Whoops...")
    }

    func testReturnsOfMentionSentenceWithExamSuccess() {
        // Arrange
        let calculatorShaper = CalculatorShaperProvider.calculatorShaperWithExamSucceed()

        // Act
        let result = calculatorShaper.mentionSentence()

        // Assert
        XCTAssertEqual(result, "Without mention")
    }

    func testReturnsOfMentionSentenceWithExamFailure() {
        // Arrange
        let calculatorShaper = CalculatorShaperProvider.calculatorShaperWithExamFailure()

        // Act
        let result = calculatorShaper.mentionSentence()

        // Assert
        XCTAssertEqual(result, "You cannot have a mention below the average")
    }

    func testReturnsOfTrialsGrade() {
        // Arrange
        let calculatorShaper = CalculatorShaperProvider.calculatorShaperWithExamSucceed()

        // Act
        let result = calculatorShaper.trialsGrade()

        // Assert
        XCTAssertEqual(result, "13.31/20")
    }

    func testReturnsOfTrialsGradeProgress() {
        // Arrange
        let calculatorShaper = CalculatorShaperProvider.calculatorShaperWithExamSucceed()

        // Act
        let result = calculatorShaper.trialsGradeProgress()

        // Assert
        XCTAssertEqual(result?.truncate(places: 2), 0.66)
    }

    func testReturnsOfContinuousControlGrade() {
        // Arrange
        let calculatorShaper = CalculatorShaperProvider.calculatorShaperWithExamSucceed()

        // Act
        let result = calculatorShaper.continousControlGrade()

        // Assert
        XCTAssertEqual(result, "12.12/20")
    }

    func testReturnsOfContinuousControlGradeProgress() {
        // Arrange
        let calculatorShaper = CalculatorShaperProvider.calculatorShaperWithExamSucceed()

        // Act
        let result = calculatorShaper.continuousControlGradeProgress()

        // Assert
        XCTAssertEqual(result?.truncate(places: 2), 0.60)
    }

    func testReturnsOfOptionsGrade() {
        // Arrange
        let calculatorShaper = CalculatorShaperProvider.calculatorShaperWithExamSucceed()

        // Act
        let result = calculatorShaper.optionGrade()

        // Assert
        XCTAssertEqual(result, "9.91/20")
    }

    func testReturnsOfOptionsGradeProgress() {
        // Arrange
        let calculatorShaper = CalculatorShaperProvider.calculatorShaperWithExamSucceed()

        // Act
        let result = calculatorShaper.optionsGradeProgress()

        // Assert
        XCTAssertEqual(result?.truncate(places: 2), 0.49)
    }

    func testReturnsOfSimulationContainTrials() {
        // Arrange
        let calculatorShaper = CalculatorShaperProvider.calculatorShaperWithExamSucceed()

        // Act
        let result = calculatorShaper.simulationContainTrials()

        // Assert
        XCTAssertTrue(result)
    }

    func testReturnsOfSimulationContainContinuousControls() {
        // Arrange
        let calculatorShaper = CalculatorShaperProvider.calculatorShaperWithExamSucceed()

        // Act
        let result = calculatorShaper.simulationContainContinousControls()

        // Assert
        XCTAssertTrue(result)
    }

    func testReturnsOfSimulationContainOptions() {
        // Arrange
        let calculatorShaper = CalculatorShaperProvider.calculatorShaperWithExamSucceed()

        // Act
        let result = calculatorShaper.simulationContainOptions()

        // Assert
        XCTAssertTrue(result)
    }

    func testReturnsOfMentionWithExamSuccess() {
        // Arrange
        let calculatorShaper = CalculatorShaperProvider.calculatorShaperWithExamSucceed()

        // Act
        let result = calculatorShaper.mention()

        // Assert
        XCTAssertEqual(result, .without)
    }

    func testReturnsOfMentionWithExamFailure() {
        // Arrange
        let calculatorShaper = CalculatorShaperProvider.calculatorShaperWithExamFailure()

        // Act
        let result = calculatorShaper.mention()

        // Assert
        XCTAssertNil(result)
    }

    func testReturnsOfGetExamGradeWhereIsBetter() {
        // Arrange
        let calculatorShaper = CalculatorShaperProvider.calculatorShaperWithExamSucceed()

        // Act
        let result = calculatorShaper.getExamGradeWhere(is: .better)

        // Assert
        XCTAssertEqual(result?.name, "BetterGrade")
    }

    func testReturnsOfGetExamGradeWhereIsWorst() {
        // Arrange
        let calculatorShaper = CalculatorShaperProvider.calculatorShaperWithExamSucceed()

        // Act
        let result = calculatorShaper.getExamGradeWhere(is: .worst)

        // Assert
        XCTAssertEqual(result?.name, "WorstGrade")
    }

    func testReturnsOfDate() {
        // Arrange
        let calculatorShaper = CalculatorShaperProvider.calculatorShaperWithExamSucceed()

        // Act
        let result = calculatorShaper.date(with: .classicPoint)

        // Assert
        XCTAssertEqual(result, "12.12.2012")
    }
}
