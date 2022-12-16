//
//  SimulationModelCell.swift
//  Plome
//
//  Created by Loic Mazuc on 21/10/2022.
//

import PlomeCoreKit
import UIKit

final class SimulationModelCell: UITableViewCell {
    // MARK: - Properties

    static let reuseIdentifier: String = "SimulationModelCell"

    // MARK: - UI

    private var labelSimulationName: UILabel = .init().configure {
        $0.font = PlomeFont.demiBoldM.font
        $0.numberOfLines = 1
        $0.textAlignment = .left
        $0.textColor = PlomeColor.darkBlue.color
    }

    private var labelTrials: UILabel = .init().configure {
        $0.font = PlomeFont.bodyM.font
        $0.textAlignment = .left
        $0.textColor = PlomeColor.darkGray.color
    }

    private var labelContinuousControls: UILabel = .init().configure {
        $0.font = PlomeFont.bodyM.font
        $0.textAlignment = .left
        $0.textColor = PlomeColor.darkGray.color
    }

    private var labelOptions: UILabel = .init().configure {
        $0.font = PlomeFont.bodyM.font
        $0.textAlignment = .left
        $0.textColor = PlomeColor.darkGray.color
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
        labelTrials.text = L10n.SimulationModels.numberOfTrials(simulation.number(of: .trial))
        labelContinuousControls.text = L10n.SimulationModels.numberOfContinousControls(simulation.number(of: .continuousControl))
        labelOptions.text = L10n.SimulationModels.numberOfOptions(simulation.number(of: .option))

        backgroundColor = .clear
        selectionStyle = .none
    }

    private func setupLayout() {
        contentView.addSubview(stackView)
        stackView.addArrangedSubviews([labelSimulationName, labelTrials, labelContinuousControls, labelOptions])

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
