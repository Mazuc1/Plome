//
//  SimulationTests.swift
//  PlomeCoreKitTests
//
//  Created by Loic Mazuc on 15/11/2022.
//

@testable import PlomeCoreKit
import XCTest

final class SimulationTests: XCTestCase {
    override func setUp() {
        super.setUp()
    }

    func testWhenAddExamThenExamIsAdded() {
        // Arrange
        let simulation = Simulation(name: "Test", date: nil, exams: .init(), type: .custom)

        // Act
        simulation.add(exam: .init(name: "", coefficient: nil, grade: nil, type: .trial))

        // Assert
        XCTAssertTrue(simulation.exams!.count > 0)
    }

    func testWhenRemoveExamThenExamIsRemoved() {
        // Arrange
        let simulation = Simulation(name: "Test", date: nil, exams: .init(), type: .custom)
        let exam: Exam = .init(name: "", coefficient: nil, grade: nil, type: .trial)
        simulation.add(exam: exam)

        // Act
        simulation.remove(exam: exam)

        // Assert
        XCTAssertTrue(simulation.exams!.count == 0)
    }

    // MARK: - examsContainTrials

    func testThatExamsContainTrialsWhenExamsContainsTrials() {
        // Arrange
        let simulation = Simulation(name: "Test", date: nil, exams: .init(), type: .custom)

        // Act
        simulation.add(exam: .init(name: "", coefficient: nil, grade: nil, type: .trial))

        // Assert
        XCTAssertTrue(simulation.examsContainTrials())
    }

    func testThatExamsDoNotContainTrialsWhenExamsIsNil() {
        // Arrange
        let simulation = Simulation(name: "Test", date: nil, exams: nil, type: .custom)

        // Assert
        XCTAssertFalse(simulation.examsContainTrials())
    }

    func testThatExamsDoNotContainTrialsWhenExamsDoNotContainsTrials() {
        // Arrange
        let simulation = Simulation(name: "Test", date: nil, exams: .init(), type: .custom)

        // Act
        simulation.add(exam: .init(name: "", coefficient: nil, grade: nil, type: .continuousControl))

        // Assert
        XCTAssertFalse(simulation.examsContainTrials())
    }

    // MARK: - examsContainContinuousControls

    func testThatExamsContainContinousControlWhenExamsContainsContinuousControl() {
        // Arrange
        let simulation = Simulation(name: "Test", date: nil, exams: .init(), type: .custom)

        // Act
        simulation.add(exam: .init(name: "", coefficient: nil, grade: nil, type: .continuousControl))

        // Assert
        XCTAssertTrue(simulation.examsContainContinuousControls())
    }

    func testThatExamsDoNotContainContinousControlWhenExamsIsNil() {
        // Arrange
        let simulation = Simulation(name: "Test", date: nil, exams: nil, type: .custom)

        // Assert
        XCTAssertFalse(simulation.examsContainContinuousControls())
    }

    func testThatExamsDoNotContainContinousControlWhenExamsDoNotContainsContinousControl() {
        // Arrange
        let simulation = Simulation(name: "Test", date: nil, exams: .init(), type: .custom)

        // Act
        simulation.add(exam: .init(name: "", coefficient: nil, grade: nil, type: .trial))

        // Assert
        XCTAssertFalse(simulation.examsContainContinuousControls())
    }

    // MARK: - examsContainOptions

    func testThatExamsContainOptionsWhenExamsContainsOptions() {
        // Arrange
        let simulation = Simulation(name: "Test", date: nil, exams: .init(), type: .custom)

        // Act
        simulation.add(exam: .init(name: "", coefficient: nil, grade: nil, type: .option))

        // Assert
        XCTAssertTrue(simulation.examsContainOptions())
    }

    func testThatExamsDoNotContainOptionsWhenExamsIsNil() {
        // Arrange
        let simulation = Simulation(name: "Test", date: nil, exams: nil, type: .custom)

        // Assert
        XCTAssertFalse(simulation.examsContainOptions())
    }

