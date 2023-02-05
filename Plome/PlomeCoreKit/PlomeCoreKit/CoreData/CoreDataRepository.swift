//
//  CoreDataRepository.swift
//  Reciplease
//
//  Created by Loic Mazuc on 28/06/2022.
//

import Combine
import CoreData
import Dependencies

public final class CoreDataRepository<CoreDataEntity: NSManagedObject> {
    // MARK: - Properties

    public let mainContext: NSManagedObjectContext

    // MARK: - Init

    public init(storageProvider: StorageProvider) {
        mainContext = storageProvider.context
    }
}

// MARK: - Methods

public extension CoreDataRepository {
    func list(sortDescriptors: [NSSortDescriptor] = [], predicate: NSPredicate? = nil) throws -> [CoreDataEntity] {
        try mainContext.performAndWait {
            let request = CoreDataEntity.fetchRequest()
            request.sortDescriptors = sortDescriptors
            request.predicate = predicate

            if let results = try mainContext.fetch(request) as? [CoreDataEntity] {
                return results
            } else {
                throw CoreDataManagerError.failedToCast
            }
        }
    }

    func get(with id: NSManagedObjectID) throws -> CoreDataEntity {
        try mainContext.performAndWait {
            guard let entity = try mainContext.existingObject(with: id) as? CoreDataEntity else {
                throw CoreDataManagerError.objectNotFound
            }
            return entity
        }
    }

    func get(sortDescriptors: [NSSortDescriptor] = [], predicate: NSPredicate? = nil) throws -> CoreDataEntity {
        try mainContext.performAndWait {
            let request = CoreDataEntity.fetchRequest()
            request.sortDescriptors = sortDescriptors
            request.predicate = predicate

            if let results = try mainContext.fetch(request) as? [CoreDataEntity],
               let firstEntity = results.first
            {
                return firstEntity
            } else {
                throw CoreDataManagerError.objectNotFound
            }
        }
    }

    func add(_ body: @escaping (inout CoreDataEntity, NSManagedObjectContext) -> Void) throws {
        try mainContext.performAndWait {
            var entity = CoreDataEntity(context: mainContext)
            body(&entity, mainContext)

            try mainContext.saveIfNeeded()
        }
    }

    func update(_ body: @escaping (NSManagedObjectContext) -> Void) throws {
        _ = try mainContext.performAndWait {
            body(mainContext)
            try mainContext.saveIfNeeded()
        }
    }

    func delete(with id: NSManagedObjectID) throws {
        guard let entity = try mainContext.existingObject(with: id) as? CoreDataEntity else {
            throw CoreDataManagerError.objectNotFound
        }

        try mainContext.performAndWait {
            mainContext.delete(entity)
            try mainContext.saveIfNeeded()
        }
    }

    func delete(predicate: NSPredicate? = nil, sortDescriptors: [NSSortDescriptor] = []) throws {
        let request = CoreDataEntity.fetchRequest()
        request.sortDescriptors = sortDescriptors
        request.predicate = predicate

        try mainContext.performAndWait {
            if let results = try mainContext.fetch(request) as? [CoreDataEntity],
               let firstEntity = results.first
            {
                mainContext.delete(firstEntity)
                try mainContext.saveIfNeeded()
            } else {
                throw CoreDataManagerError.objectNotFound
            }
        }
    }

    func deleteAll(where predicate: NSPredicate? = nil, sortDescriptors: [NSSortDescriptor] = []) throws {
        try list(sortDescriptors: sortDescriptors, predicate: predicate)
            .forEach {
                mainContext.delete($0)
            }

        try mainContext.saveIfNeeded()
    }

    func deleteAll() throws {
        guard let entityName: String = CoreDataEntity.entity().name else {
            throw CoreDataManagerError.entityNameNotFound
        }

        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)

        try mainContext.performAndWait {
            try mainContext.deleteAndMergeChanges(using: deleteRequest)
            try mainContext.saveIfNeeded()
        }
    }
}

private enum CoreDataSimulationRepositoryKey: DependencyKey {
    static var liveValue: CoreDataRepository<CDSimulation> {
        @Dependency(\.storageProvider) var storageProvider
        
        return .init(storageProvider: storageProvider)
    }
}

public extension DependencyValues {
    var coreDataSimulationRepository: CoreDataRepository<CDSimulation> {
        get { self[CoreDataSimulationRepositoryKey.self] }
        set { self[CoreDataSimulationRepositoryKey.self] = newValue }
    }
}
