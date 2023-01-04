//
//  CDExam+CoreDataProperties.swift
//
//
//  Created by Loic Mazuc on 27/10/2022.
//
//

import CoreData
import Foundation

@objc public enum ExamType: Int16, Codable {
    case trial
    case option
    case continuousControl
}

@objc(CDExam)
public class CDExam: NSManagedObject {}

public extension CDExam {
    @nonobjc class func fetchRequest() -> NSFetchRequest<CDExam> {
        return NSFetchRequest<CDExam>(entityName: "CDExam")
    }

    @NSManaged var coefficient: Float
    @NSManaged var grade: String
    @NSManaged var name: String
    @NSManaged var type: ExamType
    @NSManaged var simulation: CDSimulation?
}