    func testThatExamsDoNotContainOptionsWhenExamsDoNotContainsOptions() {
        // Arrange
        let simulation = Simulation(name: "Test", date: nil, exams: .init(), type: .custom)

        // Act
        simulation.add(exam: .init(name: "", coefficient: nil, grade: nil, type: .trial))

        // Assert
        XCTAssertFalse(simulation.examsContainOptions())
    }

    // MARK: - gradeIsSetForAllExams

    func testWhenAllExamsGradeIsNotNilThenVerificationForAllExamsGradeIsSetSucceed() {
        // Arrange
        let simulation = Simulation(name: "Test", date: nil, exams: .init(), type: .custom)
        simulation.add(exam: .init(name: "", coefficient: nil, grade: "12/20", type: .trial))
        simulation.add(exam: .init(name: "", coefficient: nil, grade: "12/20", type: .trial))
        simulation.add(exam: .init(name: "", coefficient: nil, grade: "12/20", type: .trial))
        simulation.add(exam: .init(name: "", coefficient: nil, grade: "12/20", type: .trial))
        simulation.add(exam: .init(name: "", coefficient: nil, grade: "12/20", type: .trial))

        // Act
        let result = simulation.gradeIsSetForAllExams()

        // Assert
        XCTAssertTrue(result)
    }

    func testWhenAtLeastOneExamsGardeIsNilThenVerificationForAllExamsGradeIsSetFailed() {
        // Arrange
        let simulation = Simulation(name: "Test", date: nil, exams: .init(), type: .custom)
        simulation.add(exam: .init(name: "", coefficient: nil, grade: "12/20", type: .trial))
        simulation.add(exam: .init(name: "", coefficient: nil, grade: "12/20", type: .trial))
        simulation.add(exam: .init(name: "", coefficient: nil, grade: nil, type: .trial))
        simulation.add(exam: .init(name: "", coefficient: nil, grade: "12/20", type: .trial))
        simulation.add(exam: .init(name: "", coefficient: nil, grade: "12/20", type: .trial))

        // Act
        let result = simulation.gradeIsSetForAllExams()

        // Assert
        XCTAssertFalse(result)
    }

    func testWhenExamsIsNilThenVerificationForAllExamsGradeIsSetFailed() {
        // Arrange
        let simulation = Simulation(name: "Test", date: nil, exams: nil, type: .custom)

        // Act
        let result = simulation.gradeIsSetForAllExams()

        // Assert
        XCTAssertFalse(result)
    }

    // MARK: - exams(of:)

    func testWhenGettingExamsForRequestedTypeThenExamsAreReturnedInAlphabeticOrderWithGoodType() {
        // Arrange
        let simulation = Simulation(name: "Test", date: nil, exams: .init(), type: .custom)

        let exam: Exam = .init(name: "Art", coefficient: nil, grade: "12/20", type: .trial)
        let exam2: Exam = .init(name: "Some", coefficient: nil, grade: "12/20", type: .trial)
        let exam3: Exam = .init(name: "", coefficient: nil, grade: nil, type: .option)
        let exam4: Exam = .init(name: "Bo2", coefficient: nil, grade: "12/20", type: .trial)
        let exam5: Exam = .init(name: "", coefficient: nil, grade: "12/20", type: .continuousControl)

        let expectedResult = [exam, exam4, exam2]

        simulation.add(exam: exam5)
        simulation.add(exam: exam4)
        simulation.add(exam: exam2)
        simulation.add(exam: exam3)
        simulation.add(exam: exam)

        // Act
        let result = simulation.exams(of: .trial)

        // Assert
        XCTAssertEqual(result, expectedResult)
        XCTAssertEqual(result.count, 3)
    }

    func testThatGettingExamsForRequestedTypeWithExamsNilThenEmptyArrayIsReturned() {
        // Arrange
        let simulation = Simulation(name: "Test", date: nil, exams: nil, type: .custom)

        // Act
        let result = simulation.exams(of: .trial)

        // Assert
        XCTAssertEqual(result.count, 0)
    }

