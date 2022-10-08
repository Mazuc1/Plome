//
//  PlomeColor.swift
//  PlomeCoreKit
//
//  Created by Loic Mazuc on 08/10/2022.
//

import Foundation

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
        }
    }
}
