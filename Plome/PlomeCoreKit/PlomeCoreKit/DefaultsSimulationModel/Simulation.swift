//
//  Simulation.swift
//  PlomeCoreKit
//
//  Created by Loic Mazuc on 21/10/2022.
//

import Foundation

public struct Simulation: Hashable {
    public let name: String
    public let date: Date
    public let exams: Set<Exam>?
}
