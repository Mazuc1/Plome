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

    func shareApplication() {
        if let url = URL(string: "itms-apps://apple.com/app/id1468320348") {
            let activity = UIActivityViewController(activityItems: ["Pineapple", url], applicationActivities: nil)
            rootViewController?.present(activity, animated: true)
        } else {
            alert(title: "Oups..", message: "Une erreur est survenu 😕")
        }
    }

    func openMailApp() {
        if MFMailComposeViewController.canSendMail() {
            launchMailApp()
        } else {
            if let url = createEmailUrl(to: "mazuc.loic@icloud.com", subject: "Plôme", body: "") {
                UIApplication.shared.open(url)
            } else {
                alert(title: "Attention", message: "Une erreur est survenue.")
            }
        }
    }
}

extension SettingsRouter: MFMailComposeViewControllerDelegate {
    private func launchMailApp() {
        let emailTitle = "Plôme"
        let messageBody = ""
        let toRecipents = ["mazuc.loic@icloud.com"]
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
        } else if let outlookUrl = outlookUrl, UIApplication.shared.canOpenURL(outlookUrl) {
            return outlookUrl
        } else if let yahooMail = yahooMail, UIApplication.shared.canOpenURL(yahooMail) {
            return yahooMail
        } else if let sparkUrl = sparkUrl, UIApplication.shared.canOpenURL(sparkUrl) {
            return sparkUrl
        }

        return defaultUrl
    }
}
