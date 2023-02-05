//
//  SceneDelegate.swift
//  Plome
//
//  Created by Loic Mazuc on 04/10/2022.
//

import PlomeCoreKit
import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?
    private var appRouter: AppRouter!

    func scene(_ scene: UIScene, willConnectTo _: UISceneSession, options _: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        window = UIWindow(frame: windowScene.coordinateSpace.bounds)
        window?.windowScene = windowScene

        /// UI of application
        AppAppearance.setAppearance()

        /// Creation of Context, Screens and AppRouter
        let screens = Screens()
        appRouter = AppRouter(window: window!, screens: screens)

        /// Starts app flow
        appRouter.start()
    }

    func sceneDidDisconnect(_: UIScene) {}
    func sceneDidBecomeActive(_: UIScene) {}
    func sceneWillResignActive(_: UIScene) {}
    func sceneWillEnterForeground(_: UIScene) {}
    func sceneDidEnterBackground(_: UIScene) {}
}
