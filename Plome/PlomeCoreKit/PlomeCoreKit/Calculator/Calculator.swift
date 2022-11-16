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

protocol MentionScores: AnyObject {
    var withoutMentionScore: Float { get }
    var ABMentionScore: Float { get }
    var BMentionScore: Float { get }
    var TBMentionScore: Float { get }
}

public class Calculator: MentionScores {
    // MARK: - Properties

    public typealias DifferenceAfterCatchUp = [Exam: Int]

    public var withoutMentionScore: Float = 0
    public var ABMentionScore: Float = 0
    public var BMentionScore: Float = 0
    public var TBMentionScore: Float = 0

    public let simulation: Simulation

    public private(set) var mention: Mention?

    public private(set) var totalGrade: Float = 0
    public private(set) var totalOutOf: Float = 0
    public private(set) var totalCoefficient: Float = 0

    public private(set) var trialsGrade: Float?
    public private(set) var continousControlGrade: Float?
    public private(set) var optionsGrade: Float?

    private var catchUpSimulation: Simulation?
    public private(set) var gradeOutOfTwentyAfterCatchUp: Float?
    public private(set) var differenceAfterCatchUp: DifferenceAfterCatchUp?

    // MARK: - Init

    public init(simulation: Simulation) {
        self.simulation = simulation

        setMentionScores()
    }

    // MARK: - Methods

    public func hasSucceed() -> Bool {
        mention != nil
    }

    public func calculate() -> Float {
        totalGrade = 0
        totalOutOf = 0
        totalCoefficient = 0

        if simulation.number(of: .trial) > 0 {
            let (grade, outOf, coefficient) = calculateGrade(for: .trial)
            totalGrade += grade
            totalOutOf += outOf
            totalCoefficient += coefficient
        }

        if simulation.number(of: .continuousControl) > 0 {
            let (grade, outOf, coefficient) = calculateGrade(for: .continuousControl)
            totalGrade += grade
            totalOutOf += outOf
            totalCoefficient += coefficient
        }

        if simulation.number(of: .option) > 0 {
            let (grade, outOf, coefficient) = calculateGrade(for: .option)
            totalGrade += grade
            totalOutOf += outOf
            totalCoefficient += coefficient
        }

        setMention()

        let finalGradeOutOfTwenty = rateOufOfTwenty(totalGrade / totalOutOf)
        catchUpIfNeeded(grade: finalGradeOutOfTwenty)

        return finalGradeOutOfTwenty
    }

    private func calculateGrade(for type: ExamType) -> (Float, Float, Float) {
        let exams = simulation.exams(of: type)

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

        switch type {
        case .trial: trialsGrade = rateOufOfTwenty(totalGrade / totalOn)
        case .option: optionsGrade = rateOufOfTwenty(totalGrade / totalOn)
        case .continuousControl: continousControlGrade = rateOufOfTwenty(totalGrade / totalOn)
        }

        return (totalGrade, totalOn, totalCoefficient)
    }

    private func rateOufOfTwenty(_ value: Float) -> Float {
        value * 20
    }

    private func setMention() {
        switch totalGrade {
        case withoutMentionScore ..< ABMentionScore: mention = .without
        case ABMentionScore ..< BMentionScore: mention = .AB
        case BMentionScore ..< TBMentionScore: mention = .B
        case TBMentionScore...: mention = .TB
        default: mention = nil
        }
    }

    private func setMentionScores() {
        switch simulation.type {
        case .custom:
            withoutMentionScore = 1000
            ABMentionScore = 1200
            BMentionScore = 1400
            TBMentionScore = 1600
        case .brevet:
            withoutMentionScore = 400
            ABMentionScore = 480
            BMentionScore = 560
            TBMentionScore = 640
        case .generalBAC:
            withoutMentionScore = 1000
            ABMentionScore = 1200
            BMentionScore = 1400
            TBMentionScore = 1600
        case .technologicalBAC:
            withoutMentionScore = 1000
            ABMentionScore = 1200
            BMentionScore = 1400
            TBMentionScore = 1600
        }
    }
}

// MARK: - Catch up

extension Calculator {
    private func catchUpIfNeeded(grade: Float) {
        guard grade < 10,
              let catchUpSimulation = simulation.copy() as? Simulation else { return }

        self.catchUpSimulation = catchUpSimulation
        catchUp(grade: grade)
    }

    private func catchUp(grade _: Float) {
        guard let catchUpSimulation else { return }
        let gradesLowerThanAverage = getAllExamsWhereGradeIsLowerThanAverageSortByCoefficient(from: catchUpSimulation)

        var indexWherePointIsAdded = 0
        let maxIndex: Int = gradesLowerThanAverage.count - 1

        while calculateCatchUp() < 10 {
            gradesLowerThanAverage[indexWherePointIsAdded].addOnePoint()
            if indexWherePointIsAdded < maxIndex {
                indexWherePointIsAdded += 1
            } else {
                indexWherePointIsAdded = 0
            }
        }

        print("🏹", calculateCatchUp())
        gradeOutOfTwentyAfterCatchUp = calculateCatchUp()

        compareGradesAfterCatchUp(from: gradesLowerThanAverage)
    }

    private func calculateCatchUp() -> Float {
        guard let exams = catchUpSimulation?.exams else { return 999 }
        var totalGrade: Float = 0
        var totalOutOf: Float = 0

        _ = exams
            .map { $0.getGradeInformation() }
            .map {
                totalGrade += $0.lhs
                totalOutOf += $0.rhs
            }

        return rateOufOfTwenty(totalGrade / totalOutOf)
    }

    private func compareGradesAfterCatchUp(from exams: [Exam]) {
        let simulationExamsLowerThanAverageBeforeCatchUp = getAllExamsWhereGradeIsLowerThanAverageSortByCoefficient(from: simulation)
            .sorted { $0.name < $1.name }
        let examsSortedByName = exams.sorted { $0.name < $1.name }

        _ = zip(examsSortedByName, simulationExamsLowerThanAverageBeforeCatchUp)
            .map { [weak self] catchUpExam, exam in
                print("🚨", catchUpExam.grade, exam.grade)
                if catchUpExam.grade != exam.grade {
                    self?.differenceAfterCatchUp?[exam] = self?.differenceOfGradeBetween(catchUpExam: catchUpExam, and: exam)
                }
            }

        // print("🫑", differenceAfterCatchUp)
    }

    private func getAllExamsWhereGradeIsLowerThanAverageSortByCoefficient(from simulation: Simulation) -> [Exam] {
        guard let exams = simulation.exams else { return [] }
        return exams
            .filter { $0.isGradeLowerThanItsOutOf() }
            .sorted {
                guard let lhsCoeff = $0.coefficient,
                      let rhsCoeff = $1.coefficient else { return false }
                return lhsCoeff > rhsCoeff
            }
    }

    private func differenceOfGradeBetween(catchUpExam: Exam, and exam: Exam) -> Int {
        let catchUpGrade = catchUpExam.getGradeInformation()
        let grade = exam.getGradeInformation()

        return Int(grade.lhs - catchUpGrade.lhs)
    }
}
