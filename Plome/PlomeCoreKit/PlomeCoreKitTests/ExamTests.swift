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

    func testWhenSaveGradeWithBadEntryThenGradeIsNotSaved() {
        // Arrange
        let exam = Exam(name: "", coefficient: 1, grade: nil, type: .trial)

        // Act
        let result = exam.save("./20", ifIsConformTo: .grade)

        // Assert
        XCTAssertFalse(result)
        XCTAssertNil(exam.grade)
    }
}
