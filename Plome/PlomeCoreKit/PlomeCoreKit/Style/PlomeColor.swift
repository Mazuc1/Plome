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
    case pink
    case lightViolet
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

    // Details progressView
    case trials
    case continuousControl
    case options

    func rgb() -> (CGFloat, CGFloat, CGFloat) {
        switch self {
        case .black: return (0, 0, 0)
        case .darkGray: return (0.43, 0.43, 0.43)

        case .darkBlue: return (0.07, 0.03, 0.35)
        case .pink: return (0.95, 0.34, 0.48)
        case .lightViolet: return (0.47, 0.40, 0.97)

        case .background: return (0.94, 0.95, 0.99)

        case .withoutMention: return (0.43, 0.43, 0.43)
        case .quiteWellMention: return (0.88, 0.79, 0.11)
        case .greatMention: return (0.019, 0.68, 0.76)
        case .veryGreatMention: return (0.04, 0.31, 0.67)

        case .success: return (0.19, 0.67, 0.04)
        case .fail: return (0.99, 0.117, 0.121)

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
        case .pink: return UIColor(color: .pink)
        case .lightViolet: return UIColor(color: .lightViolet)

        case .background: return UIColor(color: .background)

        case .withoutMention: return UIColor(color: .withoutMention)
        case .quiteWellMention: return UIColor(color: .quiteWellMention)
        case .greatMention: return UIColor(color: .greatMention)
        case .veryGreatMention: return UIColor(color: .veryGreatMention)

        case .success: return UIColor(color: .success)
        case .fail: return UIColor(color: .fail)

        case .trials: return UIColor(color: .trials)
        case .continuousControl: return UIColor(color: .continuousControl)
        case .options: return UIColor(color: .options)
        }
    }

    public static var confettiColors: [UIColor] {
        [
            .init(red: 34 / 255, green: 92 / 255, blue: 110 / 255, alpha: 1),
            .init(red: 0 / 255, green: 136 / 255, blue: 121 / 255, alpha: 1),
            .init(red: 235 / 255, green: 179 / 255, blue: 102 / 255, alpha: 1),
            .init(red: 255 / 255, green: 139 / 255, blue: 90 / 255, alpha: 1),
            .init(red: 242 / 255, green: 121 / 255, blue: 109 / 255, alpha: 1),
        ]
    }
}
