//
//  Context.swift
//  PineappleCoreKit
//
//  Created by Loic Mazuc on 14/07/2022.
//

import CoreData
import Foundation
import PlomeCoreKit
import UserNotifications

protocol ContextProtocol: AnyObject {
    var userDefaults: Defaults { get }
    var defaultSimulationModelStorageService: DefaultSimulationModelStorageServiceProtocol { get }
    var defaultSimulationModelsProvider: DefaultSimulationModelsProvider { get }
    var storageProvider: StorageProvider { get }
    var simulationRepository: CoreDataRepository<CDSimulation> { get }
}

final class Context: ContextProtocol {
    let userDefaults: Defaults
    let defaultSimulationModelStorageService: DefaultSimulationModelStorageServiceProtocol
    let defaultSimulationModelsProvider: DefaultSimulationModelsProvider
    let simulationRepository: CoreDataRepository<CDSimulation>
    let storageProvider: StorageProvider

    init() {
        userDefaults = Defaults()
        defaultSimulationModelsProvider = DefaultSimulationModelsProvider()

        storageProvider = StorageProvider()
        simulationRepository = CoreDataRepository(storageProvider: storageProvider)

        defaultSimulationModelStorageService = DefaultSimulationModelStorageService(userDefault: userDefaults, simulationRepository: simulationRepository)
    }
}
