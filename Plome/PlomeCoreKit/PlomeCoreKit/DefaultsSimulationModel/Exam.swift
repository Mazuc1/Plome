//
//  Exam.swift
//  PlomeCoreKit
//
//  Created by Loic Mazuc on 14/10/2022.
//

import CoreData
import Foundation

public struct Exam: Hashable {
    public enum Regex {
        case grade
        case coeff
        
        public var regex: String {
            switch self {
            case .grade: return "^[0-9]+(?:\\.[0-9]{1,2})?[/][0-9]+(?:\\.[0-9]{1,2})?$"
            case .coeff: return "^[0-9]+(?:\\.[0-9]{1,2})?$"
            }
        }
    }
    
    public let name: String
    public let coefficient: Float?
    public let grade: String?
    public let type: ExamType
    
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
}

/*
 https://stackoverflow.com/questions/29399685/regex-for-numbers-with-optional-decimal-value-fixed-to-two-positions
 */
