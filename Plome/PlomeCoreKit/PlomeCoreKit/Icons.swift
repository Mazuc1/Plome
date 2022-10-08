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
            
        case .success: return "checkmark"
        case .fail: return "xmark"
        case .warning: return "exclamationmark.triangle.fill"
            
        case .trash: return "trash.circle"
        case .add: return "plus.rectangle"
        }
    }
}
