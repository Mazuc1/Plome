//
//  SecondaryCTA.swift
//  PlomeCoreKit
//
//  Created by Loic Mazuc on 14/11/2022.
//

import UIKit

public class SecondaryCTA: UIButton {
    public required init(title: String) {
        super.init(frame: .zero)
        setTitle(title, for: .normal)
        titleLabel?.font = PlomeFont.demiBoldL.font
        titleLabel?.numberOfLines = 0
        titleLabel?.textAlignment = .center
        layer.cornerRadius = AppStyles.defaultRadius
        setTitleColor(.init(color: .lagoon), for: .normal)
        backgroundColor = .init(color: .lagoon, alpha: 0.2)
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
