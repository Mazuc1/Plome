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
            .foregroundColor: UIColor.init(named: "camou") ?? UIColor.init(red: 0.654, green: 0.618, blue: 0.494, alpha: 1.0)
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
            .init(icon: OnboardingPage.start.image,
                  title: OnboardingPage.start.title,
                  description: OnboardingPage.start.text),
        ])
    }
    
    static func setUpNotice() -> UIOnboardingTextViewConfiguration {
        return .init(icon: .init(named: "onboarding-notice-icon"),
                     text: "Developed and designed for members of the Swiss Armed Forces.",
                     linkTitle: "Learn more...",
                     link: "https://www.lukmanascic.ch/portfolio/insignia",
                     tint: .init(named: "camou") ?? .init(red: 0.654, green: 0.618, blue: 0.494, alpha: 1.0))
    }
    
    static func setUpButton() -> UIOnboardingButtonConfiguration {
        return .init(title: "Continue",
                     backgroundColor: .init(named: "camou") ?? .init(red: 0.654, green: 0.618, blue: 0.494, alpha: 1.0))
    }
}

extension UIOnboardingViewConfiguration {
    static func setUp() -> UIOnboardingViewConfiguration {
        return .init(appIcon: UIOnboardingHelper.setUpIcon(),
                     firstTitleLine: UIOnboardingHelper.setUpFirstTitleLine(),
                     secondTitleLine: UIOnboardingHelper.setUpSecondTitleLine(),
                     features: UIOnboardingHelper.setUpFeatures(),
                     textViewConfiguration: UIOnboardingHelper.setUpNotice(),
                     buttonConfiguration: UIOnboardingHelper.setUpButton())
    }
}
