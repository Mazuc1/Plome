//
//  MainTabBarController.swift
//  RoutingExample
//
//  Created by Cassius Pacheco on 7/3/20.
//  Copyright © 2020 Cassius Pacheco. All rights reserved.
//

import PlomeCoreKit
import UIKit

enum Tabs {
    case home, model, settings

    var item: UITabBarItem {
        switch self {
        case .home: return UITabBarItem(title: "Accueil", image: .init(systemName: Icons.home.name), tag: 0)
        case .model: return UITabBarItem(title: "Modèles", image: .init(systemName: Icons.model.name), tag: 1)
        case .settings: return UITabBarItem(title: "Réglages", image: .init(systemName: Icons.settings.name), tag: 2)
        }
    }
}

final class MainTabBarController: UITabBarController {
    override func viewDidLoad() {
        super.viewDidLoad()
        tabBar.tintColor = .init(color: .pink)
        tabBar.unselectedItemTintColor = .gray
    }
}
