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
        let tabBarAppearance = UITabBarAppearance()
        tabBarAppearance.configureWithOpaqueBackground()
        UITabBar.appearance().standardAppearance = tabBarAppearance
        UITabBar.appearance().scrollEdgeAppearance = tabBarAppearance
        
        //  Navigation Bar
        let navigationBarAppearance = UINavigationBarAppearance()
        navigationBarAppearance.configureWithOpaqueBackground()
        navigationBarAppearance.titleTextAttributes = [.font: PlomeFont.subtitle.font, .foregroundColor: UIColor.black]
        navigationBarAppearance.largeTitleTextAttributes = [.font: PlomeFont.title.font, .foregroundColor: UIColor.black]
        
        UINavigationBar.appearance().standardAppearance = navigationBarAppearance
        UINavigationBar.appearance().scrollEdgeAppearance = navigationBarAppearance
        UINavigationBar.appearance().tintColor = PlomeColor.pink.color        
    }
}
