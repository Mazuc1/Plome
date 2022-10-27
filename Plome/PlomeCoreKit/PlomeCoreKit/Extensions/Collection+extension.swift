//
//  Collection+extension.swift
//  PlomeCoreKit
//
//  Created by Loic Mazuc on 27/10/2022.
//

import Foundation

public extension Collection {
    /// Returns the element at the specified index if it is within bounds, otherwise nil.
    subscript(safe index: Index) -> Element? {
        return indices.contains(index) ? self[index] : nil
    }
}
