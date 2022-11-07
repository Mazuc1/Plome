//
//  Exam.swift
//  PlomeCoreKit
//
//  Created by Loic Mazuc on 14/10/2022.
//

import CoreData
import Foundation

public class Exam: Hashable {
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

    public var name: String
    public var coefficient: Float?
    public var grade: String?
    public var type: ExamType

    public init(name: String, coefficient: Float?, grade: String?, type: ExamType) {
        self.name = name
        self.coefficient = coefficient
        self.grade = grade
        self.type = type
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
            if isConform {
                grade = text
            }
            return isConform
        case .coeff:
            let isConform = text ~= rule.regex
            if isConform { coefficient = Float(text) }
            return isConform
        }
    }

    private func checkRatioFor(_ text: String) -> Bool {
        let values = text.split(separator: "/")
        guard let lhsFloat = Float(values[0]),
              let rhsFloat = Float(values[1]) else { return false }

        return lhsFloat <= rhsFloat
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(ObjectIdentifier(self))
    }
}

extension Exam: Equatable {
    public static func == (lhs: Exam, rhs: Exam) -> Bool {
        ObjectIdentifier(lhs) == ObjectIdentifier(rhs)
    }
}

/*
 https://stackoverflow.com/questions/29399685/regex-for-numbers-with-optional-decimal-value-fixed-to-two-positions
 */
