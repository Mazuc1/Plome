//
//  DraftSimulationCell.swift
//  Plome
//
//  Created by Loic Mazuc on 01/06/2023.
//

import PlomeCoreKit
import UIKit

final class DraftSimulationCell: UITableViewCell {
    // MARK: - Properties

    static let reuseIdentifier: String = "DraftSimulationCell"
    static let height: CGFloat = 65

    // MARK: - UI

    private var dateLabel: UILabel = .init().configure {
        $0.font = PlomeFont.bodyM.font
        $0.textAlignment = .left
        $0.textColor = PlomeColor.darkGray.color
    }

    private var labelSimulationName: UILabel = .init().configure {
        $0.font = PlomeFont.demiBoldM.font
        $0.textAlignment = .left
        $0.textColor = PlomeColor.darkBlue.color
    }

    private var stackView: UIStackView = .init().configure(block: {
        $0.axis = .vertical
        $0.alignment = .leading
        $0.distribution = .equalSpacing
        $0.spacing = AppStyles.defaultSpacing(factor: 0.5)
        $0.translatesAutoresizingMaskIntoConstraints = false
    })

    // MARK: - Init

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    // MARK: - Methods

    override func layoutSubviews() {
        super.layoutSubviews()

        contentView.frame = contentView.frame.inset(by: UIEdgeInsets(top: 0, left: 0, bottom: AppStyles.defaultSpacing, right: 0))
    }

    func setup(with simulation: Simulation) {
        setupLayout()

        dateLabel.text = simulation.date?.toString(format: .classicPoint)
        labelSimulationName.text = simulation.name

        backgroundColor = .clear
        selectionStyle = .none

        contentView.backgroundColor = .white
        contentView.layer.cornerRadius = AppStyles.defaultRadius
    }

    private func setupLayout() {
        stackView.addArrangedSubviews([dateLabel, labelSimulationName])
        contentView.addSubview(stackView)

        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: AppStyles.defaultSpacing(factor: 2)),
            stackView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
        ])
    }
}
