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
    static let height: CGFloat = 105

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

    private var stackView: UIStackView = UIStackView().configure(block: {
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

    func setup(with viewModel: SimulationCellViewModel) {
        setupLayout()

        dateLabel.text = viewModel.date()
        labelSimulationName.text = viewModel.simulation.name
        finalGradeLabel.text = viewModel.finalGradeOutOfTwenty()
        admissionLabel.text = viewModel.admissionSentence()
        admissionLabel.textColor = viewModel.hasSucceedExam() ? PlomeColor.success.color : PlomeColor.fail.color

        progressRing.setProgress(viewModel.finalGradeProgress(), animated: true)

        backgroundColor = .clear
        selectionStyle = .none
        
        contentView.backgroundColor = .white
        contentView.layer.cornerRadius = AppStyles.defaultRadius
    }

    private func setupLayout() {
        stackView.addArrangedSubviews([dateLabel, labelSimulationName, admissionLabel])
        contentView.addSubview(stackView)
        
        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: AppStyles.defaultSpacing(factor: 2)),
            stackView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
        ])

        progressRing.addSubview(finalGradeLabel)
        contentView.addSubview(progressRing)

        NSLayoutConstraint.activate([
            contentView.trailingAnchor.constraint(equalTo: progressRing.trailingAnchor, constant: AppStyles.defaultSpacing(factor: 2)),
            progressRing.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            finalGradeLabel.centerXAnchor.constraint(equalTo: progressRing.centerXAnchor),
            finalGradeLabel.centerYAnchor.constraint(equalTo: progressRing.centerYAnchor),
            progressRing.heightAnchor.constraint(equalToConstant: 80),
            progressRing.widthAnchor.constraint(equalToConstant: 80),
        ])
    }
}
