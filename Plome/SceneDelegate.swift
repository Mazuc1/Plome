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
    private var context: ContextProtocol!
    private var appRouter: AppRouter!

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        window = UIWindow(frame: windowScene.coordinateSpace.bounds)
        window?.windowScene = windowScene

        /// UI of application
        AppAppearance.setAppearance()

        /// Creation of Context, Screens and AppRouter
        context = Context()
        let screens = Screens(context: context)
        appRouter = AppRouter(window: window!, context: context, screens: screens)

        /// Starts app flow
        appRouter.start()
    }

    func sceneDidDisconnect(_ scene: UIScene) {}
    func sceneDidBecomeActive(_ scene: UIScene) {}
    func sceneWillResignActive(_ scene: UIScene) {}
    func sceneWillEnterForeground(_ scene: UIScene) {}
    func sceneDidEnterBackground(_ scene: UIScene) {}
}
