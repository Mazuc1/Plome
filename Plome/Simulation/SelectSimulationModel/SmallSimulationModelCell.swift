//
//  SmallSimulationModelCell.swift
//  Plome
//
//  Created by Loic Mazuc on 31/10/2022.
//

import PlomeCoreKit
import UIKit

final class SmallSimulationModelCell: UITableViewCell {
    // MARK: - Properties

    static let reuseIdentifier: String = "SmallSimulationModelCell"

    // MARK: - UI

    private var labelSimulationName: UILabel = .init().configure {
        $0.font = PlomeFont.bodyL.font
        $0.textAlignment = .left
        $0.textColor = PlomeColor.darkBlue.color
    }

    private var stackView: UIStackView = .init().configure {
        $0.axis = .vertical
        $0.alignment = .leading
        $0.distribution = .equalSpacing
        $0.spacing = AppStyles.defaultSpacing(factor: 0.5)
        $0.backgroundColor = .white
        $0.layer.cornerRadius = AppStyles.defaultRadius
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.isLayoutMarginsRelativeArrangement = true
    }

    // MARK: - Init

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    // MARK: - Methods

    func setup(with simulation: Simulation) {
        setupLayout()

        labelSimulationName.text = simulation.name

        backgroundColor = .clear
        selectionStyle = .none
    }

    private func setupLayout() {
        contentView.addSubview(stackView)
        stackView.addArrangedSubviews([labelSimulationName])

        NSLayoutConstraint.activate([
            stackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            stackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: AppStyles.defaultSpacing),
            stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            stackView.heightAnchor.constraint(equalToConstant: AppStyles.defaultCellHeight),
        ])

        stackView.layoutMargins = .init(top: AppStyles.defaultSpacing,
                                        left: AppStyles.defaultSpacing,
                                        bottom: AppStyles.defaultSpacing,
                                        right: AppStyles.defaultSpacing)
    }
}
