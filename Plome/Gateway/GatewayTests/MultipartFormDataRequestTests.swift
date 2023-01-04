//
//  MultipartFormDataRequestTests.swift
//  GatewayTests
//
//  Created by Loic Mazuc on 02/01/2023.
//

@testable import Gateway
import XCTest

final class MultipartFormDataRequestTests: XCTestCase {
    override func setUp() {
        super.setUp()
    }

    func testWhenBuildURLRequestWithTextFieldInBodyThenURLRequestIsBuiltWithTextField() throws {
        // Arrange
        let endPoint = TestEndPoint.test(someParameter: "plome").endPoint
        let multipartRequest = MultipartFormDataRequest(endPoint: endPoint)

        // Act
        let request = try multipartRequest.build()

        // Assert
        XCTAssertEqual(request.url!, URL(string: "https://google.com/plome")!)
        let splittedBody = String(decoding: request.httpBody!, as: UTF8.self).split(separator: "\r\n")

        XCTAssertEqual(splittedBody[4], "bodyContent")
        XCTAssertEqual(splittedBody[1], "Content-Disposition: form-data; name=\"bodyName\"")
    }

    func testWhenBuildURLRequestWithDataFieldInBodyThenURLRequestIsBuiltWithDataField() throws {
        // Arrange
        let endPoint = TestEndPoint.dataTest.endPoint
        let multipartRequest = MultipartFormDataRequest(endPoint: endPoint)

        // Act
        let request = try multipartRequest.build()

        // Assert
        XCTAssertEqual(request.url!, URL(string: "https://google.com/")!)
        let splittedBody = String(decoding: request.httpBody!, as: UTF8.self).split(separator: "\r\n")

        XCTAssertEqual(splittedBody[3], "Data")
    }
}
