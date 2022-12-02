//
//  UIFont+extension.swift
//  PlomeCoreKit
//
//  Created by Loic Mazuc on 08/10/2022.
//

import Foundation
import UIKit

public extension UIFont {
    class func urbaneRounded(size: CGFloat, weight: Font.Weight) -> UIFont {
        UIFont(name: weight.fontSystemName, size: size) ?? UIFont.systemFont(ofSize: size)
    }
}
