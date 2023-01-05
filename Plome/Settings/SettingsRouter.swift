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
            if let url = createEmailUrl(to: L10n.Settings.assistanceMail, subject: L10n.Settings.appName, body: "") {
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

    private func createEmailUrl(to: String, subject: String, body: String) -> URL? {
        let subjectEncoded = subject.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
        let bodyEncoded = body.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!

        let gmailUrl = URL(string: "googlegmail://co?to=\(to)&subject=\(subjectEncoded)&body=\(bodyEncoded)")
        let outlookUrl = URL(string: "ms-outlook://compose?to=\(to)&subject=\(subjectEncoded)")
        let yahooMail = URL(string: "ymail://mail/compose?to=\(to)&subject=\(subjectEncoded)&body=\(bodyEncoded)")
        let sparkUrl = URL(string: "readdle-spark://compose?recipient=\(to)&subject=\(subjectEncoded)&body=\(bodyEncoded)")
        let defaultUrl = URL(string: "mailto:\(to)?subject=\(subjectEncoded)&body=\(bodyEncoded)")

        if let gmailUrl = gmailUrl, UIApplication.shared.canOpenURL(gmailUrl) {
            return gmailUrl
        } else if let outlookUrl, UIApplication.shared.canOpenURL(outlookUrl) {
            return outlookUrl
        } else if let yahooMail, UIApplication.shared.canOpenURL(yahooMail) {
            return yahooMail
        } else if let sparkUrl, UIApplication.shared.canOpenURL(sparkUrl) {
            return sparkUrl
        } else if let defaultUrl, UIApplication.shared.canOpenURL(defaultUrl) {
            return defaultUrl
        }

        return nil
    }
}
