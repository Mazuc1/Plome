//
//  Values.swift
//  PlomeCoreKit
//
//  Created by Loic Mazuc on 05/02/2023.
//

import Dependencies
import Foundation

// MARK: - Defaults

enum DefaultKey: DependencyKey {
    static var liveValue: DefaultsProtocol = Defaults()
}

public extension DependencyValues {
    var userDefault: DefaultsProtocol {
        get { self[DefaultKey.self] }
        set { self[DefaultKey.self] = newValue }
    }
}

// MARK: - DefaultSimulationModelsProvider

enum DefaultSimulationModelsProviderKey: DependencyKey {
    static var liveValue: DefaultSimulationModelsProvider = .init()
}

public extension DependencyValues {
    var defaultSimulationModelsProvider: DefaultSimulationModelsProvider {
        get { self[DefaultSimulationModelsProviderKey.self] }
        set { self[DefaultSimulationModelsProviderKey.self] = newValue }
    }
}

// MARK: - DefaultSimulationModelStorageService

enum DefaultSimulationModelStorageServiceKey: DependencyKey {
    static var liveValue: DefaultSimulationModelStorageServiceProtocol = DefaultSimulationModelStorageService()
}

public extension DependencyValues {
    var defaultSimulationModelStorageService: DefaultSimulationModelStorageServiceProtocol {
        get { self[DefaultSimulationModelStorageServiceKey.self] }
        set { self[DefaultSimulationModelStorageServiceKey.self] = newValue }
    }
}

// MARK: - StorageProvider

enum StorageProviderKey: DependencyKey {
    static var liveValue: StorageProvider = .init()
    static var testValue: StorageProvider = MockStorageProvider()
}

public extension DependencyValues {
    var storageProvider: StorageProvider {
        get { self[StorageProviderKey.self] }
        set { self[StorageProviderKey.self] = newValue }
    }
}

// MARK: - CoreDataRepository<CDSimulation>

enum CoreDataSimulationRepositoryKey: DependencyKey {
    static var liveValue: CoreDataRepository<CDSimulation> {
        @Dependency(\.storageProvider) var storageProvider

        return .init(storageProvider: storageProvider)
    }

    static var testValue: CoreDataRepository<CDSimulation> {
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
