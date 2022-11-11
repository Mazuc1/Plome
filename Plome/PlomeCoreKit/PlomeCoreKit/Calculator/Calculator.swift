//
//  Calculator.swift
//  PlomeCoreKit
//
//  Created by Loic Mazuc on 11/11/2022.
//

import Foundation

public enum Mention {
    case without
    case AB
    case B
    case TB

    public var name: String {
        switch self {
        case .without: return "Sans mention"
        case .AB: return "Mention assez bien"
        case .B: return "Mention bien"
        case .TB: return "Mention très bien"
        }
    }
}

public protocol MentionScores: AnyObject {
    var withoutMentionScore: Int { get }
    var ABMentionScore: Int { get }
    var BMentionScore: Int { get }
    var TBMentionScore: Int { get }
}

public class Calculator: MentionScores {
    // MARK: - Properties

    public var withoutMentionScore: Int
    public var ABMentionScore: Int
    public var BMentionScore: Int
    public var TBMentionScore: Int

    public let simulation: Simulation

    // MARK: - Init

    public init(simulation: Simulation, withoutMentionScore: Int = 1000, ABMentionScore: Int = 1200, BMentionScore: Int = 1400, TBMentionScore: Int = 1600) {
        self.simulation = simulation
        self.withoutMentionScore = withoutMentionScore
        self.ABMentionScore = ABMentionScore
        self.BMentionScore = BMentionScore
        self.TBMentionScore = TBMentionScore
    }

    // MARK: - Methods

    public func setMissingCoefficientOfExams() {
        guard let exams = simulation.exams else { return }

        _ = exams.map {
            if $0.coefficient == nil { $0.coefficient = 1 }
        }
    }

    public func calculate() -> (Float, Float, Float) {
        guard let exams = simulation.exams else { return (-1, -1, -1) }

        var totalGrade: Float = 0
        var totalOn: Float = 0
        var totalCoefficient: Float = 0

        _ = exams
            .map { $0.getGradeInformation() }
            .map {
                totalGrade += $0 * $2
                totalOn += $1 * $2
                totalCoefficient += $2
            }

        return (totalGrade / totalOn, totalGrade, totalOn)
    }
}
