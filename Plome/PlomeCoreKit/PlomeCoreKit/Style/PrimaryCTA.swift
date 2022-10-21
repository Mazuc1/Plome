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
        let imageWeightConfiguration = UIImage.SymbolConfiguration(weight: .bold)
        let imageColorConfiguration = UIImage.SymbolConfiguration(paletteColors: [PlomeColor.pink.color])
        let imageSizeConfiguration = UIImage.SymbolConfiguration(pointSize: 25)
        
        let imageWeightAndColorConfiguration = imageWeightConfiguration.applying(imageColorConfiguration)
        let imageFinalConfiguration = imageWeightAndColorConfiguration.applying(imageSizeConfiguration)
        
        setImage(UIImage(systemName: icon.name, withConfiguration: imageFinalConfiguration), for: .normal)
        backgroundColor = .init(color: .pink, alpha: 0.2)
        layer.cornerRadius = AppStyles.defaultRadius
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
