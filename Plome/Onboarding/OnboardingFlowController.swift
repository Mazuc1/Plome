//
//  OnboardingFlowController.swift
//  Pineapple
//
//  Created by Loic Mazuc on 02/08/2022.
//

import Factory
import Foundation
import PlomeCoreKit
import SwiftUI
import UIKit
import UIOnboarding

protocol MainRouterDelegate: AnyObject {
    func didFinishPresentOnboarding()
}

final class OnboardingFlowController {
    // MARK: - Properties

    private let screens: Screens
    var onFinished: (() -> Void)?

    @Injected(\CoreKitContainer.userDefault) private var userDefault

    // MARK: - Init

    init(screens: Screens) {
        self.screens = screens
    }

    func start() -> UIViewController {
        screens.createOnboarding(delegate: self)
    }

    func shouldPresentOnboarding() -> Bool {
        userDefault.setData(value: false, key: .hasOnboardingBeenSeen)
        return userDefault.getData(type: Bool.self, forKey: .hasOnboardingBeenSeen) ?? false
    }
}

extension OnboardingFlowController: UIOnboardingViewControllerDelegate {
    func didFinishOnboarding(onboardingViewController: UIOnboarding.UIOnboardingViewController) {
        print("🐛 Onboarding did finished")
        onFinished?()
    }
}
