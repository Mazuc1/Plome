//
//  MockStorageProvider.swift
//  PlomeCoreKit
//
//  Created by Loic Mazuc on 06/02/2023.
//

import CoreData
import Foundation

final class MockStorageProvider: StorageProvider {
    override init() {
        super.init()

        let persistentStoreDescription = NSPersistentStoreDescription()
        persistentStoreDescription.type = NSInMemoryStoreType

        let container = PersistentContainer(name: Self.modelName, managedObjectModel: StorageProvider.model)
        container.persistentStoreDescriptions = [persistentStoreDescription]

        container.loadPersistentStores { _, error in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        }

        persistentContainer = container
    }
}

