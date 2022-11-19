//
//  SimulationCell.swift
//  Plome
//
//  Created by Loic Mazuc on 19/11/2022.
//

import PlomeCoreKit
import UIKit

final class SimulationCell: UITableViewCell {
    // MARK: - Properties

    static let reuseIdentifier: String = "SimulationCell"

    // MARK: - UI

    private var labelSimulationName: UILabel = .init().configure {
        $0.font = PlomeFont.demiBoldM.font
        $0.numberOfLines = 1
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

    func setup(with viewModel: SimulationCellViewModel) {
        setupLayout()

        labelSimulationName.text = viewModel.simulation.name

        backgroundColor = .clear
        selectionStyle = .none
    }

    private func setupLayout() {
        contentView.addSubview(stackView)
        stackView.addArrangedSubviews([labelSimulationName])

        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 0),
            stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 0),
            contentView.bottomAnchor.constraint(equalTo: stackView.bottomAnchor, constant: AppStyles.defaultSpacing),
            stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: 0),
        ])

        stackView.layoutMargins = .init(top: AppStyles.defaultSpacing,
                                        left: AppStyles.defaultSpacing,
                                        bottom: AppStyles.defaultSpacing,
                                        right: AppStyles.defaultSpacing)
    }
}
