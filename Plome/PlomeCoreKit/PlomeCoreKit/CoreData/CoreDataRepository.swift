//
//  CoreDataRepository.swift
//  Reciplease
//
//  Created by Loic Mazuc on 28/06/2022.
//

import CoreData
import Combine

final class CoreDataRepository<CoreDataEntity: NSManagedObject> {
    
    // MARK: - Properties
    
    private let mainContext: NSManagedObjectContext
    
    // MARK: - Init
    
    init(storageProvider: StorageProvider) {
        self.mainContext = storageProvider.context
    }
}

// MARK: - Methods

extension CoreDataRepository {
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
               let firstEntity = results.first {
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
            
            try mainContext.save()
        }
    }
    
    func update(_ entity: CoreDataEntity) throws {
        try mainContext.performAndWait {
            try mainContext.save()
        }
    }
    
    func delete(with id: NSManagedObjectID) throws {
        guard let entity = try mainContext.existingObject(with: id) as? CoreDataEntity else {
            throw CoreDataManagerError.objectNotFound
        }

        try mainContext.performAndWait {
            mainContext.delete(entity)
            try mainContext.save()
        }
    }
    
    func delete(predicate: NSPredicate? = nil, sortDescriptors: [NSSortDescriptor] = []) throws {
        let request = CoreDataEntity.fetchRequest()
        request.sortDescriptors = sortDescriptors
        request.predicate = predicate
        
        try mainContext.performAndWait {
            if let results = try mainContext.fetch(request) as? [CoreDataEntity],
               let firstEntity = results.first {
                mainContext.delete(firstEntity)
                try mainContext.save()
            } else {
                throw CoreDataManagerError.objectNotFound
            }
        }
    }
    
    func deleteAll() throws {
        guard let entityName: String = CoreDataEntity.entity().name else {
            throw CoreDataManagerError.entityNameNotFound
        }
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        
        try mainContext.performAndWait {
            // Need to do this to update UI, don't know why after many hours of searching...
            // _ = try backgroundContext.fetch(fetchRequest)
            
            try mainContext.deleteAndMergeChanges(using: deleteRequest)
            try mainContext.save()
        }
    }
}