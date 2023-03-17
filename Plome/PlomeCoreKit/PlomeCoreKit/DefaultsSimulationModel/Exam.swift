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

    public static let defaultGradeValue: Float = -1.0

    public enum Field {
        case grade
        case ratio
        case coeff
    }

    private enum CodingKeys: String, CodingKey {
        case name, coefficient, grade, ratio, type
    }

    public var name: String
    public var coefficient: Float?
    public var type: ExamType
    public var grade: Float?
    public var ratio: Float?

    // MARK: - Init

    public init(name: String, coefficient: Float?, grade: Float?, ratio: Float?, type: ExamType) {
        self.name = name
        self.coefficient = coefficient
        self.grade = grade
        self.ratio = ratio
        self.type = type
    }

    public required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        name = try container.decode(String.self, forKey: .name)
        coefficient = try? container.decode(Float.self, forKey: .coefficient)
        grade = try? container.decode(Float.self, forKey: .grade)
        ratio = try? container.decode(Float.self, forKey: .ratio)
        type = try container.decode(ExamType.self, forKey: .type)
    }

    // MARK: - Methods

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(name, forKey: .name)
        try container.encode(coefficient, forKey: .coefficient)
        try container.encode(grade, forKey: .grade)
        try container.encode(ratio, forKey: .ratio)
        try container.encode(type, forKey: .type)
    }

    public func toCoreDataModel(in context: NSManagedObjectContext, for simulation: CDSimulation) -> CDExam {
        let cdExam = CDExam(context: context)
        cdExam.name = name
        cdExam.coefficient = coefficient ?? 0
        cdExam.grade = grade ?? Self.defaultGradeValue
        cdExam.ratio = ratio ?? 0.0
        cdExam.type = type
        cdExam.simulation = simulation

        return cdExam
    }

    public func save(_ text: String?, in field: Field) -> Bool {
        guard let text = text,
              !text.isEmpty,
              let value = Float(text) else { return false }

        switch field {
        case .grade:
            guard let ratio, value <= ratio else { return false }
            grade = value
        case .coeff: coefficient = value
        case .ratio: ratio = value
        }

        return true
    }

    public func getGradeInformation() -> (lhs: Float, rhs: Float, coeff: Float) {
        guard let grade, let ratio else { return (-1, -1, -1) }
        return (grade, ratio, coefficient ?? 1)
    }

    func isGradeLowerThanAverageRatio() -> Bool {
        guard let grade, let ratio else { return false }
        return grade < (ratio / 2)
    }

    func addOnePoint() {
        guard let grade, let ratio else { return }
        if grade + 1 > ratio { return }

        self.grade = grade + 1
    }

    public func truncatedGrade() -> String? {
        guard let grade, let ratio else { return nil }

        let gradeOutOfTwenty = (grade / ratio) * 20
        return "\(gradeOutOfTwenty.truncate(places: 2))/20"
    }

    public func copy(with _: NSZone? = nil) -> Any {
        Exam(name: name, coefficient: coefficient, grade: grade, ratio: ratio, type: type)
    }
}
