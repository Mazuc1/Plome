//
//  StorageProvider.swift
//  PlomeCoreKit
//
//  Created by Loic Mazuc on 09/10/2022.
//

import CoreData

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
        let container = PersistentContainer(name: Self.modelName)
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

public enum StoreType {
    case inMemory, persisted
}
