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

public extension UIView {
    enum SeparatorPosition {
        case top
        case bottom
        case left
        case right
    }

    @discardableResult
    func addSeparator(at position: SeparatorPosition, color: UIColor, weight: CGFloat = 1.0 / UIScreen.main.scale, insets: UIEdgeInsets = .zero) -> UIView {
        let view = UIView().configure {
            $0.backgroundColor = color
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        addSubview(view)

        switch position {
        case .top:
            view.topAnchor.constraint(equalTo: topAnchor, constant: insets.top).isActive = true
            view.leftAnchor.constraint(equalTo: leftAnchor, constant: insets.left).isActive = true
            view.rightAnchor.constraint(equalTo: rightAnchor, constant: -insets.right).isActive = true
            view.heightAnchor.constraint(equalToConstant: weight).isActive = true

        case .bottom:
            view.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -insets.bottom).isActive = true
            view.leftAnchor.constraint(equalTo: leftAnchor, constant: insets.left).isActive = true
            view.rightAnchor.constraint(equalTo: rightAnchor, constant: -insets.right).isActive = true
            view.heightAnchor.constraint(equalToConstant: weight).isActive = true

        case .left:
            view.topAnchor.constraint(equalTo: topAnchor, constant: insets.top).isActive = true
            view.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -insets.bottom).isActive = true
            view.leftAnchor.constraint(equalTo: leftAnchor, constant: insets.left).isActive = true
            view.widthAnchor.constraint(equalToConstant: weight).isActive = true

        case .right:
            view.topAnchor.constraint(equalTo: topAnchor, constant: insets.top).isActive = true
            view.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -insets.bottom).isActive = true
            view.rightAnchor.constraint(equalTo: rightAnchor, constant: -insets.right).isActive = true
            view.widthAnchor.constraint(equalToConstant: weight).isActive = true
        }
        return view
    }
}
