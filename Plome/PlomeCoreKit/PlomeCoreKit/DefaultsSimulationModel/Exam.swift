//
//  Exam.swift
//  PlomeCoreKit
//
//  Created by Loic Mazuc on 14/10/2022.
//

import Foundation

public struct Exam: Hashable {
    let name: String
    let coefficient: Float?
    let grade: Float?
    let type: ExamType
}
