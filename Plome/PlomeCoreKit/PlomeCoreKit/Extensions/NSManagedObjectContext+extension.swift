//
//  NSManagedObjectContext+extension.swift
//  Reciplease
//
//  Created by Loic Mazuc on 01/07/2022.
//

import Foundation
import CoreData

extension NSManagedObjectContext {
    func deleteAndMergeChanges(using batchDeleteRequest: NSBatchDeleteRequest) throws {
        batchDeleteRequest.resultType = .resultTypeObjectIDs
        let result = try execute(batchDeleteRequest) as? NSBatchDeleteResult
        let changes: [AnyHashable: Any] = [NSDeletedObjectsKey: result?.result as? [NSManagedObjectID] ?? []]
        NSManagedObjectContext.mergeChanges(fromRemoteContextSave: changes, into: [self])
    }
    
    var hasPersistentChanges: Bool {
        return !insertedObjects.isEmpty || !deletedObjects.isEmpty || updatedObjects.contains(where: { $0.hasPersistentChangedValues })
    }
    
    @discardableResult func saveIfNeeded() throws -> Bool {
        let hasPurpose = parent != nil || persistentStoreCoordinator?.persistentStores.isEmpty == false
        guard hasPersistentChanges && hasPurpose else { return false }

        try save()
        return true
    }
}
