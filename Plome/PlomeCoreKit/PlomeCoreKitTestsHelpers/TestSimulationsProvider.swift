//
//  TestSimulationsProvider.swift
//  PlomeCoreKitTests
//
//  Created by Loic Mazuc on 16/11/2022.
//

import Foundation
@testable import PlomeCoreKit

public enum TestSimulations {
    public enum TargetMention {
        case bigFailure
        case mediumFailure
        case without
        case AB
        case B
        case TB
        case random

        var gradeRange: ClosedRange<Int> {
            switch self {
            case .bigFailure: return 0 ... 10
            case .mediumFailure: return 7 ... 11
            case .without: return 10 ... 12
            case .AB: return 12 ... 14
            case .B: return 14 ... 16
            case .TB: return 16 ... 20
            case .random: return 0 ... 20
            }
        }
    }

    public static func generalBACSimulation(targetedMention: TargetMention, withOptions: Bool = false) -> Simulation {
        let simulation = Simulation(name: "Test", date: nil, exams: .init(), type: .generalBAC)
        _ = GeneralBACExamsProvider.allExams()
            .map {
                $0.grade = setRandomGrade(targetedMention: targetedMention)
                simulation.add(exam: $0)
            }

        if withOptions { addOptions(in: simulation, for: targetedMention) }

        return simulation
    }

    public static func technologicalBACSimulation(targetedMention: TargetMention, withOptions: Bool = false) -> Simulation {
        let simulation = Simulation(name: "Test", date: nil, exams: .init(), type: .technologicalBAC)
        _ = TechnologicalBACExamsProvider.allExams()
            .map {
                $0.grade = setRandomGrade(targetedMention: targetedMention)
                simulation.add(exam: $0)
            }

        if withOptions { addOptions(in: simulation, for: targetedMention) }

        return simulation
    }

    public static func brevetSimulation(targetedMention: TargetMention, withOptions: Bool = false) -> Simulation {
        let simulation = Simulation(name: "Test", date: nil, exams: .init(), type: .brevet)
        _ = BrevetExamsProvider.allExams()
            .map {
                $0.grade = setRandomGrade(targetedMention: targetedMention)
                simulation.add(exam: $0)
            }

        if withOptions { addOptions(in: simulation, for: targetedMention) }

        return simulation
    }

    private static func setRandomGrade(targetedMention: TargetMention) -> String {
        "\(Int.random(in: targetedMention.gradeRange))/20"
    }

    private static func addOptions(in simulation: Simulation, for mention: TargetMention) {
        (0 ... 4)
            .forEach { _ in
                let exam = Exam(name: "", coefficient: 1, grade: "\(mention.gradeRange.randomElement()!)/20", type: .option)
                simulation.exams?.insert(exam)
            }
    }
}
