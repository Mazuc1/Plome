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

        var gradeRange: ClosedRange<Float> {
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
                $0.ratio = 20
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

    private static func setRandomGrade(targetedMention: TargetMention) -> Float {
        Float.random(in: targetedMention.gradeRange)
    }

    private static func addOptions(in simulation: Simulation, for mention: TargetMention) {
        (0 ... 4)
            .forEach { _ in
                let exam = Exam(name: "", coefficient: 1, grade: setRandomGrade(targetedMention: mention), ratio: 20, type: .option)
                simulation.exams?.insert(exam)
            }
    }
}

enum CalculatorShaperProvider {
    static func calculatorShaperWithExamSucceed() -> CalculatorShaper {
        let trials: [Exam] = [
            .init(name: "", coefficient: 4, grade: 14, ratio: 20, type: .trial),
            .init(name: "", coefficient: 2, grade: 6, ratio: 20, type: .trial),
            .init(name: "", coefficient: 7, grade: 13, ratio: 20, type: .trial),
            .init(name: "BetterGrade", coefficient: 3, grade: 18, ratio: 20, type: .trial),
        ]

        let continuousControl: [Exam] = [
            .init(name: "WorstGrade", coefficient: 2, grade: 2, ratio: 20, type: .continuousControl),
            .init(name: "", coefficient: 5, grade: 15, ratio: 20, type: .continuousControl),
            .init(name: "", coefficient: 1, grade: 11, ratio: 20, type: .continuousControl),
            .init(name: "", coefficient: 8, grade: 13, ratio: 20, type: .continuousControl),
        ]

        let options: [Exam] = [
            .init(name: "", coefficient: 1, grade: 12, ratio: 20, type: .option),
            .init(name: "", coefficient: 1, grade: 6, ratio: 20, type: .option),
            .init(name: "", coefficient: 1, grade: 13.45, ratio: 20, type: .option),
            .init(name: "", coefficient: 1, grade: 8.22, ratio: 20, type: .option),
        ]

        let dateComponent = DateComponents(year: 2012, month: 12, day: 12)
        let date = Calendar.current.date(from: dateComponent)!

        let simulation = Simulation(name: "", date: date, exams: .init(), type: .brevet)
        _ = trials.map { simulation.add(exam: $0) }
        _ = continuousControl.map { simulation.add(exam: $0) }
        _ = options.map { simulation.add(exam: $0) }

        let calculator = Calculator(simulation: simulation)
        calculator.calculate()

        return CalculatorShaper(calculator: calculator)
    }

    static func calculatorShaperWithExamFailure() -> CalculatorShaper {
        let trials: [Exam] = [
            .init(name: "", coefficient: 4, grade: 3, ratio: 20, type: .trial),
            .init(name: "", coefficient: 2, grade: 6, ratio: 20, type: .trial),
            .init(name: "", coefficient: 7, grade: 2, ratio: 20, type: .trial),
            .init(name: "", coefficient: 3, grade: 4, ratio: 20, type: .trial),
        ]

        let continuousControl: [Exam] = [
            .init(name: "", coefficient: 2, grade: 2, ratio: 20, type: .continuousControl),
            .init(name: "", coefficient: 5, grade: 2, ratio: 20, type: .continuousControl),
            .init(name: "", coefficient: 1, grade: 1, ratio: 20, type: .continuousControl),
            .init(name: "", coefficient: 8, grade: 4, ratio: 20, type: .continuousControl),
        ]

        let options: [Exam] = [
            .init(name: "", coefficient: 1, grade: 1, ratio: 20, type: .option),
            .init(name: "", coefficient: 1, grade: 6, ratio: 20, type: .option),
            .init(name: "", coefficient: 1, grade: 13.45, ratio: 20, type: .option),
            .init(name: "", coefficient: 1, grade: 8.22, ratio: 20, type: .option),
        ]

        let simulation = Simulation(name: "", date: nil, exams: .init(), type: .brevet)
        _ = trials.map { simulation.add(exam: $0) }
        _ = continuousControl.map { simulation.add(exam: $0) }
        _ = options.map { simulation.add(exam: $0) }

        let calculator = Calculator(simulation: simulation)
        calculator.calculate()

        return CalculatorShaper(calculator: calculator)
    }
}
