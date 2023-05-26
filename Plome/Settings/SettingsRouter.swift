//
//  SettingsRouter.swift
//  Plome
//
//  Created by Loic Mazuc on 28/11/2022.
//

import Foundation
import MessageUI
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

    func openMailApp() {
        if MFMailComposeViewController.canSendMail() {
            launchMailApp()
        } else {
            if let url = URL(string: "mailto:\(L10n.Settings.assistanceMail)"),
               UIApplication.shared.canOpenURL(url)
            {
                UIApplication.shared.open(url)
            } else {
                alert(title: PlomeCoreKit.L10n.General.oups, message: L10n.Settings.errorLaunchMailApp)
            }
        }
    }

    func openPineappleURL() {
        if let url = URL(string: "https://apps.apple.com/fr/app/pineapple/id1468320348"),
           UIApplication.shared.canOpenURL(url)
        {
            UIApplication.shared.open(url)
        } else {
            alert(title: PlomeCoreKit.L10n.General.oups, message: L10n.Settings.cantOpenLink)
        }
    }
}

extension SettingsRouter: MFMailComposeViewControllerDelegate {
    private func launchMailApp() {
        let emailTitle = L10n.Settings.appName
        let messageBody = ""
        let toRecipents = [L10n.Settings.assistanceMail]
        let mc = MFMailComposeViewController()

        mc.mailComposeDelegate = self
        mc.setSubject(emailTitle)
        mc.setMessageBody(messageBody, isHTML: false)
        mc.setToRecipients(toRecipents)
        rootViewController?.present(mc, animated: true)
    }

    func mailComposeController(_: MFMailComposeViewController, didFinishWith _: MFMailComposeResult, error _: Error?) {
        rootViewController?.dismiss(animated: true, completion: nil)
    }
}
