//
//  Icons.swift
//  PineappleCoreKit
//
//  Created by Loic Mazuc on 08/07/2022.
//

import Foundation
import UIKit

public enum Icons {
    case add
    
    public var uiImage: UIImage {
        UIImage(systemName: name)!
    }

    public var name: String {
        switch self {
        case .add: return "plus"
        }
    }
}
