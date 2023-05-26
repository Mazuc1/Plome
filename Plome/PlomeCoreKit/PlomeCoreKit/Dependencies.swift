//
//  Values.swift
//  PlomeCoreKit
//
//  Created by Loic Mazuc on 05/02/2023.
//

import Foundation
import Factory

public final class CoreKitContainer: SharedContainer {
    public static var shared = CoreKitContainer()
    public var manager = ContainerManager()
}

public extension CoreKitContainer {
    var userDefault: Factory<DefaultsProtocol> {
        self { Defaults() }
    }
    
    var defaultSimulationModelsProvider: Factory<DefaultSimulationModelsProvider> {
        self { DefaultSimulationModelsProvider() }
    }
    
    var defaultSimulationModelStorageService: Factory<DefaultSimulationModelStorageServiceProtocol> {
        self { DefaultSimulationModelStorageService() }
    }
    
    var storageProvider: Factory<StorageProvider> {
        self { StorageProvider() }
    }
    
    var coreDataSimulationRepository: Factory<CoreDataRepository<CDSimulation>> {
        self { .init(storageProvider: self.storageProvider()) }
    }
}
