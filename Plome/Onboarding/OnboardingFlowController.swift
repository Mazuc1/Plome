//
//  OnboardingFlowController.swift
//  Pineapple
//
//  Created by Loic Mazuc on 02/08/2022.
//

import Dependencies
import Foundation
import PlomeCoreKit
import SwiftUI
import UIKit

protocol MainRouterDelegate: AnyObject {
    func didFinishPresentOnboarding()
}

final class OnboardingFlowController {
    // MARK: - Properties

    private let screens: Screens
    @Dependency(\.userDefault) private var userDefault
    var onFinished: (() -> Void)?

    private var mainRouter: OnboardingRouter

    // MARK: - Init

    init(screens: Screens) {
        self.screens = screens
        mainRouter = OnboardingRouter(screens: screens, rootTransition: EmptyTransition())
        mainRouter.mainRouterDelegate = self
    }

    func start() -> UIViewController {
        return mainRouter.makeRootViewController()
    }

    func shouldPresentOnboarding() -> Bool {
        // userDefaults.setData(value: false, key: .hasOnboardingBeenSeen)
        return userDefault.getData(type: Bool.self, forKey: .hasOnboardingBeenSeen) ?? false
    }
}

extension OnboardingFlowController: MainRouterDelegate {
    func didFinishPresentOnboarding() {
        print("🐛 Did finish")
        onFinished?()
    }
}
