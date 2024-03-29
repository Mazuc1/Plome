//
//  PlomeFont.swift
//  PlomeCoreKit
//
//  Created by Loic Mazuc on 08/07/2022.
//

import UIKit

public enum PlomeFont {
    case buttonDemiBold
    case title
    case subtitle

    case bodyL
    case bodyM
    case bodyS

    case demiBoldL
    case demiBoldM
    case demiBoldS

    case custom(size: CGFloat, weight: Font.Weight)

    public var font: UIFont {
        switch self {
        case .buttonDemiBold: return UIFont.urbaneRounded(size: 20, weight: .demiBold)
        case .title: return UIFont.urbaneRounded(size: 25, weight: .bold)
        case .subtitle: return UIFont.urbaneRounded(size: 20, weight: .bold)
        case .bodyL: return UIFont.urbaneRounded(size: 16, weight: .medium)
        case .bodyM: return UIFont.urbaneRounded(size: 14, weight: .medium)
        case .bodyS: return UIFont.urbaneRounded(size: 12, weight: .medium)
        case .demiBoldL: return UIFont.urbaneRounded(size: 18, weight: .demiBold)
        case .demiBoldM: return UIFont.urbaneRounded(size: 16, weight: .demiBold)
        case .demiBoldS: return UIFont.urbaneRounded(size: 14, weight: .demiBold)
        case let .custom(size: size, weight: weight): return UIFont.urbaneRounded(size: size, weight: weight)
        }
    }
}

public enum Font {
    public enum Weight {
        case bold, demiBold, medium, light

        var fontSystemName: String {
            switch self {
            case .bold: return "UrbaneRounded-Bold"
            case .demiBold: return "UrbaneRounded-DemiBold"
            case .medium: return "UrbaneRounded-Medium"
            case .light: return "UrbaneRounded-Light"
            }
        }
    }
}
