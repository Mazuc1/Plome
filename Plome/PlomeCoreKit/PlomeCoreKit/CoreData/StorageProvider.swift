//
//  StorageProvider.swift
//  PlomeCoreKit
//
//  Created by Loic Mazuc on 09/10/2022.
//

import CoreData
import Dependencies

public class PersistentContainer: NSPersistentContainer {}

public class StorageProvider {
    // MARK: - Properties

    static let modelName = "Plome"

    static let model: NSManagedObjectModel = {
        let modelURL = Module.bundle.url(forResource: modelName, withExtension: "momd")!
        return NSManagedObjectModel(contentsOf: modelURL)!
    }()

    public lazy var context: NSManagedObjectContext = {
        let context = persistentContainer.viewContext
        context.automaticallyMergesChangesFromParent = true
        return context
    }()

    public lazy var persistentContainer: PersistentContainer = {
        let container = PersistentContainer(name: Self.modelName, managedObjectModel: Self.model)
        container.loadPersistentStores { _, error in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        }
        return container
    }()

    // MARK: - Init

    public init() {}
}

private enum StorageProviderKey: DependencyKey {
    static var liveValue: StorageProvider {
        StorageProvider()
    }
}

public extension DependencyValues {
    var storageProvider: StorageProvider {
        get { self[StorageProviderKey.self] }
        set { self[StorageProviderKey.self] = newValue }
    }
}
