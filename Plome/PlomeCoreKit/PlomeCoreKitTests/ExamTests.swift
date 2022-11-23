//
//  ExamTests.swift
//  ExamTests
//
//  Created by Loic Mazuc on 04/10/2022.
//

@testable import PlomeCoreKit
import XCTest

final class ExamTests: XCTestCase {
    override func setUp() {
        super.setUp()
    }

    // MARK: - Bad grade entry, rejected by regex

    func testWhenSaveGradeWithBadEntryThenGradeIsNotSaved() {
        // Arrange
        let exam = Exam(name: "", coefficient: 1, grade: nil, type: .trial)

        // Act
        let result = exam.save("./20", ifIsConformTo: .grade)

        // Assert
        XCTAssertFalse(result)
        XCTAssertNil(exam.grade)
    }

    func testWhenSaveGradeWithBadEntry2ThenGradeIsNotSaved() {
        // Arrange
        let exam = Exam(name: "", coefficient: 1, grade: nil, type: .trial)

        // Act
        let result = exam.save("12/.", ifIsConformTo: .grade)

        // Assert
        XCTAssertFalse(result)
        XCTAssertNil(exam.grade)
    }

    func testWhenSaveGradeWithBadEntry3ThenGradeIsNotSaved() {
        // Arrange
        let exam = Exam(name: "", coefficient: 1, grade: nil, type: .trial)

        // Act
        let result = exam.save("", ifIsConformTo: .grade)

        // Assert
        XCTAssertFalse(result)
        XCTAssertNil(exam.grade)
    }

    func testWhenSaveGradeWithBadEntry4ThenGradeIsNotSaved() {
        // Arrange
        let exam = Exam(name: "", coefficient: 1, grade: nil, type: .trial)

        // Act
        let result = exam.save("/", ifIsConformTo: .grade)

        // Assert
        XCTAssertFalse(result)
        XCTAssertNil(exam.grade)
    }

    func testWhenSaveGradeWithBadEntry5ThenGradeIsNotSaved() {
        // Arrange
        let exam = Exam(name: "", coefficient: 1, grade: nil, type: .trial)

        // Act
        let result = exam.save("12.345/20", ifIsConformTo: .grade)

        // Assert
        XCTAssertFalse(result)
        XCTAssertNil(exam.grade)
    }

    func testWhenSaveGradeWithBadEntry6ThenGradeIsNotSaved() {
        // Arrange
        let exam = Exam(name: "", coefficient: 1, grade: nil, type: .trial)

        // Act
        let result = exam.save("12/20.345", ifIsConformTo: .grade)

        // Assert
        XCTAssertFalse(result)
        XCTAssertNil(exam.grade)
    }

    // MARK: - Bad coeff entry, rejected by regex

    func testWhenSaveCoeffWithBadEntryThenCoeffIsNotSaved() {
        // Arrange
        let exam = Exam(name: "", coefficient: 1, grade: nil, type: .trial)

        // Act
        let result = exam.save(".10", ifIsConformTo: .coeff)

        // Assert
        XCTAssertFalse(result)
        XCTAssertNil(exam.coefficient)
    }

    func testWhenSaveCoeffWithBadEntry2ThenCoeffIsNotSaved() {
        // Arrange
        let exam = Exam(name: "", coefficient: 1, grade: nil, type: .trial)

        // Act
        let result = exam.save("10.112", ifIsConformTo: .coeff)

        // Assert
        XCTAssertFalse(result)
        XCTAssertNil(exam.coefficient)
    }

    func testWhenSaveCoeffWithBadEntry3ThenCoeffIsNotSaved() {
        // Arrange
        let exam = Exam(name: "", coefficient: 1, grade: nil, type: .trial)

        // Act
        let result = exam.save("", ifIsConformTo: .coeff)

        // Assert
        XCTAssertFalse(result)
        XCTAssertNil(exam.coefficient)
    }

    func testWhenSaveCoeffWithBadEntry4ThenCoeffIsNotSaved() {
        // Arrange
        let exam = Exam(name: "", coefficient: 1, grade: nil, type: .trial)

        // Act
        let result = exam.save("test", ifIsConformTo: .coeff)

        // Assert
        XCTAssertFalse(result)
        XCTAssertNil(exam.coefficient)
    }

    // MARK: - Good grade entry, accepted by regex

    func testWhenSaveGradeWithGoodEntryThenGradeIsSaved() {
        // Arrange
        let exam = Exam(name: "", coefficient: 1, grade: nil, type: .trial)

        // Act
        let result = exam.save("10/20", ifIsConformTo: .grade)

        // Assert
        XCTAssertTrue(result)
        XCTAssertNotNil(exam.grade)
    }

    func testWhenSaveGradeWithGoodEntry2ThenGradeIsSaved() {
        // Arrange
        let exam = Exam(name: "", coefficient: 1, grade: nil, type: .trial)

        // Act
        let result = exam.save("1/20", ifIsConformTo: .grade)

        // Assert
        XCTAssertTrue(result)
        XCTAssertNotNil(exam.grade)
    }

