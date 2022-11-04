//
//  ExamCell.swift
//  Plome
//
//  Created by Loic Mazuc on 04/11/2022.
//

import PlomeCoreKit
import UIKit

final class ExamCell: UITableViewCell {
    // MARK: - Properties

    static let reuseIdentifier: String = "ExamCell"
    static let modelExamCellHeight: CGFloat = 40

    private var exam: Exam?

    // MARK: - UI

    private var labelExamName: UILabel = .init().configure {
        $0.font = PlomeFont.bodyM.font
        $0.textColor = PlomeColor.darkBlue.color
        $0.textAlignment = .left
        $0.numberOfLines = 1
    }

    private var labelCoeff: UILabel = .init().configure {
        $0.text = "Coeff."
        $0.font = PlomeFont.bodyS.font
        $0.textColor = PlomeColor.darkGray.color
        $0.textAlignment = .left
        $0.numberOfLines = 1
    }

    private var labelGrade: UILabel = .init().configure {
        $0.text = "Note"
        $0.font = PlomeFont.bodyS.font
        $0.textColor = PlomeColor.darkGray.color
        $0.textAlignment = .left
        $0.numberOfLines = 1
    }

    private var textFieldCoeff: UITextField = .init().configure {
        $0.placeholder = "1.0"
        $0.keyboardType = .numbersAndPunctuation
        $0.borderStyle = .roundedRect
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.widthAnchor.constraint(greaterThanOrEqualToConstant: 100).isActive = true
    }

    private var textFieldGrade: UITextField = .init().configure {
        $0.placeholder = "08/20"
        $0.keyboardType = .numbersAndPunctuation
        $0.borderStyle = .roundedRect
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.widthAnchor.constraint(greaterThanOrEqualToConstant: 100).isActive = true
    }

    private var stackViewTextFields: UIStackView = .init().configure {
        $0.axis = .horizontal
        $0.alignment = .center
        $0.spacing = AppStyles.defaultSpacing
        $0.distribution = .equalSpacing
        $0.backgroundColor = .white
        $0.layer.cornerRadius = AppStyles.defaultRadius
        $0.isLayoutMarginsRelativeArrangement = true
    }

    private var stackView: UIStackView = .init().configure {
        $0.axis = .vertical
        $0.alignment = .fill
        $0.distribution = .equalSpacing
        $0.spacing = AppStyles.defaultSpacing
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.isLayoutMarginsRelativeArrangement = true
    }

    // MARK: - Init

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Methods

    func setup(exam: Exam?) {
        self.exam = exam
        setupLayout()

        labelExamName.text = exam?.name
        if let coeff = exam?.coefficient {
            textFieldCoeff.text = "\(coeff)"
        }

        backgroundColor = .clear
        selectionStyle = .none
    }

    private func setupLayout() {
        stackViewTextFields.layoutMargins = .init(top: AppStyles.defaultSpacing(factor: 0.5),
                                                  left: AppStyles.defaultSpacing,
                                                  bottom: AppStyles.defaultSpacing(factor: 0.5),
                                                  right: AppStyles.defaultSpacing)

        stackView.layoutMargins = .init(top: AppStyles.defaultSpacing,
                                        left: 0,
                                        bottom: AppStyles.defaultSpacing,
                                        right: 0)

        stackViewTextFields.addArrangedSubviews([labelCoeff, textFieldCoeff, labelGrade, textFieldGrade])
        stackView.addArrangedSubviews([labelExamName, stackViewTextFields])

        stackView.stretchInView(parentView: contentView)
    }
}
