//
//  Dependencies.swift
//  Plome
//
//  Created by Loic Mazuc on 05/02/2023.
//

import Foundation
import Factory

final class PlomeContainer: SharedContainer {
    static var shared = PlomeContainer()
    var manager = ContainerManager()
}

extension PlomeContainer {
    var shareSimulationModelService: Factory<ShareSimulationModelServiceProtocol> {
        self { ShareSimulationModelService() }
            .shared
    }
}
