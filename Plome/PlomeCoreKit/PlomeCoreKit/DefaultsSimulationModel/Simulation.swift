//
//  Simulation.swift
//  PlomeCoreKit
//
//  Created by Loic Mazuc on 21/10/2022.
//

import CoreData
import Foundation

public class Simulation: NSObject, NSCopying {
    // MARK: - Properties

    public let name: String
    public var date: Date?
    public var exams: Set<Exam>?
    public var type: SimulationType

    // MARK: - Init

    public init(name: String, date: Date?, exams: Set<Exam>?, type: SimulationType) {
        self.name = name
        self.date = date
        self.exams = exams
        self.type = type
    }

    // MARK: - Methods

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
