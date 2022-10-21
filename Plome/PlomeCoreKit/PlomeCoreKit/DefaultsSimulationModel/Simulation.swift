//
//  Simulation.swift
//  PlomeCoreKit
//
//  Created by Loic Mazuc on 21/10/2022.
//

import Foundation

struct Simulation: Hashable {
    let name: String
    let date: Date
    let exams: Set<CDExam>?
}
