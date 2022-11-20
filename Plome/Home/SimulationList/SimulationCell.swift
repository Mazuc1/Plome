//
//  SimulationCell.swift
//  Plome
//
//  Created by Loic Mazuc on 19/11/2022.
//

import PlomeCoreKit
import UIKit

final class SimulationCell: UICollectionViewCell {
    // MARK: - Properties

    static let reuseIdentifier: String = "SimulationCell"
    static let size: CGSize = .init(width: 150, height: 200)

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

    private var finalGradeLabel: UILabel = .init().configure {
        $0.font = PlomeFont.bodyS.font
        $0.textAlignment = .center
        $0.textColor = PlomeColor.darkBlue.color
        $0.translatesAutoresizingMaskIntoConstraints = false
    }

    private var admissionLabel: UILabel = .init().configure {
        $0.font = PlomeFont.demiBoldS.font
        $0.textAlignment = .center
    }

    private var progressRing: ALProgressRing = .init().configure {
        $0.startColor = PlomeColor.pink.color
        $0.endColor = PlomeColor.lightViolet.color
        $0.lineWidth = 10
        $0.translatesAutoresizingMaskIntoConstraints = false
    }

    private var stackView: UIStackView = .init().configure {
        $0.axis = .vertical
        $0.alignment = .center
        $0.distribution = .equalSpacing
        $0.spacing = AppStyles.defaultSpacing(factor: 1.5)
        $0.backgroundColor = .white
        $0.layer.cornerRadius = AppStyles.defaultRadius
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.isLayoutMarginsRelativeArrangement = true
    }

    // MARK: - Init

    override init(frame: CGRect) {
        super.init(frame: frame)
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    // MARK: - Methods

    func setup(with viewModel: SimulationCellViewModel) {
        setupLayout()

        dateLabel.text = viewModel.date()
        labelSimulationName.text = viewModel.simulation.name
        finalGradeLabel.text = viewModel.finalGradeOutOfTwenty()
        admissionLabel.text = viewModel.admissionSentence()
        admissionLabel.textColor = viewModel.hasSucceedExam() ? PlomeColor.success.color : PlomeColor.fail.color

        progressRing.setProgress(viewModel.finalGradeProgress(), animated: true)

        backgroundColor = .clear
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

        progressRing.addSubview(finalGradeLabel)
        stackView.addArrangedSubviews([progressRing, admissionLabel])

        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 0),
            stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 0),
            contentView.bottomAnchor.constraint(equalTo: stackView.bottomAnchor, constant: AppStyles.defaultSpacing),
            stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: 0),
        ])

        NSLayoutConstraint.activate([
            progressRing.heightAnchor.constraint(equalToConstant: 80),
            progressRing.widthAnchor.constraint(equalToConstant: 80),
            finalGradeLabel.centerXAnchor.constraint(equalTo: progressRing.centerXAnchor),
            finalGradeLabel.centerYAnchor.constraint(equalTo: progressRing.centerYAnchor),
        ])

        stackView.layoutMargins = .init(top: AppStyles.defaultSpacing,
                                        left: AppStyles.defaultSpacing,
                                        bottom: AppStyles.defaultSpacing,
                                        right: AppStyles.defaultSpacing)
    }
}