    func testWhenSaveGradeWithGoodEntry3ThenGradeIsSaved() {
        // Arrange
        let exam = Exam(name: "", coefficient: 1, grade: nil, type: .trial)

        // Act
        let result = exam.save("10.20/20", ifIsConformTo: .grade)

        // Assert
        XCTAssertTrue(result)
        XCTAssertNotNil(exam.grade)
    }

    func testWhenSaveGradeWithGoodEntry4ThenGradeIsSaved() {
        // Arrange
        let exam = Exam(name: "", coefficient: 1, grade: nil, type: .trial)

        // Act
        let result = exam.save("10/20.45", ifIsConformTo: .grade)

        // Assert
        XCTAssertTrue(result)
        XCTAssertNotNil(exam.grade)
    }

    // MARK: - Good coeff entry, accepted by regex

    func testWhenSaveCoeffWithGoodEntryThenCoeffIsSaved() {
        // Arrange
        let exam = Exam(name: "", coefficient: 1, grade: nil, type: .trial)

        // Act
        let result = exam.save("10", ifIsConformTo: .coeff)

        // Assert
        XCTAssertTrue(result)
        XCTAssertEqual(exam.coefficient, 10)
    }

    func testWhenSaveCoeffWithGoodEntry2ThenCoeffIsSaved() {
        // Arrange
        let exam = Exam(name: "", coefficient: 1, grade: nil, type: .trial)

        // Act
        let result = exam.save("10.12", ifIsConformTo: .coeff)

        // Assert
        XCTAssertTrue(result)
        XCTAssertEqual(exam.coefficient, 10.12)
    }

    func testWhenSaveCoeffWithGoodEntry3ThenCoeffIsSaved() {
        // Arrange
        let exam = Exam(name: "", coefficient: 1, grade: nil, type: .trial)

        // Act
        let result = exam.save("2", ifIsConformTo: .coeff)

        // Assert
        XCTAssertTrue(result)
        XCTAssertEqual(exam.coefficient, 2)
    }

    // MARK: - Grade ratio

    func testThatRatioOfGradeIsCorrectWhenGradeIsLowerThanItsRatio() {
        // Arrange
        let exam = Exam(name: "", coefficient: 1, grade: nil, type: .trial)

        // Act
        let result = exam.checkRatioFor("12/20")

        // Assert
        XCTAssertTrue(result)
    }

    func testThatRatioOfGradeIsCorrectWhenGradeIsEqualToItsRatio() {
        // Arrange
        let exam = Exam(name: "", coefficient: 1, grade: nil, type: .trial)

        // Act
        let result = exam.checkRatioFor("20/20")

        // Assert
        XCTAssertTrue(result)
    }

    func testThatRatioOfGradeIsIncorrectWhenGradeIsUpperThanItsRatio() {
        // Arrange
        let exam = Exam(name: "", coefficient: 1, grade: nil, type: .trial)

        // Act
        let result = exam.checkRatioFor("21/20")

        // Assert
        XCTAssertFalse(result)
    }

    func testThatRatioOfGradeIsIncorrectWhenGradeFormatIsIncorrect() {
        // Arrange
        let exam = Exam(name: "", coefficient: 1, grade: nil, type: .trial)

        // Act
        let result = exam.checkRatioFor("./20")

        // Assert
        XCTAssertFalse(result)
    }

    // MARK: - Grade informations

    func testWhenGetGradeInformationThenInformationsAreReturned() {
        // Arrange
        let exam = Exam(name: "", coefficient: 1, grade: "10/20", type: .trial)

        // Act
        let result = exam.getGradeInformation()

        // Assert
        XCTAssertEqual(result.lhs, 10)
        XCTAssertEqual(result.rhs, 20)
        XCTAssertEqual(result.coeff, 1)
    }

    func testWhenGetGradeInformationWithBadGradeFormatThenDefaultInformationsAreReturned() {
        // Arrange
        let exam = Exam(name: "", coefficient: 1, grade: "./20", type: .trial)

        // Act
        let result = exam.getGradeInformation()

        // Assert
        XCTAssertEqual(result.lhs, -1)
        XCTAssertEqual(result.rhs, -1)
        XCTAssertEqual(result.coeff, -1)
    }

    func testWhenGetGradeInformationWithoutCoefficientSpecifiedThenInformationsWithDefaultCoefficientAreReturned() {
        // Arrange
        let exam = Exam(name: "", coefficient: nil, grade: "10/20", type: .trial)

        // Act
        let result = exam.getGradeInformation()

        // Assert
        XCTAssertEqual(result.lhs, 10)
        XCTAssertEqual(result.rhs, 20)
        XCTAssertEqual(result.coeff, 1)
    }

    func testThatTruncatedGradeReturnsTwoDigitsAfterPoint() {
        // Arrange
        let exam = Exam(name: "", coefficient: nil, grade: "10.4678332/20", type: .trial)

        // Act
        let result = exam.truncatedGrade()

        // Assert
        XCTAssertEqual(result!, "10.46/20")
    }

    func testThatTruncatedGradeWithNilValueOfGradeReturnsNil() {
        // Arrange
        let exam = Exam(name: "", coefficient: nil, grade: nil, type: .trial)

        // Act
        let result = exam.truncatedGrade()

        // Assert
        XCTAssertNil(result)
    }
}
