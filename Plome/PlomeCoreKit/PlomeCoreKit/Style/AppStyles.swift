//
//  AppStyles.swift
//
//  Created by Loic Mazuc on -/-/----.
//

import UIKit

public enum AppStyles {
    public static let defaultSpacing: CGFloat = 8
    public static let defaultRadius: CGFloat = 8

    public static func defaultSpacing(factor: CGFloat) -> CGFloat {
        return defaultSpacing * factor
    }

    public static let primaryCTAHeight: CGFloat = 54
    public static let secondaryCTAHeight: CGFloat = 50
    public static let tertiaryCTAHeight: CGFloat = 35

    public static let defaultCellHeight: CGFloat = 44
}
