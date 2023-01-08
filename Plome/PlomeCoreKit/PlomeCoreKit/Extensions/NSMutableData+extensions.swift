//
//  NSMutableData+extensions.swift
//  PlomeCoreKit
//
//  Created by Loic Mazuc on 08/01/2023.
//

import Foundation

public extension NSMutableData {
    func appendString(_ string: String) {
        if let data = string.data(using: .utf8) {
            append(data)
        }
    }
}
