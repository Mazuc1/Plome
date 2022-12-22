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
        case .presentation: return "Bienvenue sur Plôme, l'application qui vous permet de simuler vos examens."
        case .model: return "Créez vos propres modèles d'examen en plus de ce déjà disponible."
        case .simulation: return "Rentrez vos notes et coefficients pour avoir le résultat."
        case .start: return "Vous savez tout !"
        }
    }

    var title: String {
        switch self {
        case .presentation: return "Hello !"
        case .model: return "Créez tes modèles"
        case .simulation: return "Fait des simulations"
        case .start: return "Let's go !"
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
