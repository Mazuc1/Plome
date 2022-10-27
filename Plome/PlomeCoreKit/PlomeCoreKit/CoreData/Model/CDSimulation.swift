//
//  CDSimulation+CoreDataProperties.swift
//
//
//  Created by Loic Mazuc on 14/10/2022.
//
//

import CoreData
import Foundation

@objc(CDSimulation)
public class CDSimulation: NSManagedObject {}

public extension CDSimulation {
    @nonobjc class func fetchRequest() -> NSFetchRequest<CDSimulation> {
        return NSFetchRequest<CDSimulation>(entityName: "CDSimulation")
    }

    @NSManaged var name: String
    @NSManaged var date: Date?
    @NSManaged var exams: Set<CDExam>?
}

// MARK: Generated accessors for exams

public extension CDSimulation {
    @objc(addExamsObject:)
    @NSManaged func addToExams(_ value: CDExam)

    @objc(removeExamsObject:)
    @NSManaged func removeFromExams(_ value: CDExam)

    @objc(addExams:)
    @NSManaged func addToExams(_ values: NSSet)

    @objc(removeExams:)
    @NSManaged func removeFromExams(_ values: NSSet)
}
