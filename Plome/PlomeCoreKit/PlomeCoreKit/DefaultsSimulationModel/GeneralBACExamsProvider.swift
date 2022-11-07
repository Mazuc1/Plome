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
        .init(name: "Français écrit", coefficient: 5, grade: nil, type: .trial),
        .init(name: "Français oral", coefficient: 5, grade: nil, type: .trial),
    ]

    private static var premiereContinuousControls: [Exam] = [
        .init(name: "1ère Spécialité abandonnée", coefficient: 8, grade: nil, type: .continuousControl),
        .init(name: "1ère Enseignement scientifique", coefficient: 3, grade: nil, type: .continuousControl),
        .init(name: "1ère LVA", coefficient: 3, grade: nil, type: .continuousControl),
        .init(name: "1ère LVB", coefficient: 3, grade: nil, type: .continuousControl),
        .init(name: "1ère EPS", coefficient: 3, grade: nil, type: .continuousControl),
        .init(name: "1ère Histoire-géo", coefficient: 3, grade: nil, type: .continuousControl),
        .init(name: "1ère EMC", coefficient: 1, grade: nil, type: .continuousControl),
    ]

    private static var terminaleTrials: [Exam] = [
        .init(name: "Grand oral", coefficient: 10, grade: nil, type: .trial),
        .init(name: "Philosophie", coefficient: 8, grade: nil, type: .trial),
        .init(name: "Enseignement spécialité 1", coefficient: 16, grade: nil, type: .trial),
        .init(name: "Enseignement spécialité 2", coefficient: 16, grade: nil, type: .trial),
    ]

    private static var terminaleContinuousControls: [Exam] = [
        .init(name: "Terminale Enseignement scientifique", coefficient: 3, grade: nil, type: .continuousControl),
        .init(name: "Terminale LVA", coefficient: 3, grade: nil, type: .continuousControl),
        .init(name: "Terminale LVB", coefficient: 3, grade: nil, type: .continuousControl),
        .init(name: "Terminale EPS", coefficient: 3, grade: nil, type: .continuousControl),
        .init(name: "Terminale Histoire-géo", coefficient: 3, grade: nil, type: .continuousControl),
        .init(name: "Terminale EMC", coefficient: 1, grade: nil, type: .continuousControl),
    ]
}
