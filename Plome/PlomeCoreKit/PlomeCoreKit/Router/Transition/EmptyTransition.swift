//
//  EmptyTransition.swift
//  RoutingExample
//
//  Created by Cassius Pacheco on 8/3/20.
//  Copyright © 2020 Cassius Pacheco. All rights reserved.
//

import UIKit

public final class EmptyTransition {
    public var isAnimated: Bool = true
    public init() {}
}

extension EmptyTransition: Transition {
    public func open(_: UIViewController, from _: UIViewController, completion _: (() -> Void)?) {}
    public func close(_: UIViewController, completion _: (() -> Void)?) {}
}
