//
//  UIStackView+extension.swift
//  PlomeCoreKit
//
//  Created by Loic Mazuc on 21/10/2022.
//

import UIKit

public extension UIStackView {
    func addArrangedSubviews(_ views: [UIView]) {
        for view in views {
            addArrangedSubview(view)
        }
    }
}
