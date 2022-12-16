//
//  OnboardingFlowController.swift
//  Pineapple
//
//  Created by Loic Mazuc on 02/08/2022.
//

import Foundation
import PlomeCoreKit
import SwiftUI
import UIKit

protocol MainRouterDelegate: AnyObject {
    func didFinishPresentOnboarding()
}

final class OnboardingFlowController {
    // MARK: - Properties

    let screens: Screens
    let userDefaults: Defaults
    var onFinished: (() -> Void)?

    var mainRouter: OnboardingRouter

    // MARK: - Init

    init(screens: Screens, userDefaults: Defaults) {
        self.screens = screens
        self.userDefaults = userDefaults
        mainRouter = OnboardingRouter(screens: screens, rootTransition: EmptyTransition())
        mainRouter.mainRouterDelegate = self
    }

    func start() -> UIViewController {
        return mainRouter.makeRootViewController()
    }

    func shouldPresentOnboarding() -> Bool {
        // defaults.setData(value: false, key: .onboardingHasBeenSeen)
        return userDefaults.getData(type: Bool.self, forKey: .hasOnboardingBeenSeen) ?? false
    }
}

extension OnboardingFlowController: MainRouterDelegate {
    func didFinishPresentOnboarding() {
        print("🐛 Did finish")
        onFinished?()
    }
}
