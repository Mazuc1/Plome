//
//  CDExam+CoreDataProperties.swift
//  
//
//  Created by Loic Mazuc on 27/10/2022.
//
//

import Foundation
import CoreData

@objc public enum ExamType: Int16 {
    case trial
    case option
    case continuousControl
}

@objc(CDExam)
public class CDExam: NSManagedObject {}

extension CDExam {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CDExam> {
        return NSFetchRequest<CDExam>(entityName: "CDExam")
    }

    @NSManaged public var coefficient: Float
    @NSManaged public var grade: Float
    @NSManaged public var name: String
    @NSManaged public var type: ExamType
    @NSManaged public var simulation: CDSimulation?

}
