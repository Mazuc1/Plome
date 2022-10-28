//
//  InternalModuleProtocol.swift
//  EvaneosCoreKit
//
//  Created by Charles-Adrien Fournier on 18/02/2020.
//  Copyright © 2020 evaneos. All rights reserved.
//

import Foundation

/// This protocol is used to declare the bundle used for loading assets
/// You only need to create a class that inherit from this protocol
public protocol ModuleProtocol: AnyObject {
    static var bundle: Bundle { get }
}

public extension ModuleProtocol {
    static var bundle: Bundle {
        return Bundle(for: self)
    }
}

class Module: ModuleProtocol {}
