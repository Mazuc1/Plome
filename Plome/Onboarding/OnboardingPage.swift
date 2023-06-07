//
//  OnboardingPage.swift
//  Plome
//
//  Created by Loic Mazuc on 22/12/2022.
//

import UIKit

enum OnboardingPage {
    case presentation
    case model
    case simulation

    var text: String {
        switch self {
        case .presentation: return L10n.Onboarding.presentationText
        case .model: return L10n.Onboarding.modelText
        case .simulation: return L10n.Onboarding.simulationText
        }
    }

    var title: String {
        switch self {
        case .presentation: return L10n.Onboarding.presentationTitle
        case .model: return L10n.Onboarding.modelTitle
        case .simulation: return L10n.Onboarding.simulationTitle
        }
    }

    var image: UIImage {
        switch self {
        case .presentation: return Asset.student.image
        case .model: return Asset.model.image
        case .simulation: return Asset.calcul.image
        }
    }
}
