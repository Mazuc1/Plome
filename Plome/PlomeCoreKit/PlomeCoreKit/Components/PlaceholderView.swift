//
//  PlaceholderView.swift
//  Plome
//
//  Created by Loic Mazuc on 30/10/2022.
//

import UIKit

public final class PlaceholderView: UIView {
    // MARK: - Properties

    private let icon: Icons
    private let text: String

    // MARK: - UI

    private let imageView: UIImageView = .init().configure {
        $0.sizeToFit()
    }

    private let textLabel: UILabel = .init().configure {
        $0.font = PlomeFont.bodyM.font
        $0.textColor = PlomeColor.darkGray.color
        $0.textAlignment = .center
        $0.numberOfLines = 0
    }

    private let stackView: UIStackView = .init().configure {
        $0.axis = .vertical
        $0.distribution = .fill
        $0.spacing = AppStyles.defaultSpacing(factor: 2)
        $0.alignment = .center
    }

    // MARK: - Init

    public required init(frame: CGRect, icon: Icons, text: String) {
        self.icon = icon
        self.text = text
        super.init(frame: frame)
        setupView()
    }

    required init?(coder aDecoder: NSCoder) {
        icon = .fail
        text = L10n.unexpected
        super.init(coder: aDecoder)
        setupView()
    }

    // MARK: - Methods

    private func setupView() {
        translatesAutoresizingMaskIntoConstraints = false

        textLabel.text = text
        imageView.image = icon.configure(weight: .regular, color: .lagoon, size: 50)

        stackView.addArrangedSubviews([imageView, textLabel])
        stackView.stretchInView(parentView: self)
    }
}
