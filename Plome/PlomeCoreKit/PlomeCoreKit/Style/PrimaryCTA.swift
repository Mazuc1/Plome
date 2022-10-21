//
//  PrimaryCTA.swift
//  PlomeCoreKit
//
//  Created by Loic Mazuc on 14/10/2022.
//

import UIKit

public class PrimaryCTA: UIButton {
    public required init(title: String) {
        super.init(frame: .zero)
        setTitle(title, for: .normal)
        setTitleColor(.init(color: .lightViolet), for: .normal)
        titleLabel?.font = PlomeFont.demiBoldL.font
        backgroundColor = .init(color: .lightViolet, alpha: 0.2)
        layer.cornerRadius = AppStyles.defaultRadius
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

public class SecondaryIconCTA: UIButton {
    public required init(icon: Icons) {
        super.init(frame: .zero)
        setTitleColor(.init(color: .pink), for: .normal)
        setImage(icon.uiImage, for: .normal)
        backgroundColor = .init(color: .pink, alpha: 0.2)
        layer.cornerRadius = AppStyles.defaultRadius
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
