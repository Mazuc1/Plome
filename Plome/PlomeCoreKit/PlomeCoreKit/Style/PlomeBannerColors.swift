//
//  PlomeBannerColors.swift
//  PlomeCoreKit
//
//  Created by Loic Mazuc on 01/06/2023.
//

import NotificationBannerSwift
import UIKit

class PlomeBannerColors: BannerColorsProtocol {
    func color(for style: BannerStyle) -> UIColor {
        switch style {
        case .info: return PlomeColor.lagoon.color
        case .customView, .danger, .success, .warning: return .clear
        }
    }
}
