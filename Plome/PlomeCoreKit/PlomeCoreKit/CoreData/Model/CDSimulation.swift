//
//  CDSimulation+CoreDataProperties.swift
//  
//
//  Created by Loic Mazuc on 14/10/2022.
//
//

import Foundation
import CoreData

@objc public enum SimulationType: Int16 {
    case brevet
    case BAC
    case CAP
    case custom
}

@objc(CDSimulation)
public class CDSimulation: NSManagedObject {}

extension CDSimulation {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CDSimulation> {
        return NSFetchRequest<CDSimulation>(entityName: "CDSimulation")
    }

    @NSManaged public var date: Date?
    @NSManaged public var type: SimulationType
    @NSManaged public var exams: Set<CDExam>?

}

// MARK: Generated accessors for exams
extension CDSimulation {

    @objc(addExamsObject:)
    @NSManaged public func addToExams(_ value: CDExam)

    @objc(removeExamsObject:)
    @NSManaged public func removeFromExams(_ value: CDExam)

    @objc(addExams:)
    @NSManaged public func addToExams(_ values: NSSet)

    @objc(removeExams:)
    @NSManaged public func removeFromExams(_ values: NSSet)

}
