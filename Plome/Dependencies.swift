//
//  Dependencies.swift
//  Plome
//
//  Created by Loic Mazuc on 05/02/2023.
//

import Dependencies
import Foundation

// MARK: - ShareSimulationModelService

enum ShareSimulationModelServiceKey: DependencyKey {
    static var liveValue: ShareSimulationModelServiceProtocol = ShareSimulationModelService()
}

extension DependencyValues {
    var shareSimulationModelService: ShareSimulationModelServiceProtocol {
        get { self[ShareSimulationModelServiceKey.self] }
        set { self[ShareSimulationModelServiceKey.self] = newValue }
    }
}
