//
//  OnboardingFlowControllerTests.swift
//  PlomeTests
//
//  Created by Loic Mazuc on 22/12/2022.
//

import Dependencies
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
        let onboardingFlowController = withDependencies {
            $0.userDefault = userDefault
        } operation: {
            OnboardingFlowController(screens: .init())
        }

        // Act
        let result = onboardingFlowController.shouldPresentOnboarding()

        // Assert
        XCTAssertFalse(result)
    }

    func testShouldPresentOnboardingReturnsTrueWhenOnboardingHasBeenSeen() {
        // Arrange
        let userDefault = Defaults(userDefaults: .init())
        userDefault.setData(value: true, key: .hasOnboardingBeenSeen)
        let onboardingFlowController = withDependencies {
            $0.userDefault = userDefault
        } operation: {
            OnboardingFlowController(screens: .init())
        }

        // Act
        let result = onboardingFlowController.shouldPresentOnboarding()

        // Assert
        XCTAssertTrue(result)
    }

    func testThatOnFinishedIsCalledWhenUserFinishOnboarding() {
        // Arrange
        let expectation = expectation(description: #function)

        let onboardingFlowController = withDependencies {
            $0.userDefault = Defaults()
        } operation: {
            OnboardingFlowController(screens: .init())
        }

        onboardingFlowController.onFinished = {
            expectation.fulfill()
        }

        // Act
        onboardingFlowController.didFinishPresentOnboarding()

        // Assert
        waitForExpectations(timeout: 1)
    }
}
