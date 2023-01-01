//
//  CDSimulation+CoreDataProperties.swift
//
//
//  Created by Loic Mazuc on 14/10/2022.
//
//

import CoreData
import Foundation

@objc public enum SimulationType: Int16, Codable {
    case custom
    case brevet
    case generalBAC
    case technologicalBAC
}

@objc(CDSimulation)
public class CDSimulation: NSManagedObject {}

public extension CDSimulation {
    @nonobjc class func fetchRequest() -> NSFetchRequest<CDSimulation> {
        return NSFetchRequest<CDSimulation>(entityName: "CDSimulation")
    }

    @NSManaged var name: String
    @NSManaged var date: Date?
    @NSManaged var exams: Set<CDExam>?
    @NSManaged var type: SimulationType

    func toModelObject() -> Simulation {
        let simulation = Simulation(name: name, date: date, exams: .init(), type: type)
        let exams = exams?.map {
            Exam(name: $0.name, coefficient: $0.coefficient, grade: $0.grade, type: $0.type)
        }
        simulation.exams = Set(exams ?? [])

        return simulation
    }
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

// MARK: - Sort descriptor

public extension CDSimulation {
    static let alphabeticDescriptor = NSSortDescriptor(key: "name", ascending: true)
    static let dateDescriptor = NSSortDescriptor(key: "date", ascending: false)
}

// MARK: - Predicate

public extension CDSimulation {
    static let withoutDatePredicate = NSPredicate(format: "date = nil")
    static let withDatePredicate = NSPredicate(format: "date != nil")
}
