//
//  EndPointTests.swift
//  GatewayTests
//
//  Created by Loic Mazuc on 04/01/2023.
//

import XCTest

final class EndPointTests: XCTestCase {
    override func setUp() {
        super.setUp()
    }

    func testThatEndPointFailsToBuild() {
        // Arrange
        let endPoint = TestEndPoint.failedBuild.endPoint

        // Act
        let url = endPoint.buildURL()

        // Assert
        XCTAssertNil(url)
    }

    func testThatEndPointSucceedsToBuild() {
        // Arrange
        let endPoint = TestEndPoint.successBuild.endPoint

        // Act
        let url = endPoint.buildURL()

        // Assert
        XCTAssertNotNil(url)
    }
}
