//
//  BrevetExamsProvider.swift
//  PlomeCoreKit
//
//  Created by Loic Mazuc on 14/10/2022.
//

import Foundation

struct BrevetExamsProvider {
    static func allExams() -> [Exam] {
        continuousControls + trials
    }

    private static var continuousControls: [Exam] = [
        .init(name: L10n.frenchLanguage, coefficient: 1, grade: nil, type: .continuousControl),
        .init(name: L10n.foreignLanguage, coefficient: 1, grade: nil, type: .continuousControl),
        .init(name: L10n.scientistLanguage, coefficient: 1, grade: nil, type: .continuousControl),
        .init(name: L10n.artLanguage, coefficient: 1, grade: nil, type: .continuousControl),
        .init(name: L10n.learningTools, coefficient: 1, grade: nil, type: .continuousControl),
        .init(name: L10n.citizenFormation, coefficient: 1, grade: nil, type: .continuousControl),
        .init(name: L10n.natualTechnologicSystem, coefficient: 1, grade: nil, type: .continuousControl),
        .init(name: L10n.worldRepresentation, coefficient: 1, grade: nil, type: .continuousControl),
    ]

    private static var trials: [Exam] = [
        .init(name: L10n.french, coefficient: 1, grade: nil, type: .trial),
        .init(name: L10n.math, coefficient: 1, grade: nil, type: .trial),
        .init(name: L10n.oral, coefficient: 1, grade: nil, type: .trial),
        .init(name: L10n.sciences, coefficient: 1, grade: nil, type: .trial),
        .init(name: L10n.historyGeographyEMC, coefficient: 1, grade: nil, type: .trial),
    ]
}
