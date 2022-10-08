//
//  ModalTransition.swift
//  RoutingExample
//
//  Created by Cassius Pacheco on 5/3/20.
//  Copyright © 2020 Cassius Pacheco. All rights reserved.
//

import UIKit

public final class ModalTransition: NSObject {
    public var isAnimated: Bool = true

    var modalTransitionStyle: UIModalTransitionStyle
    var modalPresentationStyle: UIModalPresentationStyle
    var modalDetents: [UISheetPresentationController.Detent]

    public init(isAnimated: Bool = true,
                modalTransitionStyle: UIModalTransitionStyle = .coverVertical,
                modalPresentationStyle: UIModalPresentationStyle = .automatic,
                modalDetents: [UISheetPresentationController.Detent] = [.large()])
    {
        self.isAnimated = isAnimated
        self.modalTransitionStyle = modalTransitionStyle
        self.modalPresentationStyle = modalPresentationStyle
        self.modalDetents = modalDetents
    }
}

extension ModalTransition: Transition {
    public func open(_ viewController: UIViewController, from: UIViewController, completion: (() -> Void)?) {
        viewController.modalPresentationStyle = modalPresentationStyle
        viewController.modalTransitionStyle = modalTransitionStyle
        viewController.sheetPresentationController?.detents = modalDetents
        from.present(viewController, animated: isAnimated, completion: completion)
    }

    public func close(_ viewController: UIViewController, completion: (() -> Void)?) {
        viewController.dismiss(animated: isAnimated, completion: completion)
    }
}
