//
//  AppDelegate.swift
//  Plome
//
//  Created by Loic Mazuc on 04/10/2022.
//

import Firebase
import PlomeCoreKit
import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    func application(_: UIApplication, didFinishLaunchingWithOptions _: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        //FirebaseApp.configure()
        AppAppearance.setKeyboardAppearance()
        //Analytics.setAnalyticsCollectionEnabled(true)

        return true
    }

    func application(_: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options _: UIScene.ConnectionOptions) -> UISceneConfiguration {
        UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_: UIApplication, didDiscardSceneSessions _: Set<UISceneSession>) {}
}
