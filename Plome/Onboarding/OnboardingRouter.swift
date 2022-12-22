//
//  OnboardingRouter.swift
//  Pineapple
//
//  Created by Loïc MAZUC on 02/08/2022.
//

import Foundation
import PlomeCoreKit
import SwiftUI
import UIKit

final class OnboardingRouter: DefaultRouter {
    // MARK: - Properties

    let screens: Screens
    weak var mainRouterDelegate: MainRouterDelegate?

    // MARK: - Init

    init(screens: Screens, mainRouterDelegate: MainRouterDelegate? = nil, rootTransition: Transition) {
        self.screens = screens
        self.mainRouterDelegate = mainRouterDelegate
        super.init(rootTransition: rootTransition)
    }

    // MARK: - Methods

    func makeRootViewController() -> UIViewController {
        let router = OnboardingRouter(screens: screens, mainRouterDelegate: mainRouterDelegate, rootTransition: EmptyTransition())
        let onboardingViewController = screens.createOnboarding(router: router)
        router.rootViewController = onboardingViewController

        return onboardingViewController
    }
}
