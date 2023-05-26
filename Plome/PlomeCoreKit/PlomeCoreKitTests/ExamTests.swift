//
//  ExamTests.swift
//  ExamTests
//
//  Created by Loic Mazuc on 04/10/2022.
//

@testable import PlomeCoreKit
@testable import PlomeCoreKitTestsHelpers
import XCTest

final class ExamTests: XCTestCase {
    override func setUp() {
        super.setUp()
    }

    func testThatGradeIsCorrectlySaved() {
        // Arrange
        let exam = Exam(name: "", coefficient: nil, grade: nil, ratio: 2, type: .trial)

        // Act
        _ = exam.saveIfRulesAreRespected("1", in: .grade)

        // Assert
        XCTAssertEqual(exam.grade, 1)
    }

    func testThatSavingGradeGeaterThanRatioFailed() {
        // Arrange
        let exam = Exam(name: "", coefficient: nil, grade: nil, ratio: 20, type: .trial)

        // Act
        let result = exam.saveIfRulesAreRespected("21", in: .grade)

        // Assert
        XCTAssertFalse(result)
    }

    func testThatGradeIsNotSavedWhenTheSaveValueIsNotConform() {
        // Arrange
        let exam = Exam(name: "", coefficient: nil, grade: nil, ratio: nil, type: .trial)

        // Act
        let result = exam.saveIfRulesAreRespected("@@", in: .grade)

        // Assert
        XCTAssertFalse(result)
    }

    func testThatGradeIsSavedWhenTheSaveValueIsEmpty() {
        // Arrange
        let exam = Exam(name: "", coefficient: nil, grade: nil, ratio: nil, type: .trial)

        // Act
        let result = exam.saveIfRulesAreRespected("", in: .grade)

        // Assert
        XCTAssertTrue(result)
    }

    func testThatRatioIsCorrectlySaved() {
        // Arrange
        let exam = Exam(name: "", coefficient: nil, grade: nil, ratio: nil, type: .trial)

        // Act
        _ = exam.saveIfRulesAreRespected("1", in: .ratio)

        // Assert
        XCTAssertEqual(exam.ratio, 1)
    }

    func testThatRatioIsNotSavedWhenTheSaveValueIsNotConform() {
        // Arrange
        let exam = Exam(name: "", coefficient: nil, grade: nil, ratio: nil, type: .trial)

        // Act
        let result = exam.saveIfRulesAreRespected("@@", in: .ratio)

        // Assert
        XCTAssertFalse(result)
    }

    func testThatRatioIsSavedWhenTheSaveValueIsEmpty() {
        // Arrange
        let exam = Exam(name: "", coefficient: nil, grade: nil, ratio: nil, type: .trial)

        // Act
        let result = exam.saveIfRulesAreRespected("", in: .ratio)

        // Assert
        XCTAssertTrue(result)
    }

    func testThatCoefficientIsCorrectlySaved() {
        // Arrange
        let exam = Exam(name: "", coefficient: nil, grade: nil, ratio: nil, type: .trial)

        // Act
        _ = exam.saveIfRulesAreRespected("1", in: .coeff)

        // Assert
        XCTAssertEqual(exam.coefficient, 1)
    }

    func testThatCoefficientIsNotSavedWhenTheSaveValueIsNotConform() {
        // Arrange
        let exam = Exam(name: "", coefficient: nil, grade: nil, ratio: nil, type: .trial)

        // Act
        let result = exam.saveIfRulesAreRespected("abc", in: .coeff)

        // Assert
        XCTAssertFalse(result)
    }

    func testThatCoefficientIsSavedWhenTheSaveValueIsEmpty() {
        // Arrange
        let exam = Exam(name: "", coefficient: nil, grade: nil, ratio: nil, type: .trial)

        // Act
        let result = exam.saveIfRulesAreRespected("", in: .coeff)

        // Assert
        XCTAssertTrue(result)
    }

    func testThatGradeInformationIsCorrectlyReturned() {
        // Arrange
        let exam = Exam(name: "", coefficient: 1, grade: 2, ratio: 3, type: .trial)

        // Act
        let result = exam.getGradeInformation()

        // Assert
        XCTAssertEqual(result.lhs, 2)
        XCTAssertEqual(result.rhs, 3)
        XCTAssertEqual(result.coeff, 1)
    }

    func testWhenGradeOrRatioInformationIsMissingThenDefaultGradeInformationIsReturned() {
        // Arrange
        let exam = Exam(name: "", coefficient: 1, grade: nil, ratio: nil, type: .trial)

        // Act
        let result = exam.getGradeInformation()

        // Assert
        XCTAssertEqual(result.lhs, -1)
        XCTAssertEqual(result.rhs, -1)
        XCTAssertEqual(result.coeff, -1)
    }

    func testWhenGradeIsLowerThanRatioThenReturnedTrue() {
        // Arrange
        let exam = Exam(name: "", coefficient: nil, grade: 2, ratio: 6, type: .trial)

        // Act
        let result = exam.isGradeLowerThanAverageRatio()

        // Assert
        XCTAssertTrue(result)
    }

    func testWhenGradeIsUpperThanRatioThenReturnedFalse() {
        // Arrange
        let exam = Exam(name: "", coefficient: nil, grade: 4, ratio: 6, type: .trial)

        // Act
        let result = exam.isGradeLowerThanAverageRatio()

        // Assert
        XCTAssertFalse(result)
    }

    func testWhenAddOnePointToGradeThenOnePointIsAdded() {
        // Arrange
        let exam = Exam(name: "", coefficient: nil, grade: 4, ratio: 6, type: .trial)

        // Act
        exam.addOnePoint()

        // Assert
        XCTAssertEqual(exam.grade, 5)
    }

    func testThatAddOnePointToGradeWhenGradeIsEqualToRatioThenOnePointIsNotAdded() {
        // Arrange
        let exam = Exam(name: "", coefficient: nil, grade: 6, ratio: 6, type: .trial)

        // Act
        exam.addOnePoint()

        // Assert
        XCTAssertEqual(exam.grade, 6)
    }

    func testThatTruncatedGradeReturnsNilWhenGradeOrRatioIsNil() {
        // Arrange
        let exam = Exam(name: "", coefficient: nil, grade: nil, ratio: 6, type: .trial)

        // Act
        let result = exam.truncatedGrade()

        // Assert
        XCTAssertNil(result)
    }

    func testThatTruncatedGradeReturnsStringGrade() {
        // Arrange
        let exam = Exam(name: "", coefficient: nil, grade: 4, ratio: 6, type: .trial)

        // Act
        let result = exam.truncatedGrade()

        // Assert
        XCTAssertNotNil(result)
    }

    func testWhenEncodingExamThenEncodeSucceed() {
        // Arrange
        let exam = Exam(name: "Test", coefficient: 1, grade: 4, ratio: 6, type: .trial)

        // Assert
        XCTAssertNoThrow(try JSONEncoder().encode(exam))
    }

    func testThatExamCreateFromJSON() {
        // Act
        let exam = Exam.createFromJson(sender: self)

        // Assert
        XCTAssertEqual(exam.name, "Test")
        XCTAssertEqual(exam.coefficient, 1)
        XCTAssertEqual(exam.type, .trial)
        XCTAssertEqual(exam.grade, 12)
        XCTAssertEqual(exam.ratio, 20)
    }
}
