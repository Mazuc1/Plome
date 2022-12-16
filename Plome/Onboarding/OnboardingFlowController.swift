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
    var onFinished: (() -> Void)?

    var mainRouter: OnboardingRouter

    // MARK: - Init

    init(screens: Screens) {
        self.screens = screens
        mainRouter = OnboardingRouter(screens: screens, rootTransition: EmptyTransition())
        mainRouter.mainRouterDelegate = self
    }

    func start() -> UIViewController {
        return mainRouter.makeRootViewController()
    }
}

extension OnboardingFlowController: MainRouterDelegate {
    func didFinishPresentOnboarding() {
        print("🐛 Did finish")
        onFinished?()
    }
}
