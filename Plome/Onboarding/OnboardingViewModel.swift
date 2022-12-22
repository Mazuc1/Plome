//
//  OnboardingViewModel.swift
//  Plome
//
//  Created by Loic Mazuc on 16/12/2022.
//

import Foundation

final class OnboardingViewModel {
    // MARK: - Properties

    let router: OnboardingRouter
    let pages: [OnboardingPage] = OnboardingPage.allCases

    // MARK: - Init

    init(router: OnboardingRouter) {
        self.router = router
    }

    // MARK: - Methods

    func userDidFinishOnboarding() {
        router.mainRouterDelegate?.didFinishPresentOnboarding()
    }
}
