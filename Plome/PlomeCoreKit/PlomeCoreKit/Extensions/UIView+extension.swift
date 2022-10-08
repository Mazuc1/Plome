//
//  UIView.swift
//  EvaneosCoreKit
//
//  Created by Mazuc on 01/15/2022.
//  Copyright © 2021 BoubloCorp. All rights reserved.
//

import Foundation
import UIKit

public extension UIView {
    func stretchInView(parentView: UIView, edges: UIEdgeInsets = UIEdgeInsets.zero, size: CGSize? = nil, relativeToMargins: Bool = false) {
        translatesAutoresizingMaskIntoConstraints = false
        parentView.addSubview(self)

        var attrs = [
            NSLayoutConstraint.Attribute.top: (attr: NSLayoutConstraint.Attribute.top, const: edges.top),
            NSLayoutConstraint.Attribute.right: (attr: NSLayoutConstraint.Attribute.right, const: edges.right * -1),
            NSLayoutConstraint.Attribute.bottom: (attr: NSLayoutConstraint.Attribute.bottom, const: edges.bottom * -1),
            NSLayoutConstraint.Attribute.left: (attr: NSLayoutConstraint.Attribute.left, const: edges.left),
        ]

        if relativeToMargins {
            attrs = [
                NSLayoutConstraint.Attribute.top: (attr: NSLayoutConstraint.Attribute.topMargin, const: edges.top),
                NSLayoutConstraint.Attribute.right: (attr: NSLayoutConstraint.Attribute.rightMargin, const: edges.right * -1),
                NSLayoutConstraint.Attribute.bottom: (attr: NSLayoutConstraint.Attribute.bottomMargin, const: edges.bottom * -1),
                NSLayoutConstraint.Attribute.left: (attr: NSLayoutConstraint.Attribute.leftMargin, const: edges.left),
            ]
        }

        for (fromAttr, to) in attrs {
            parentView.addConstraint(NSLayoutConstraint(item: self, attribute: fromAttr, relatedBy: NSLayoutConstraint.Relation.equal, toItem: parentView, attribute: to.attr, multiplier: 1, constant: to.const))
        }

        if let size = size {
            parentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:[view(\(size.width))]", options: .alignAllCenterY, metrics: nil, views: ["view": self]))
            parentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:[view(\(size.height))]", options: .alignAllCenterX, metrics: nil, views: ["view": self]))
        }

        setNeedsLayout()
    }
}
