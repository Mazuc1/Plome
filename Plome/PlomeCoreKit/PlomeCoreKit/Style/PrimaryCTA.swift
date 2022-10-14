//
//  PrimaryCTA.swift
//  PlomeCoreKit
//
//  Created by Loic Mazuc on 14/10/2022.
//

import UIKit

public class PrimaryCTA: UIButton {
    required init(title: String) {
        super.init(frame: .zero)
        setTitle(title, for: .normal)
        setTitleColor(.init(color: .lightViolet), for: .normal)
        backgroundColor = .init(color: .lightViolet, alpha: 0.2)
        layer.cornerRadius = AppStyles.defaultRadius
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
