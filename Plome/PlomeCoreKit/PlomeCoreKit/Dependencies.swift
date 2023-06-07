//
//  Values.swift
//  PlomeCoreKit
//
//  Created by Loic Mazuc on 05/02/2023.
//

import Factory
import Foundation

public final class CoreKitContainer: SharedContainer {
    public static var shared = CoreKitContainer()
    public var manager = ContainerManager()
}

public extension CoreKitContainer {
    var userDefault: Factory<DefaultsProtocol> {
        self { Defaults() }
            .shared
    }

    var defaultSimulationModelsProvider: Factory<DefaultSimulationModelsProvider> {
        self { DefaultSimulationModelsProvider() }
            .shared
    }

    var defaultSimulationModelStorageService: Factory<DefaultSimulationModelStorageServiceProtocol> {
        self { DefaultSimulationModelStorageService() }
            .shared
    }

    var storageProvider: Factory<StorageProvider> {
        self { StorageProvider() }
            .shared
    }

    var coreDataSimulationRepository: Factory<CoreDataRepository<CDSimulation>> {
        self { .init(storageProvider: self.storageProvider()) }
            .shared
    }
}