    // MARK: - number(of:)

    func testWhenCountingExamsForRequestedTypeThenExactCountIsReturned() {
        // Arrange
        let simulation = Simulation(name: "Test", date: nil, exams: .init(), type: .custom)

        let exam: Exam = .init(name: "Art", coefficient: nil, grade: "12/20", type: .option)
        let exam2: Exam = .init(name: "Some", coefficient: nil, grade: "12/20", type: .trial)
        let exam3: Exam = .init(name: "", coefficient: nil, grade: nil, type: .option)
        let exam4: Exam = .init(name: "Bo2", coefficient: nil, grade: "12/20", type: .trial)
        let exam5: Exam = .init(name: "", coefficient: nil, grade: "12/20", type: .continuousControl)

        simulation.add(exam: exam5)
        simulation.add(exam: exam4)
        simulation.add(exam: exam2)
        simulation.add(exam: exam3)
        simulation.add(exam: exam)

        // Act
        let result = simulation.number(of: .option)

        // Assert
        XCTAssertTrue(result == 2)
    }

    func testThatCountingExamsForRequestedTypeWithExamsNilThenZeroIsReturned() {
        // Arrange
        let simulation = Simulation(name: "Test", date: nil, exams: nil, type: .custom)

        // Act
        let result = simulation.number(of: .continuousControl)

        // Assert
        XCTAssertTrue(result == 0)
    }

    // MARK: - Worst grade

    func testThatWorstGradeIsReturned() {
        // Arrange
        let simulation = Simulation(name: "Test", date: nil, exams: .init(), type: .custom)

        let exam: Exam = .init(name: "", coefficient: nil, grade: "5/20", type: .option)
        let exam2: Exam = .init(name: "", coefficient: nil, grade: "2.75/20", type: .trial)
        let exam3: Exam = .init(name: "", coefficient: nil, grade: "3/20", type: .option)
        let exam4: Exam = .init(name: "", coefficient: nil, grade: "1.99/20", type: .trial)
        let exam5: Exam = .init(name: "", coefficient: nil, grade: "12/20", type: .continuousControl)

        simulation.add(exam: exam5)
        simulation.add(exam: exam4)
        simulation.add(exam: exam2)
        simulation.add(exam: exam3)
        simulation.add(exam: exam)

        // Act
        let result = simulation.worstExamGrade()

        // Assert
        XCTAssertTrue(result! == 1.99)
    }

    func testThatWorstGradeReturnsNilWhenExamsIsNil() {
        // Arrange
        let simulation = Simulation(name: "Test", date: nil, exams: nil, type: .custom)

        // Act
        let result = simulation.worstExamGrade()

        // Assert
        XCTAssertNil(result)
    }

    // MARK: - Best grade

    func testThatBestGradeIsReturned() {
        // Arrange
        let simulation = Simulation(name: "Test", date: nil, exams: .init(), type: .custom)

        let exam: Exam = .init(name: "", coefficient: nil, grade: "5/20", type: .option)
        let exam2: Exam = .init(name: "", coefficient: nil, grade: "18.75/20", type: .trial)
        let exam3: Exam = .init(name: "", coefficient: nil, grade: "13/20", type: .option)
        let exam4: Exam = .init(name: "", coefficient: nil, grade: "10.99/20", type: .trial)
        let exam5: Exam = .init(name: "", coefficient: nil, grade: "19.76/20", type: .continuousControl)

        simulation.add(exam: exam5)
        simulation.add(exam: exam4)
        simulation.add(exam: exam2)
        simulation.add(exam: exam3)
        simulation.add(exam: exam)

        // Act
        let result = simulation.bestExamGrade()

        // Assert
        XCTAssertTrue(result! == 19.76)
    }

    func testThatBestGradeReturnsNilWhenExamsIsNil() {
        // Arrange
        let simulation = Simulation(name: "Test", date: nil, exams: nil, type: .custom)

        // Act
        let result = simulation.bestExamGrade()

        // Assert
        XCTAssertNil(result)
    }
}
