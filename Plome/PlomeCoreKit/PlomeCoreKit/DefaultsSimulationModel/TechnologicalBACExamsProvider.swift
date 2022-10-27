//
//  TechnologicalBACExamsProvider.swift
//  PlomeCoreKit
//
//  Created by Loic Mazuc on 21/10/2022.
//

import Foundation

struct TechnologicalBACExamsProvider {
    static func allExams() -> [Exam] {
        premiereTrials + premiereContinuousControls + terminaleTrials + terminaleContinuousControls
    }

    private static var premiereTrials: [Exam] = [
        .init(name: "Français écrit", coefficient: 5, grade: nil, type: .trial),
        .init(name: "Français oral", coefficient: 5, grade: nil, type: .trial),
    ]

    private static var premiereContinuousControls: [Exam] = [
        .init(name: "Spécialité abandonnée", coefficient: 8, grade: nil, type: .continuousControl),
        .init(name: "Mathématiques", coefficient: 3, grade: nil, type: .continuousControl),
        .init(name: "LVA", coefficient: 3, grade: nil, type: .continuousControl),
        .init(name: "LVB", coefficient: 3, grade: nil, type: .continuousControl),
        .init(name: "EPS", coefficient: 3, grade: nil, type: .continuousControl),
        .init(name: "Histoire-géo", coefficient: 3, grade: nil, type: .continuousControl),
        .init(name: "EMC", coefficient: 1, grade: nil, type: .continuousControl),
    ]

    private static var terminaleTrials: [Exam] = [
        .init(name: "Grand oral", coefficient: 14, grade: nil, type: .trial),
        .init(name: "Philosophie", coefficient: 4, grade: nil, type: .trial),
        .init(name: "Enseignement spécialité 1", coefficient: 16, grade: nil, type: .trial),
        .init(name: "Enseignement spécialité 2", coefficient: 16, grade: nil, type: .trial),
    ]

    private static var terminaleContinuousControls: [Exam] = [
        .init(name: "Mathématiques", coefficient: 3, grade: nil, type: .continuousControl),
        .init(name: "LVA", coefficient: 3, grade: nil, type: .continuousControl),
        .init(name: "LVB", coefficient: 3, grade: nil, type: .continuousControl),
        .init(name: "EPS", coefficient: 3, grade: nil, type: .continuousControl),
        .init(name: "Histoire-géo", coefficient: 3, grade: nil, type: .continuousControl),
        .init(name: "EMC", coefficient: 1, grade: nil, type: .continuousControl),
    ]
}
