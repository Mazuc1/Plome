//
//  PrimaryCTA.swift
//  PlomeCoreKit
//
//  Created by Loic Mazuc on 14/10/2022.
//

import UIKit

public class PrimaryCTA: UIButton {
    private enum State {
        case disabled
        case enabled
    }

    override public var isEnabled: Bool {
        get {
            return super.isEnabled
        } set {
            super.isEnabled = newValue
            setStyle(for: newValue ? .enabled : .disabled)
        }
    }

    public required init(title: String) {
        super.init(frame: .zero)
        setTitle(title, for: .normal)
        titleLabel?.font = PlomeFont.demiBoldL.font
        layer.cornerRadius = AppStyles.defaultRadius

        setStyle(for: .enabled)
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setStyle(for state: State) {
        switch state {
        case .disabled:
            setTitleColor(.init(color: .darkGray), for: .normal)
            backgroundColor = .init(color: .darkGray, alpha: 0.2)
        case .enabled:
            setTitleColor(.init(color: .lightViolet), for: .normal)
            backgroundColor = .init(color: .lightViolet, alpha: 0.2)
        }
    }
}
