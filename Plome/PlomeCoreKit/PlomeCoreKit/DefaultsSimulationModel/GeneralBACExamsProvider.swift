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
    
    static private var premiereTrials: [Exam] = [
        .init(name: "Français écrit", coefficient: 5, grade: nil, type: .trial),
        .init(name: "Français oral", coefficient: 5, grade: nil, type: .trial),
    ]
    
    static private var premiereContinuousControls: [Exam] = [
        .init(name: "Spécialité abandonnée", coefficient: 8, grade: nil, type: .continuousControl),
        .init(name: "Enseignement scientifique", coefficient: 3, grade: nil, type: .continuousControl),
        .init(name: "LVA", coefficient: 3, grade: nil, type: .continuousControl),
        .init(name: "LVB", coefficient: 3, grade: nil, type: .continuousControl),
        .init(name: "EPS", coefficient: 3, grade: nil, type: .continuousControl),
        .init(name: "Histoire-géo", coefficient: 3, grade: nil, type: .continuousControl),
        .init(name: "EMC", coefficient: 1, grade: nil, type: .continuousControl),
    ]
    
    static private var terminaleTrials: [Exam] = [
        .init(name: "Grand oral", coefficient: 10, grade: nil, type: .trial),
        .init(name: "Philosophie", coefficient: 8, grade: nil, type: .trial),
        .init(name: "Enseignement spécialité 1", coefficient: 16, grade: nil, type: .trial),
        .init(name: "Enseignement spécialité 2", coefficient: 16, grade: nil, type: .trial),
    ]
    
    static private var terminaleContinuousControls: [Exam] = [
        .init(name: "Enseignement scientifique", coefficient: 3, grade: nil, type: .continuousControl),
        .init(name: "LVA", coefficient: 3, grade: nil, type: .continuousControl),
        .init(name: "LVB", coefficient: 3, grade: nil, type: .continuousControl),
        .init(name: "EPS", coefficient: 3, grade: nil, type: .continuousControl),
        .init(name: "Histoire-géo", coefficient: 3, grade: nil, type: .continuousControl),
        .init(name: "EMC", coefficient: 1, grade: nil, type: .continuousControl),
    ]
}

/*
 Coeff bac générale :: bac technologique

 Epreuves 1ere
 Français écrit, coeff 5 :: 5
 Français oral, coeff 5 :: 5

 Epreuves Terminale
 Grand oral, coeff 10 :: 14
 Philosophie, coeff 8 :: 4
 Enseignement spécialité 1, coeff 16 :: 16
 Enseignement spécialité 2, coeff 16 :: 16

 CC Première
 Spécialité abandonnée, 8
 Enseignement scientifique :: mathématiques , 3
 LVA, 3
 LVB, 3
 EPS, 3
 Histoire-géo, 3
 EMC, 1

 CC Terminale
 Enseignement scientifique :: mathématiques, 3
 LVA, 3
 LVB, 3
 EPS, 3
 Histoire-géo, 3
 EMC, 1
 */
