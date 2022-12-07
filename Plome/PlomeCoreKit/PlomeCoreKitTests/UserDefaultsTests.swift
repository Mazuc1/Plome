//
//  UserDefaultsTests.swift
//  PlomeCoreKitTests
//
//  Created by Loic Mazuc on 02/12/2022.
//

@testable import PlomeCoreKit
import XCTest

final class UserDefaultsTests: XCTestCase {
    private var userDefauls: DefaultsProtocol!

    override func setUp() {
        super.setUp()
        userDefauls = Defaults(userDefaults: .init(suiteName: "UserDefaultTests")!)
    }

    func testSetData() {
        // Arrange
        userDefauls.setData(value: true, key: .userDefaultTest)

        // Act
        let result = userDefauls.getData(type: Bool.self, forKey: .userDefaultTest)

        // Assert
        XCTAssertEqual(result, true)
    }

    func testThatGetDataReturnsNilWhenNoDataHaveBeenSavedBefore() {
        // Arrange
        userDefauls.removeData(key: .userDefaultTest)

        // Act
        let result = userDefauls.getData(type: Bool.self, forKey: .userDefaultTest)

        // Assert
        XCTAssertNil(result)
    }
}
