//
//  DefaultSimulationModelStorageService.swift
//  PlomeCoreKit
//
//  Created by Loic Mazuc on 02/12/2022.
//

import Foundation

public protocol DefaultSimulationModelStorageServiceProtocol {
    func addDefaultSimulationModelIfNeeded()
}

public class DefaultSimulationModelStorageService: DefaultSimulationModelStorageServiceProtocol {
    // MARK: - Properties

    enum Error: Swift.Error {
        case failedToAddDefaultSimulationModels

        var errorDescription: String? {
            return "\(self)"
        }
    }

    private let userDefault: DefaultsProtocol
    private let simulationRepository: CoreDataRepository<CDSimulation>
    private let defaultSimulationModelsProvider: DefaultSimulationModelsProvider

    // MARK: - Init

    public init(userDefault: DefaultsProtocol, simulationRepository: CoreDataRepository<CDSimulation>) {
        self.userDefault = userDefault
        self.simulationRepository = simulationRepository
        defaultSimulationModelsProvider = DefaultSimulationModelsProvider()
    }

    // MARK: - Methods

    public func addDefaultSimulationModelIfNeeded() {
        guard userDefault.getData(type: Bool.self, forKey: .isSimulationModelRegister) != nil else {
            addSimulationModels()
            userDefault.setData(value: true, key: .isSimulationModelRegister)
            return
        }
    }

    private func addSimulationModels() {
        defaultSimulationModelsProvider.simulations
            .forEach { simulation in
                do {
                    try simulationRepository.add { cdSimulation, context in
                        cdSimulation.name = simulation.name
                        cdSimulation.type = simulation.type
                        cdSimulation.exams = simulation.mergeAndConvertExams(in: context, for: cdSimulation)
                    }
                } catch {
                    PlomeCoreKitModule.log(error: Error.failedToAddDefaultSimulationModels)
                }
            }
    }
}
