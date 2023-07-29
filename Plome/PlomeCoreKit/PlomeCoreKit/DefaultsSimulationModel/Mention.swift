//
//  Mention.swift
//  PlomeCoreKit
//
//  Created by Loic Mazuc on 29/07/2023.
//

import Foundation

public enum Mention {
    case cannotBeCalculated
    case without
    case AB
    case B
    case TB

    public var name: String {
        switch self {
        case .cannotBeCalculated: return "Ne peux être calculée"
        case .without: return L10n.withoutMention
        case .AB: return L10n.quiteWellMention
        case .B: return L10n.greatMention
        case .TB: return L10n.veryGreatMention
        }
    }

    public var plomeColor: PlomeColor {
        switch self {
        case .cannotBeCalculated: return PlomeColor.withoutMention
        case .without: return PlomeColor.withoutMention
        case .AB: return PlomeColor.quiteWellMention
        case .B: return PlomeColor.greatMention
        case .TB: return PlomeColor.veryGreatMention
        }
    }
}
