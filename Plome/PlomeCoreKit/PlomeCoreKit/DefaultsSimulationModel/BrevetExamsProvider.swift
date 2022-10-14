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
        .init(name: "Langue française", coefficient: nil, grade: nil, type: .continuousControl),
        .init(name: "Langue étrangère", coefficient: nil, grade: nil, type: .continuousControl),
        .init(name: "Langages scientifiques", coefficient: nil, grade: nil, type: .continuousControl),
        .init(name: "Langages des arts", coefficient: nil, grade: nil, type: .continuousControl),
        .init(name: "Outils pour apprendre", coefficient: nil, grade: nil, type: .continuousControl),
        .init(name: "Formation du citoyen", coefficient: nil, grade: nil, type: .continuousControl),
        .init(name: "Systèmes naturels et techniques", coefficient: nil, grade: nil, type: .continuousControl),
        .init(name: "Représentations du monde", coefficient: nil, grade: nil, type: .continuousControl),
    ]
    
    static private var trials: [Exam] = [
        .init(name: "Français", coefficient: nil, grade: nil, type: .trial),
        .init(name: "Mathématiques", coefficient: nil, grade: nil, type: .trial),
        .init(name: "Oral", coefficient: nil, grade: nil, type: .trial),
        .init(name: "Sciences", coefficient: nil, grade: nil, type: .trial),
        .init(name: "Histoire-Géo-EMC", coefficient: nil, grade: nil, type: .trial),
    ]
}
