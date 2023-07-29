//
//  Calculator.swift
//  PlomeCoreKit
//
//  Created by Loic Mazuc on 11/11/2022.
//

import UIKit

public enum Mention {
    case cannotBeCalculated
    case without
    case AB
    case B
    case TB

    public var name: String {
        switch self {
        case .cannotBeCalculated: return "Ne peux être calculée"
        case .without: return L10n.withoutMention
        case .AB: return L10n.quiteWellMention
        case .B: return L10n.greatMention
        case .TB: return L10n.veryGreatMention
        }
    }

    public var plomeColor: PlomeColor {
        switch self {
        case .cannotBeCalculated: return PlomeColor.withoutMention
        case .without: return PlomeColor.withoutMention
        case .AB: return PlomeColor.quiteWellMention
        case .B: return PlomeColor.greatMention
        case .TB: return PlomeColor.veryGreatMention
        }
    }
}

public enum GradeType {
    case worst
    case better
}

public class Calculator {
    // MARK: - Properties

    public let simulation: Simulation

    public private(set) var finalGrade: Float = 0
    public private(set) var totalGrade: Float = 0
    public private(set) var totalOutOf: Float = 0
    public private(set) var totalCoefficient: Float = 0

    public private(set) var trialsGrade: Float?
    public private(set) var continousControlGrade: Float?
    public private(set) var optionsGrade: Float?

    private var catchUpSimulation: Simulation?
    public private(set) var gradeOutOfTwentyAfterCatchUp: Float?
    public private(set) var differenceAfterCatchUp: [Exam: Int]?

    // MARK: - Init

    public init(simulation: Simulation) {
        self.simulation = simulation
    }

    // MARK: - Methods

    public func calculate() {
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

        let finalGradeOutOfTwenty = gradeOufOfTwenty(totalGrade / totalOutOf)
        catchUpIfNeeded(grade: finalGradeOutOfTwenty)

        finalGrade = finalGradeOutOfTwenty
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
        case .trial: trialsGrade = gradeOufOfTwenty(totalGrade / totalOn)
        case .option: optionsGrade = gradeOufOfTwenty(totalGrade / totalOn)
        case .continuousControl: continousControlGrade = gradeOufOfTwenty(totalGrade / totalOn)
        }

        return (totalGrade, totalOn, totalCoefficient)
    }

    private func gradeOufOfTwenty(_ value: Float) -> Float {
        value * 20
    }

    func getExamWhereGrade(is type: GradeType) -> Exam? {
        guard let exams = simulation.exams else { return nil }
        return exams
            .sorted {
                let firstGradeInformations = $0.getGradeInformation()
                let secondGradeInformations = $1.getGradeInformation()

                switch type {
                case .worst: return (firstGradeInformations.lhs / firstGradeInformations.rhs) <= (secondGradeInformations.lhs / secondGradeInformations.rhs)
                case .better: return (firstGradeInformations.lhs / firstGradeInformations.rhs) >= (secondGradeInformations.lhs / secondGradeInformations.rhs)
                }
            }
            .first
    }
}

// MARK: - Catch up

extension Calculator {
    /// Determine if catchUp is Needed depending of simulation final grade
    /// If final grade is lower than 10, catchUp is needed
    /// CatchUp is done with copy of simulation
    private func catchUpIfNeeded(grade: Float) {
        guard grade < 10,
              let catchUpSimulation = simulation.copy() as? Simulation else { return }

        self.catchUpSimulation = catchUpSimulation
        catchUp()
    }

    /// For all exams with grade lower than is average divided by two, a point is added grade after grade until final grade is higher than 10
    private func catchUp() {
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

        gradeOutOfTwentyAfterCatchUp = calculateCatchUp()

        compareGradesAfterCatchUp(from: gradesLowerThanAverage)
    }

    /// Calculate final grade for catchUp simulation
    /// Grade returned is out of twenty (/20)
    private func calculateCatchUp() -> Float {
        guard let exams = catchUpSimulation?.exams else { return 999 }
        var totalGrade: Float = 0
        var totalOutOf: Float = 0

        _ = exams
            .map { $0.getGradeInformation() }
            .map {
                totalGrade += $0.lhs * $0.coeff
                totalOutOf += $0.rhs * $0.coeff
            }

        return gradeOufOfTwenty(totalGrade / totalOutOf)
    }

    /// Compare catchUp simulation grade with simulation grade to extract all exams where points have been added
    /// All values (exams + grades differences) are save in differenceAfterCatchUp
    private func compareGradesAfterCatchUp(from exams: [Exam]) {
        let simulationExamsLowerThanAverageBeforeCatchUp = getAllExamsWhereGradeIsLowerThanAverageSortByCoefficient(from: simulation)
            .sorted { $0.name < $1.name }
        let examsSortedByName = exams.sorted { $0.name < $1.name }

        differenceAfterCatchUp = .init()

        _ = zip(examsSortedByName, simulationExamsLowerThanAverageBeforeCatchUp)
            .map { [weak self] catchUpExam, exam in

                if catchUpExam.grade! != exam.grade! {
                    self?.differenceAfterCatchUp?[catchUpExam] = self?.differenceOfGradeBetween(catchUpExam: catchUpExam, and: exam)
                }
            }
    }

    /// Returns exams sorted by coefficient depending of exam grade
    /// If lhs of grade if lower than rhs of grade divided by two, then exam is return
    /// Eg when grade is returned: 8.3/20, 18/40, 4/10...
    /// Eg when grade is not returned: 13/20, 37/40, 8/10
    private func getAllExamsWhereGradeIsLowerThanAverageSortByCoefficient(from simulation: Simulation) -> [Exam] {
        guard let exams = simulation.exams else { return [] }
        return exams
            .filter { $0.isGradeLowerThanAverageRatio() }
            .sorted {
                guard let lhsCoeff = $0.coefficient,
                      let rhsCoeff = $1.coefficient else { return false }
                return lhsCoeff > rhsCoeff
            }
    }

    /// Returns the difference between two exams grade
    /// Eg: catchUpExam.grade = 15/20, exam.grade = 12/20
    /// Output = 3
    private func differenceOfGradeBetween(catchUpExam: Exam, and exam: Exam) -> Int {
        let catchUpGrade = catchUpExam.getGradeInformation()
        let grade = exam.getGradeInformation()

        return Int((catchUpGrade.lhs - grade.lhs).rounded(.toNearestOrEven))
    }
}
