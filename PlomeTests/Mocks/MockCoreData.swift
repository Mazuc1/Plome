//
//  MockCoreData.swift
//  RecipleaseTests
//
//  Created by Loic Mazuc on 25/09/2022.
//

import CoreData
import Foundation
@testable import Plome
@testable import PlomeCoreKit

let testContext = Context()

final class MockCoreData: StorageProvider {
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
