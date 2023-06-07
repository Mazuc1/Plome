//
//  OnboardingFlowControllerTests.swift
//  PlomeTests
//
//  Created by Loic Mazuc on 22/12/2022.
//

@testable import Plome
@testable import PlomeCoreKit
import XCTest

final class OnboardingFlowControllerTests: XCTestCase {
    override func setUp() {
        super.setUp()
    }

    func testShouldPresentOnboardingReturnsFalseWhenOnboardingHasNotBeenSeen() {
        // Arrange
        let userDefault = Defaults(userDefaults: .init())
        userDefault.setData(value: false, key: .hasOnboardingBeenSeen)

        CoreKitContainer.shared.userDefault.register { userDefault }

        let onboardingFlowController = OnboardingFlowController(screens: .init())

        // Act
        let result = onboardingFlowController.shouldPresentOnboarding()

        // Assert
        XCTAssertFalse(result)
    }

    func testShouldPresentOnboardingReturnsTrueWhenOnboardingHasBeenSeen() {
        // Arrange
        let userDefault = Defaults(userDefaults: .init())
        userDefault.setData(value: true, key: .hasOnboardingBeenSeen)

        CoreKitContainer.shared.userDefault.register { userDefault }
        let onboardingFlowController = OnboardingFlowController(screens: .init())

        // Act
        let result = onboardingFlowController.shouldPresentOnboarding()

        // Assert
        XCTAssertTrue(result)
    }

    func testThatOnFinishedIsCalledWhenUserFinishOnboarding() {
        // Arrange
        let expectation = expectation(description: #function)

        CoreKitContainer.shared.userDefault.register { Defaults() }
        let onboardingFlowController = OnboardingFlowController(screens: .init())
        onboardingFlowController.onFinished = { expectation.fulfill() }

        // Act
        onboardingFlowController.didFinishOnboarding(onboardingViewController: .init(withConfiguration: .setUp()))

        // Assert
        waitForExpectations(timeout: 1)
    }
}
