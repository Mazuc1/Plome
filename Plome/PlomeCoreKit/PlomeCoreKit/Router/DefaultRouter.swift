//
//  DefaultRouter.swift
//  RoutingExample
//
//  Created by Cassius Pacheco on 8/3/20.
//  Copyright © 2020 Cassius Pacheco. All rights reserved.
//

import NotificationBannerSwift
import UIKit

open class DefaultRouter: NSObject, Router, Closable, Dismissable, Alertable {
    private let rootTransition: Transition
    public weak var rootViewController: UIViewController?

    public init(rootTransition: Transition) {
        self.rootTransition = rootTransition
    }

    deinit {
        print("Router \(self.description) deinit")
    }

    // MARK: - Routable

    public func route(to viewController: UIViewController, as transition: Transition, completion: (() -> Void)?) {
        guard let root = rootViewController else { return }
        transition.open(viewController, from: root, completion: completion)
    }

    public func route(to viewController: UIViewController, as transition: Transition) {
        route(to: viewController, as: transition, completion: nil)
    }

    // MARK: - Closable

    public func close(completion: (() -> Void)?) {
        guard let root = rootViewController else { return }
        rootTransition.close(root, completion: completion)
    }

    public func close() {
        close(completion: nil)
    }

    // MARK: - Dismissable

    public func dismiss(completion: (() -> Void)?) {
        rootViewController?.dismiss(animated: rootTransition.isAnimated, completion: completion)
    }

    public func dismiss() {
        dismiss(completion: nil)
    }

    // MARK: - Alertable

    public func errorAlert() {
        alert(title: L10n.General.oups, message: L10n.General.commonErrorMessage)
    }

    public func alert(title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: L10n.General.ok, style: .cancel))
        alertController.view.tintColor = PlomeColor.lagoon.color
        rootViewController?.present(alertController, animated: true)
    }

    public func alertWithAction(title: String, message: String, isPrimaryDestructive: Bool = false, completion: @escaping () -> Void) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)

        let primaryActionStyle: UIAlertAction.Style = isPrimaryDestructive ? .destructive : .default

        alertController.addAction(UIAlertAction(title: L10n.General.no, style: .cancel))
        alertController.addAction(UIAlertAction(title: L10n.General.yes, style: primaryActionStyle, handler: { _ in
            completion()
        }))
        alertController.view.tintColor = PlomeColor.lagoon.color
        rootViewController?.present(alertController, animated: true)
    }

    public func alertWithTextField(title: String, message: String, buttonActionName: String, returnedValue: @escaping (String) -> Void) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)

        alertController.addTextField { $0.placeholder = L10n.writeHere }
        alertController.addAction(UIAlertAction(title: L10n.General.cancel, style: .cancel))
        alertController.addAction(UIAlertAction(title: buttonActionName, style: .default, handler: { _ in
            guard let value = alertController.textFields?[0].text,
                  !value.isEmpty else { return }
            returnedValue(value)
        }))

        alertController.view.tintColor = PlomeColor.lagoon.color
        rootViewController?.present(alertController, animated: true)
    }

    // MARK: - Activity controller

    public func openActivityController(with items: [Any]) {
        let activityController = UIActivityViewController(activityItems: items, applicationActivities: nil)
        rootViewController?.present(activityController, animated: true)
    }

    // MARK: - Banner

    public func showStatusBanner(title: String,
                                 style: BannerStyle)
    {
        let banner = StatusBarNotificationBanner(title: title,
                                                 style: style,
                                                 colors: PlomeBannerColors())
        banner.show()
    }
}
