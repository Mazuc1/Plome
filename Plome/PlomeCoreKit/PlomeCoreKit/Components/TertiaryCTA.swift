//
//  TertiaryCTA.swift
//  PlomeCoreKit
//
//  Created by Loic Mazuc on 20/11/2022.
//

import UIKit

public class TertiaryCTA: UIButton {
    public required init(title: String) {
        super.init(frame: .zero)
        setTitle(title, for: .normal)
        titleLabel?.font = PlomeFont.demiBoldM.font
        setTitleColor(.init(color: .darkBlue), for: .normal)
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
