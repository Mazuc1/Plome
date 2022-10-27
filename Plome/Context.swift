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

public protocol ContextProtocol: AnyObject {
    var defaultSimulationModelsProvider: DefaultSimulationModelsProvider { get }
}

public final class Context: ContextProtocol {
    public var defaultSimulationModelsProvider: PlomeCoreKit.DefaultSimulationModelsProvider

    public init() {
        defaultSimulationModelsProvider = DefaultSimulationModelsProvider()
    }
}
