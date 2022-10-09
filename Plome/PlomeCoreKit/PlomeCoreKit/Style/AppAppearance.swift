//
//  AppAppearence.swift
//  Baluchon
//
//  Created by Loic Mazuc on 17/03/2022.
//

import UIKit

public class AppAppearance {
    public static func setAppearance() {
        //  Tab Bar
        let appearance = UITabBarAppearance()
        appearance.configureWithOpaqueBackground()
        UITabBar.appearance().standardAppearance = appearance
        UITabBar.appearance().scrollEdgeAppearance = appearance
    }
}
