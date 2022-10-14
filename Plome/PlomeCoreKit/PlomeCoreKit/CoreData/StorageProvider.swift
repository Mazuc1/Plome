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
    
    public let persistentContainer: PersistentContainer
    
    public lazy var context: NSManagedObjectContext = {
        persistentContainer.viewContext
    }()
    
    // MARK: - Init
    
    public init(storeType: StoreType = .persisted) {
        persistentContainer = PersistentContainer(name: "Chapter11")
        
        if storeType == .inMemory {
            let persistentStoreDescription = NSPersistentStoreDescription()
            persistentStoreDescription.type = NSInMemoryStoreType
            persistentStoreDescription.url = URL(fileURLWithPath: "/dev/null")
            
            persistentContainer.persistentStoreDescriptions = [persistentStoreDescription]
        }
        
        persistentContainer.loadPersistentStores(completionHandler: { description, error in
            if let error = error {
                fatalError("Core Data store failed to load with error: \(error)")
            }
        })
    }
}

public enum StoreType {
    case inMemory, persisted
}
