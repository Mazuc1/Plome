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

    private var dateLabel: UILabel = .init().configure {
        $0.font = PlomeFont.bodyM.font
        $0.numberOfLines = 1
        $0.textAlignment = .left
        $0.textColor = PlomeColor.darkGray.color
    }

    private var labelSimulationName: UILabel = .init().configure {
        $0.font = PlomeFont.demiBoldM.font
        $0.numberOfLines = 1
        $0.textAlignment = .left
        $0.textColor = PlomeColor.darkBlue.color
    }

    private var progressRing: ALProgressRing = .init().configure {
        $0.startColor = PlomeColor.pink.color
        $0.endColor = PlomeColor.lightViolet.color
        $0.lineWidth = 10
        $0.translatesAutoresizingMaskIntoConstraints = false
    }

    private var stackView: UIStackView = .init().configure {
        $0.axis = .vertical
        $0.alignment = .leading
        $0.distribution = .equalSpacing
        $0.spacing = AppStyles.defaultSpacing(factor: 1.5)
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

        dateLabel.text = viewModel.date()
        labelSimulationName.text = viewModel.simulation.name
        progressRing.setProgress(viewModel.finalGradeProgress(), animated: true)

        backgroundColor = .clear
        selectionStyle = .none
    }

    private func setupLayout() {
        contentView.addSubview(stackView)

        stackView.addArrangedSubview(UIStackView().configure(block: {
            $0.axis = .vertical
            $0.alignment = .leading
            $0.distribution = .equalSpacing
            $0.spacing = AppStyles.defaultSpacing(factor: 0.5)
            $0.addArrangedSubviews([dateLabel, labelSimulationName])
        }))

        stackView.addArrangedSubview(progressRing)

        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 0),
            stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 0),
            contentView.bottomAnchor.constraint(equalTo: stackView.bottomAnchor, constant: AppStyles.defaultSpacing),
            stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: 0),
        ])

        NSLayoutConstraint.activate([
            progressRing.heightAnchor.constraint(equalToConstant: 70),
            progressRing.widthAnchor.constraint(equalToConstant: 70),
        ])

        stackView.layoutMargins = .init(top: AppStyles.defaultSpacing,
                                        left: AppStyles.defaultSpacing,
                                        bottom: AppStyles.defaultSpacing,
                                        right: AppStyles.defaultSpacing)
    }
}
