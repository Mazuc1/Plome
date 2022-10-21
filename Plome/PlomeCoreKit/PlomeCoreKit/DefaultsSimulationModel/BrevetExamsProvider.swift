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
    
    static private var continuousControls: [Exam] = [
        .init(name: "Langue française", coefficient: 1, grade: nil, type: .continuousControl),
        .init(name: "Langue étrangère", coefficient: 1, grade: nil, type: .continuousControl),
        .init(name: "Langages scientifiques", coefficient: 1, grade: nil, type: .continuousControl),
        .init(name: "Langages des arts", coefficient: 1, grade: nil, type: .continuousControl),
        .init(name: "Outils pour apprendre", coefficient: 1, grade: nil, type: .continuousControl),
        .init(name: "Formation du citoyen", coefficient: 1, grade: nil, type: .continuousControl),
        .init(name: "Systèmes naturels et techniques", coefficient: 1, grade: nil, type: .continuousControl),
        .init(name: "Représentations du monde", coefficient: 1, grade: nil, type: .continuousControl),
    ]
    
    static private var trials: [Exam] = [
        .init(name: "Français", coefficient: 1, grade: nil, type: .trial),
        .init(name: "Mathématiques", coefficient: 1, grade: nil, type: .trial),
        .init(name: "Oral", coefficient: 1, grade: nil, type: .trial),
        .init(name: "Sciences", coefficient: 1, grade: nil, type: .trial),
        .init(name: "Histoire-Géo-EMC", coefficient: 1, grade: nil, type: .trial),
    ]
}
