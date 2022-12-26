//
//  Icons.swift
//  PineappleCoreKit
//
//  Created by Loic Mazuc on 08/07/2022.
//

import Foundation
import UIKit

public enum Icons {
    // TabBar
    case home
    case model
    case settings

    // Home
    case list
    case arrowUp
    case arrowDown
    case medal

    // Simulation
    case success
    case fail
    case warning

    // Main
    case trash
    case add
    case xmark
    case pencil
    case info
    case share
    case envelope
    case addRectangleStack

    public var uiImage: UIImage {
        UIImage(systemName: name)!
    }

    public var name: String {
        switch self {
        case .home: return "house"
        case .model: return "cube.transparent"
        case .settings: return "gearshape"

        case .list: return "list.bullet.clipboard"
        case .arrowUp: return "arrow.up.circle.fill"
        case .arrowDown: return "arrow.down.circle.fill"
        case .medal: return "medal.fill"

        case .success: return "checkmark.circle.fill"
        case .fail: return "xmark.circle.fill"
        case .warning: return "exclamationmark.triangle.fill"

        case .trash: return "trash"
        case .add: return "plus.circle"
        case .xmark: return "xmark"
        case .pencil: return "pencil.circle"
        case .info: return "info.circle"
        case .share: return "square.and.arrow.up"
        case .envelope: return "envelope"
        case .addRectangleStack: return "rectangle.stack.badge.plus"
        }
    }

    public func configure(weight: UIImage.SymbolWeight, color: PlomeColor, size: CGFloat) -> UIImage {
        let imageWeightConfiguration = UIImage.SymbolConfiguration(weight: weight)
        let imageColorConfiguration = UIImage.SymbolConfiguration(paletteColors: [color.color])
        let imageSizeConfiguration = UIImage.SymbolConfiguration(pointSize: size)

        let imageWeightAndColorConfiguration = imageWeightConfiguration.applying(imageColorConfiguration)
        let imageFinalConfiguration = imageWeightAndColorConfiguration.applying(imageSizeConfiguration)

        return UIImage(systemName: name, withConfiguration: imageFinalConfiguration) ?? UIImage()
    }
}
