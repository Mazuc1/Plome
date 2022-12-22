//
//  AppAppearence.swift
//  Baluchon
//
//  Created by Loic Mazuc on 17/03/2022.
//

import IQKeyboardManagerSwift
import UIKit

public enum AppAppearance {
    public static func setAppearance() {
        //  Tab Bar
        let tabBarAppearance = UITabBarAppearance()
        tabBarAppearance.configureWithOpaqueBackground()
        UITabBar.appearance().standardAppearance = tabBarAppearance
        UITabBar.appearance().scrollEdgeAppearance = tabBarAppearance

        //  Navigation Bar
        let navigationBarAppearance = UINavigationBarAppearance()
        navigationBarAppearance.configureWithOpaqueBackground()
        navigationBarAppearance.titleTextAttributes = [.font: PlomeFont.demiBoldM.font, .foregroundColor: PlomeColor.darkBlue.color]
        navigationBarAppearance.largeTitleTextAttributes = [.font: PlomeFont.title.font, .foregroundColor: PlomeColor.darkBlue.color]

        UINavigationBar.appearance().standardAppearance = navigationBarAppearance
        UINavigationBar.appearance().scrollEdgeAppearance = navigationBarAppearance
        UINavigationBar.appearance().tintColor = PlomeColor.pink.color

        UITableView.appearance().sectionHeaderTopPadding = 0

        //  Page Control
        let appearance = UIPageControl.appearance(whenContainedInInstancesOf: [UIPageViewController.self])
        appearance.pageIndicatorTintColor = PlomeColor.darkBlue.color.withAlphaComponent(0.4)
        appearance.currentPageIndicatorTintColor = PlomeColor.darkBlue.color
    }

    public static func setKeyboardAppearance() {
        IQKeyboardManager.shared.enable = true
        IQKeyboardManager.shared.shouldShowToolbarPlaceholder = false
        IQKeyboardManager.shared.toolbarTintColor = PlomeColor.pink.color
        IQKeyboardManager.shared.toolbarDoneBarButtonItemText = L10n.General.done
        IQKeyboardManager.shared.previousNextDisplayMode = .default
        IQKeyboardManager.shared.toolbarNextBarButtonItemImage = Icons.arrowDown.configure(weight: .regular, color: .pink, size: 20)
        IQKeyboardManager.shared.toolbarPreviousBarButtonItemImage = Icons.arrowUp.configure(weight: .regular, color: .pink, size: 20)
    }
}
