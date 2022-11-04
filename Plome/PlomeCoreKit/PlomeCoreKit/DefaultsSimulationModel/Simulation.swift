//
//  Simulation.swift
//  PlomeCoreKit
//
//  Created by Loic Mazuc on 21/10/2022.
//

import Foundation

public struct Simulation: Hashable {
    public let name: String
    public let date: Date?
    public let exams: Set<Exam>?

    public init(name: String, date: Date?, exams: Set<Exam>?) {
        self.name = name
        self.date = date
        self.exams = exams
    }

    public func number(of type: ExamType) -> Int {
        guard let exams else { return 0 }
        return exams
            .filter { $0.type == type }
            .count
    }

    public func exams(of type: ExamType) -> [Exam] {
        guard let exams else { return [] }
        return exams
            .filter { $0.type == type }
    }
}
