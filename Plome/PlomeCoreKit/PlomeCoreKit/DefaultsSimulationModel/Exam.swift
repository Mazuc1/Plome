//
//  Exam.swift
//  PlomeCoreKit
//
//  Created by Loic Mazuc on 14/10/2022.
//

import CoreData
import Foundation

public class Exam: NSObject, NSCopying, Codable {
    // MARK: - Properties

    public enum Rule {
        case grade
        case coeff

        public var regex: String {
            switch self {
            case .grade: return "^[0-9]+(?:\\.[0-9]{1,2})?[/][0-9]+(?:\\.[0-9]{1,2})?$"
            case .coeff: return "^[0-9]+(?:\\.[0-9]{1,2})?$"
            }
        }
    }

    private enum CodingKeys: String, CodingKey {
        case name, coefficient, grade, type
    }

    public var name: String
    public var coefficient: Float?
    public var grade: String?
    public var type: ExamType

    // MARK: - Init

    public init(name: String, coefficient: Float?, grade: String?, type: ExamType) {
        self.name = name
        self.coefficient = coefficient
        self.grade = grade
        self.type = type
    }

    public required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        name = try container.decode(String.self, forKey: .name)
        coefficient = try? container.decode(Float.self, forKey: .coefficient)
        grade = try? container.decode(String.self, forKey: .grade)
        type = try container.decode(ExamType.self, forKey: .type)
    }

    // MARK: - Methods

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(name, forKey: .name)
        try container.encode(coefficient, forKey: .coefficient)
        try container.encode(grade, forKey: .grade)
        try container.encode(type, forKey: .type)
    }

    public func toCoreDataModel(in context: NSManagedObjectContext, for simulation: CDSimulation) -> CDExam {
        let cdExam = CDExam(context: context)
        cdExam.name = name
        cdExam.coefficient = coefficient ?? 0
        cdExam.grade = grade ?? ""
        cdExam.type = type
        cdExam.simulation = simulation

        return cdExam
    }

    public func save(_ text: String, ifIsConformTo rule: Rule) -> Bool {
        switch rule {
        case .grade:
            let isConform = text ~= rule.regex && checkRatioFor(text)
            if isConform { grade = text } else { grade = nil }
            return isConform
        case .coeff:
            let isConform = text ~= rule.regex
            if isConform { coefficient = Float(text) } else { coefficient = nil }
            return isConform
        }
    }

    func splittedGrade() -> (lhs: Float, rhs: Float)? {
        guard let grade = grade?.split(separator: "/"),
              let lhsFloat = Float(grade[0]),
              let rhsFloat = Float(grade[1]) else { return nil }
        return (lhsFloat, rhsFloat)
    }

    public func getGradeInformation() -> (lhs: Float, rhs: Float, coeff: Float) {
        guard let splittedGrade = splittedGrade() else { return (-1, -1, -1) }
        return (splittedGrade.lhs, splittedGrade.rhs, coefficient ?? 1)
    }

    func isGradeLowerThanItsOutOf() -> Bool {
        guard let splittedGrade = splittedGrade() else { return false }
        return splittedGrade.lhs < (splittedGrade.rhs / 2)
    }

    func addOnePoint() {
        guard let splittedGrade = splittedGrade() else { return }
        if splittedGrade.lhs + 1 > splittedGrade.rhs { return }

        grade = "\(splittedGrade.lhs + 1)/\(splittedGrade.rhs)"
    }

    func checkRatioFor(_ text: String) -> Bool {
        let values = text.split(separator: "/")
        guard let lhsFloat = Float(values[0]),
              let rhsFloat = Float(values[1]) else { return false }

        return lhsFloat <= rhsFloat
    }

    public func truncatedGrade() -> String? {
        guard let splittedGrade = splittedGrade() else { return nil }

        let gradeOutOfTwenty = (splittedGrade.lhs / splittedGrade.rhs) * 20
        return "\(gradeOutOfTwenty.truncate(places: 2))/20"
    }

    public func copy(with _: NSZone? = nil) -> Any {
        Exam(name: name, coefficient: coefficient, grade: grade, type: type)
    }
}
