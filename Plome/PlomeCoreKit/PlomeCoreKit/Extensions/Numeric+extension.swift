//
//  Numeric+extension.swift
//  PlomeCoreKit
//
//  Created by Loic Mazuc on 15/11/2022.
//

import Foundation

public extension Float {
    func truncate(places: Int) -> Float {
        return Float(floor(pow(10.0, Float(places)) * self) / pow(10.0, Float(places)))
    }
}
