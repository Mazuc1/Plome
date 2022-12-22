//
//  OnboardingPage.swift
//  Plome
//
//  Created by Loic Mazuc on 22/12/2022.
//

import UIKit

enum OnboardingPage: Int, CaseIterable {
    case presentation = 0
    case model = 1
    case simulation = 2
    case start = 3

    var text: String {
        switch self {
        case .presentation: return L10n.Onboarding.presentationText
        case .model: return L10n.Onboarding.modelText
        case .simulation: return L10n.Onboarding.simulationText
        case .start: return L10n.Onboarding.startText
        }
    }

    var title: String {
        switch self {
        case .presentation: return L10n.Onboarding.presentationTitle
        case .model: return L10n.Onboarding.modelTitle
        case .simulation: return L10n.Onboarding.simulationTitle
        case .start: return L10n.Onboarding.startTitle
        }
    }

    var image: UIImage {
        switch self {
        case .presentation: return Asset.student.image
        case .model: return Asset.model.image
        case .simulation: return Asset.calcul.image
        case .start: return Asset.target.image
        }
    }
}
