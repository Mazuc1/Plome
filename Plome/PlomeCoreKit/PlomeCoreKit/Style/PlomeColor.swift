//
//  PlomeColor.swift
//  PlomeCoreKit
//
//  Created by Loic Mazuc on 08/10/2022.
//

import Foundation
import UIKit

public enum PlomeColor {
    // Text
    case black
    case darkGray

    // Main
    case lagoon
    case lightGreen
    case darkBlue

    // Background
    case background

    // Mention
    case withoutMention
    case quiteWellMention
    case greatMention
    case veryGreatMention

    // Result
    case success
    case fail
    case warning

    // Details progressView
    case trials
    case continuousControl
    case options

    func rgb() -> (CGFloat, CGFloat, CGFloat) {
        switch self {
        case .black: return (0, 0, 0)
        case .darkGray: return (0.43, 0.43, 0.43)

        case .darkBlue: return (0.07, 0.03, 0.35)
        case .lagoon: return (0.05, 0.79, 0.69)
        case .lightGreen: return (0.14, 0.78, 0.25)

        case .background: return (0.94, 0.95, 0.99)

        case .withoutMention: return (0.43, 0.43, 0.43)
        case .quiteWellMention: return (0.88, 0.79, 0.11)
        case .greatMention: return (0.019, 0.68, 0.76)
        case .veryGreatMention: return (0.04, 0.31, 0.67)

        case .success: return (0.19, 0.67, 0.04)
        case .fail: return (0.99, 0.117, 0.121)
        case .warning: return (0.81, 0.74, 0.17)

        case .trials: return (1, 0.54, 0.35)
        case .continuousControl: return (0, 0.53, 0.47)
        case .options: return (0.92, 0.70, 0.4)
        }
    }

    public var color: UIColor {
        switch self {
        case .black: return UIColor(color: .black)
        case .darkGray: return UIColor(color: .darkGray)

        case .darkBlue: return UIColor(color: .darkBlue)
        case .lagoon: return UIColor(color: .lagoon)
        case .lightGreen: return UIColor(color: .lightGreen)

        case .background: return UIColor(color: .background)

        case .withoutMention: return UIColor(color: .withoutMention)
        case .quiteWellMention: return UIColor(color: .quiteWellMention)
        case .greatMention: return UIColor(color: .greatMention)
        case .veryGreatMention: return UIColor(color: .veryGreatMention)

        case .success: return UIColor(color: .success)
        case .fail: return UIColor(color: .fail)
        case .warning: return UIColor(color: .warning)

        case .trials: return UIColor(color: .trials)
        case .continuousControl: return UIColor(color: .continuousControl)
        case .options: return UIColor(color: .options)
        }
    }
}
