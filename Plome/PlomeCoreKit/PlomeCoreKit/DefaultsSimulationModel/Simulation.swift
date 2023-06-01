//
//  Simulation.swift
//  PlomeCoreKit
//
//  Created by Loic Mazuc on 21/10/2022.
//

import CoreData
import Foundation

public class Simulation: NSObject, NSCopying, Codable {
    // MARK: - Properties

    public let name: String
    public var date: Date?
    public var exams: Set<Exam>?
    public var type: SimulationType

    private enum CodingKeys: String, CodingKey {
        case name, date, exams, type
    }

    // MARK: - Init

    public init(name: String, date: Date?, exams: Set<Exam>?, type: SimulationType) {
        self.name = name
        self.date = date
        self.exams = exams
        self.type = type
    }

    public required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        name = try container.decode(String.self, forKey: .name)
        date = try? container.decode(Date.self, forKey: .date)
        exams = try? container.decode(Set<Exam>.self, forKey: .exams)
        type = try container.decode(SimulationType.self, forKey: .type)
    }

    // MARK: - Methods

    public func examTypes() -> [ExamType] {
        var examTypes: [ExamType] = []
        examsContainTrials() ? examTypes.append(.trial) : doNothing()
        examsContainContinuousControls() ? examTypes.append(.continuousControl) : doNothing()
        examsContainOptions() ? examTypes.append(.option) : doNothing()
        return examTypes
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(name, forKey: .name)
        try container.encode(date, forKey: .date)
        try container.encode(exams, forKey: .exams)
        try container.encode(type, forKey: .type)
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
            .sorted { $0.name.localizedCaseInsensitiveCompare($1.name) == ComparisonResult.orderedAscending }
    }

    public func gradeIsSetForAllExams() -> Bool {
        guard let exams else { return false }
        return exams.allSatisfy { $0.grade != nil }
    }
    
    public func isAllGradesSet() -> Bool {
        guard let exams else { return false }
        return exams.allSatisfy { $0.grade != -1 }
    }
    
    public func isAtLeaseOneGradeNil() -> Bool {
        guard let exams else { return false }
        return exams.contains { $0.grade == Exam.defaultGradeValue }
    }

    public func examsContainTrials() -> Bool {
        guard let exams else { return false }
        return exams.contains { $0.type == .trial }
    }

    public func examsContainContinuousControls() -> Bool {
        guard let exams else { return false }
        return exams.contains { $0.type == .continuousControl }
    }

    public func examsContainOptions() -> Bool {
        guard let exams else { return false }
        return exams.contains { $0.type == .option }
    }

    public func worstExamGrade() -> Float? {
        examsGradeOutOfTwenty().min()
    }

    public func bestExamGrade() -> Float? {
        examsGradeOutOfTwenty().max()
    }

    private func examsGradeOutOfTwenty() -> [Float] {
        guard let exams else { return [] }
        return exams
            .map { $0.getGradeInformation() }
            .map { ($0.lhs / $0.rhs) * 20 }
    }

    public func remove(exam: Exam) {
        exams?.remove(exam)
    }

    public func add(exam: Exam) {
        exams?.insert(exam)
    }

    public func average() -> Float {
        guard let exams else { return -1 }
        var totalGrade: Float = 0
        var totalOn: Float = 0

        var filteredExams = exams
            .map { $0.getGradeInformation() }

        filteredExams.removeAll { $0.lhs == -1 || $0.rhs == -1 || $0.coeff == -1 }

        filteredExams.forEach {
            totalGrade += $0.lhs * $0.coeff
            totalOn += $0.rhs * $0.coeff
        }

        guard totalOn > 0 else { return -1 }

        return (totalGrade / totalOn) * 20
    }

    public func mention() -> Mention {
        guard let exams else { return .without }
        var totalGrade: Float = 0
        var totalOn: Float = 0

        var filteredExams = exams
            .map { $0.getGradeInformation() }

        filteredExams.removeAll { $0.lhs == -1 || $0.rhs == -1 || $0.coeff == -1 }
        if filteredExams.count != exams.count { return .cannotBeCalculated }

        filteredExams.forEach {
            totalGrade += $0.lhs * $0.coeff
            totalOn += $0.rhs * $0.coeff
        }

        let mentionCalculator = MentionCalculator(simulationType: type,
                                                  totalGrade: totalGrade,
                                                  totalOutOf: totalOn)

        return mentionCalculator.mention()
    }

    public func mergeAndConvertExams(in context: NSManagedObjectContext, for cdSimulation: CDSimulation) -> Set<CDExam> {
        var cdExams: Set<CDExam> = .init()

        let trials = exams(of: .trial)
        let continousControls = exams(of: .continuousControl)
        let options = exams(of: .option)

        _ = trials.map { cdExams.insert($0.toCoreDataModel(in: context, for: cdSimulation)) }
        _ = continousControls.map { cdExams.insert($0.toCoreDataModel(in: context, for: cdSimulation)) }
        _ = options.map { cdExams.insert($0.toCoreDataModel(in: context, for: cdSimulation)) }

        return cdExams
    }

    public func copy(with _: NSZone? = nil) -> Any {
        guard let examsCopy = exams?.map({ $0.copy() }) as? [Exam] else { return -1 }
        return Simulation(name: name, date: date, exams: Set(examsCopy), type: type)
    }
}
