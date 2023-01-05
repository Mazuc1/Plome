//
//  PineappleCell.swift
//  Plome
//
//  Created by Loic Mazuc on 05/01/2023.
//

import PlomeCoreKit
import UIKit

final class PineappleCell: UITableViewCell {
    // MARK: - Properties

    static let reuseIdentifier: String = "PineappleCell"

    // MARK: - UI

    private var labelTitle: UILabel = .init().configure {
        $0.text = L10n.Settings.needOrganization
        $0.font = PlomeFont.demiBoldM.font
        $0.textAlignment = .left
        $0.textColor = PlomeColor.darkBlue.color
    }

    private var labelCaption: UILabel = .init().configure {
        $0.text = L10n.Settings.pineappleCaption
        $0.font = PlomeFont.bodyS.font
        $0.textAlignment = .left
        $0.numberOfLines = 0
        $0.textColor = PlomeColor.darkGray.color
    }

    private var imagePineapple: UIImageView = .init().configure {
        $0.image = Asset.pineapple.image.imageResize(sizeChange: .init(width: 80, height: 80))
    }

    private var stackView: UIStackView = .init().configure {
        $0.axis = .horizontal
        $0.alignment = .center
        $0.distribution = .equalSpacing
        $0.spacing = AppStyles.defaultSpacing(factor: 0.5)
        $0.backgroundColor = .white
        $0.layer.cornerRadius = AppStyles.defaultRadius
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.isLayoutMarginsRelativeArrangement = true
        $0.layoutMargins = .init(top: AppStyles.defaultSpacing,
                                 left: AppStyles.defaultSpacing(factor: 2),
                                 bottom: AppStyles.defaultSpacing,
                                 right: AppStyles.defaultSpacing)
    }

    // MARK: - Init

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setup()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }

    // MARK: - Methods

    private func setup() {
        setupLayout()
        backgroundColor = .clear
        selectionStyle = .none
    }

    private func setupLayout() {
        contentView.addSubview(stackView)
        let stackViewText = UIStackView().configure {
            $0.axis = .vertical
            $0.alignment = .leading
            $0.distribution = .equalSpacing
            $0.spacing = AppStyles.defaultSpacing
            $0.addArrangedSubviews([labelTitle, labelCaption])
        }

        stackView.addArrangedSubviews([stackViewText, imagePineapple])

        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: contentView.topAnchor),
            stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            contentView.bottomAnchor.constraint(equalTo: stackView.bottomAnchor, constant: AppStyles.defaultSpacing),
            stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
        ])
    }
}
