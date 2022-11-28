//
//  SettingsRouter.swift
//  Plome
//
//  Created by Loic Mazuc on 28/11/2022.
//

import Foundation
import PlomeCoreKit
import UIKit

final class SettingsRouter: DefaultRouter {
    // MARK: - Properties

    let screens: Screens

    // MARK: - Init

    init(screens: Screens, rootTransition: Transition) {
        self.screens = screens
        super.init(rootTransition: rootTransition)
    }

    // MARK: - Methods

    func makeRootViewController() -> UIViewController {
        let router = SettingsRouter(screens: screens, rootTransition: EmptyTransition())
        let settingsViewController = screens.createSettingsTab(router: router)
        router.rootViewController = settingsViewController

        return settingsViewController
    }

    func shareApplication() {
        if let url = URL(string: "itms-apps://apple.com/app/id1468320348") {
            let activity = UIActivityViewController(activityItems: ["Pineapple", url], applicationActivities: nil)
            rootViewController?.present(activity, animated: true)
        } else {
            alert(title: "Oups..", message: "Une erreur est survenu 😕")
        }
    }
}
