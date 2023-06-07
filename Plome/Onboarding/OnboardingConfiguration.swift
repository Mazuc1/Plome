//
//  OnboardingConfiguration.swift
//  Plome
//
//  Created by Loic Mazuc on 07/06/2023.
//

import Foundation
import PlomeCoreKit
import UIOnboarding
import UIKit

struct UIOnboardingHelper {
    static func setUpIcon() -> UIImage {
        return Bundle.main.appIcon ?? .init(named: "AppIcon")!
    }

    static func setUpFirstTitleLine() -> NSMutableAttributedString {
        .init(string: "Welcome to", attributes: [.foregroundColor: UIColor.label])
    }

    static func setUpSecondTitleLine() -> NSMutableAttributedString {
        .init(string: Bundle.main.displayName ?? "Plôme", attributes: [
            .foregroundColor: PlomeColor.lightGreen.color
        ])
    }

    static func setUpFeatures() -> Array<UIOnboardingFeature> {
        return .init([
            .init(icon: OnboardingPage.presentation.image,
                  title: OnboardingPage.presentation.title,
                  description: OnboardingPage.presentation.text),
            .init(icon: OnboardingPage.model.image,
                  title: OnboardingPage.model.title,
                  description: OnboardingPage.model.text),
            .init(icon: OnboardingPage.simulation.image,
                  title: OnboardingPage.simulation.title,
                  description: OnboardingPage.simulation.text),
        ])
    }
    
    static func setUpButton() -> UIOnboardingButtonConfiguration {
        return .init(title: "Continue",
                     backgroundColor: PlomeColor.lightGreen.color)
    }
}

extension UIOnboardingViewConfiguration {
    static func setUp() -> UIOnboardingViewConfiguration {
        return .init(appIcon: UIOnboardingHelper.setUpIcon(),
                     firstTitleLine: UIOnboardingHelper.setUpFirstTitleLine(),
                     secondTitleLine: UIOnboardingHelper.setUpSecondTitleLine(),
                     features: UIOnboardingHelper.setUpFeatures(),
                     buttonConfiguration: UIOnboardingHelper.setUpButton())
    }
}
