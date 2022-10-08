//
//  UIColor+extension.swift
//  PlomeCoreKit
//
//  Created by Loic Mazuc on 08/10/2022.
//

import Foundation
import UIKit

public extension UIColor {
    convenience init(color: PlomeColor, alpha: CGFloat = 1) {
        let rgb = color.rgb()
        self.init(red: rgb.0, green: rgb.1, blue: rgb.2, alpha: alpha)
    }

    class func semiTransparent(color: PlomeColor) -> UIColor {
        let rgb = color.rgb()
        return .init(red: rgb.0, green: rgb.1, blue: rgb.2, alpha: 0.5)
    }

    class func transparent(color: PlomeColor, alpha: CGFloat) -> UIColor {
        let rgb = color.rgb()
        return .init(red: rgb.0, green: rgb.1, blue: rgb.2, alpha: alpha)
    }
}
