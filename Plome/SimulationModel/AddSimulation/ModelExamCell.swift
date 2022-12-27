//
//  ModelExamCell.swift
//  Plome
//
//  Created by Loic Mazuc on 23/10/2022.
//

import MaterialComponents
import PlomeCoreKit
import UIKit

final class ModelExamCell: UITableViewCell {
    // MARK: - Properties

    static let reuseIdentifier: String = "ModelExamCell"

    private var exam: Exam?
    weak var addSimulationModelViewModelInput: AddSimulationModelViewModelInput?

    // MARK: - UI

    private var labelExamName: UILabel = .init().configure {
        $0.font = PlomeFont.bodyL.font
        $0.textColor = PlomeColor.darkBlue.color
        $0.textAlignment = .left
        $0.numberOfLines = 0
        $0.translatesAutoresizingMaskIntoConstraints = false
    }

    private let textFieldCoeff: MDCOutlinedTextField = .init().configure {
        $0.label.text = L10n.Home.coeff
        $0.placeholder = L10n.Home.coeffPlaceholder
        $0.font = PlomeFont.bodyM.font
        $0.verticalDensity = 30
        $0.setOutlineColor(.lightGray, for: .normal)
        $0.setNormalLabelColor(.lightGray, for: .normal)
        $0.sizeToFit()
        $0.keyboardType = .numbersAndPunctuation
        $0.returnKeyType = .done
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.widthAnchor.constraint(equalToConstant: 100).isActive = true
    }

    private var stackView: UIStackView = .init().configure {
        $0.axis = .horizontal
        $0.alignment = .center
        $0.distribution = .fill
        $0.spacing = AppStyles.defaultSpacing(factor: 0.5)
        $0.backgroundColor = .white
        $0.layer.cornerRadius = AppStyles.defaultRadius
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.isLayoutMarginsRelativeArrangement = true
    }

    // MARK: - Init

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        textFieldCoeff.delegate = self
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        textFieldCoeff.text = nil

        textFieldCoeff.setOutlineColor(.lightGray, for: .normal)
        textFieldCoeff.setFloatingLabelColor(PlomeColor.black.color, for: .normal)
    }

    // MARK: - Methods

    func setup(exam: Exam) {
        self.exam = exam
        setupLayout()

        labelExamName.text = exam.name
        if let coeff = exam.coefficient {
            textFieldCoeff.text = "\(coeff)"
        }

        backgroundColor = .clear
        selectionStyle = .none
    }

    private func setupLayout() {
        contentView.addSubview(stackView)
        stackView.addArrangedSubviews([labelExamName, textFieldCoeff])

        NSLayoutConstraint.activate([
            stackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            stackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: AppStyles.defaultSpacing),
            stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
        ])

        stackView.layoutMargins = .init(top: AppStyles.defaultSpacing,
                                        left: AppStyles.defaultSpacing,
                                        bottom: AppStyles.defaultSpacing,
                                        right: AppStyles.defaultSpacing)
    }
}

// MARK: - UITextFieldDelegate

extension ModelExamCell: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }

    func textFieldDidEndEditing(_ textField: UITextField) {
        if let text = textField.text, !text.isEmpty {
            var checkResult: Bool?

            checkResult = exam?.save(text, ifIsConformTo: .coeff)

            setStyle(for: textField, dependOf: checkResult ?? false)
        } else {
            exam?.coefficient = nil
        }

        addSimulationModelViewModelInput?.userDidChangeValue()
    }

    private func setStyle(for textField: UITextField, dependOf result: Bool) {
        guard let mdcTextField = textField as? MDCOutlinedTextField else { return }

        if !result {
            mdcTextField.setOutlineColor(PlomeColor.fail.color, for: .normal)
            mdcTextField.setFloatingLabelColor(PlomeColor.fail.color, for: .normal)
        } else {
            mdcTextField.setOutlineColor(.lightGray, for: .normal)
            mdcTextField.setFloatingLabelColor(PlomeColor.black.color, for: .normal)
        }
    }
}
