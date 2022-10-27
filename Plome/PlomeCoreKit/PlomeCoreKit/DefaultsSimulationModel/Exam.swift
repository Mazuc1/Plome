//
//  Exam.swift
//  PlomeCoreKit
//
//  Created by Loic Mazuc on 14/10/2022.
//

import Foundation

public struct Exam: Hashable {
    public init(name: String, coefficient: Float?, grade: Float?, type: ExamType) {
        self.name = name
        self.coefficient = coefficient
        self.grade = grade
        self.type = type
    }

    public let name: String
    public let coefficient: Float?
    public let grade: Float?
    public let type: ExamType
}
