//
//  GeneralBACExamsProvider.swift
//  PlomeCoreKit
//
//  Created by Loic Mazuc on 14/10/2022.
//

import Foundation

struct GeneralBACExamsProvider {
    static func allExams() -> [Exam] {
        premiereTrials + premiereContinuousControls + terminaleTrials + terminaleContinuousControls
    }

    private static var premiereTrials: [Exam] = [
        .init(name: L10n.frenchWritting, coefficient: 5, grade: nil, ratio: nil, type: .trial),
        .init(name: L10n.frenchOral, coefficient: 5, grade: nil, ratio: nil, type: .trial),
    ]

    private static var premiereContinuousControls: [Exam] = [
        .init(name: L10n._1AbandonedSpeciality, coefficient: 8, grade: nil, ratio: nil, type: .continuousControl),
        .init(name: L10n._1ScientificEducation, coefficient: 3, grade: nil, ratio: nil, type: .continuousControl),
        .init(name: L10n._1Lva, coefficient: 3, grade: nil, ratio: nil, type: .continuousControl),
        .init(name: L10n._1Lvb, coefficient: 3, grade: nil, ratio: nil, type: .continuousControl),
        .init(name: L10n._1Eps, coefficient: 3, grade: nil, ratio: nil, type: .continuousControl),
        .init(name: L10n._1HistoryGeography, coefficient: 3, grade: nil, ratio: nil, type: .continuousControl),
        .init(name: L10n._1Emc, coefficient: 1, grade: nil, ratio: nil, type: .continuousControl),
    ]

    private static var terminaleTrials: [Exam] = [
        .init(name: L10n.grandOral, coefficient: 10, grade: nil, ratio: nil, type: .trial),
        .init(name: L10n.philosophy, coefficient: 8, grade: nil, ratio: nil, type: .trial),
        .init(name: L10n.specializedEducation1, coefficient: 16, grade: nil, ratio: nil, type: .trial),
        .init(name: L10n.specializedEducation2, coefficient: 16, grade: nil, ratio: nil, type: .trial),
    ]

    private static var terminaleContinuousControls: [Exam] = [
        .init(name: L10n.tScientificEducation, coefficient: 3, grade: nil, ratio: nil, type: .continuousControl),
        .init(name: L10n.tLva, coefficient: 3, grade: nil, ratio: nil, type: .continuousControl),
        .init(name: L10n.tLvb, coefficient: 3, grade: nil, ratio: nil, type: .continuousControl),
        .init(name: L10n.tEps, coefficient: 3, grade: nil, ratio: nil, type: .continuousControl),
        .init(name: L10n.tHistoryGeography, coefficient: 3, grade: nil, ratio: nil, type: .continuousControl),
        .init(name: L10n.tEmc, coefficient: 1, grade: nil, ratio: nil, type: .continuousControl),
    ]
}
