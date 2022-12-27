//
//  ExamCell.swift
//  Plome
//
//  Created by Loic Mazuc on 04/11/2022.
//

import MaterialComponents
import PlomeCoreKit
import UIKit

final class ExamCell: UITableViewCell {
    // MARK: - Properties

    static let reuseIdentifier: String = "ExamCell"

    private var exam: Exam?

    weak var simulationViewModelInput: SimulationViewModelInput?

    // MARK: - UI

    private var labelExamName: AppLabel = .init(withInsets: AppStyles.defaultSpacing,
                                                AppStyles.defaultSpacing,
                                                AppStyles.defaultSpacing,
                                                AppStyles.defaultSpacing).configure {
        $0.font = PlomeFont.bodyM.font
        $0.textColor = PlomeColor.darkBlue.color
        $0.textAlignment = .left
        $0.numberOfLines = 0
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

    private let textFieldGrade: MDCOutlinedTextField = .init().configure {
        $0.label.text = L10n.Home.grade
        $0.placeholder = L10n.Home.gradePlaceholder
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
        $0.backgroundColor = .white
        $0.layer.cornerRadius = AppStyles.defaultRadius
        $0.alignment = .center
        $0.distribution = .fill
        $0.spacing = AppStyles.defaultSpacing
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.isLayoutMarginsRelativeArrangement = true
        $0.layoutMargins = .init(top: AppStyles.defaultSpacing(factor: 0.5),
                                 left: AppStyles.defaultSpacing,
                                 bottom: AppStyles.defaultSpacing(factor: 0.5),
                                 right: AppStyles.defaultSpacing)
    }

    // MARK: - Init

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        textFieldCoeff.delegate = self
        textFieldGrade.delegate = self
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        textFieldGrade.text = nil
        textFieldCoeff.text = nil
        
        textFieldGrade.setOutlineColor(.lightGray, for: .normal)
        textFieldGrade.setFloatingLabelColor(PlomeColor.black.color, for: .normal)
        
        textFieldCoeff.setOutlineColor(.lightGray, for: .normal)
        textFieldCoeff.setFloatingLabelColor(PlomeColor.black.color, for: .normal)
    }

    // MARK: - Methods

    func setup(exam: Exam?) {
        self.exam = exam
        setupLayout()

        labelExamName.text = exam?.name
        if let coeff = exam?.coefficient {
            textFieldCoeff.text = "\(coeff)"
        }

        if let grade = exam?.grade {
            textFieldGrade.text = grade
        }

        backgroundColor = .clear
        selectionStyle = .none
    }

    private func setupLayout() {
        contentView.addSubview(stackView)
        stackView.addArrangedSubviews([labelExamName, textFieldCoeff, textFieldGrade])

        NSLayoutConstraint.activate([
            stackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            stackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: AppStyles.defaultSpacing),
            stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
        ])
    }
}

// MARK: - Table View Delegate

extension ExamCell: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }

    func textFieldDidEndEditing(_ textField: UITextField) {
        if let text = textField.text, !text.isEmpty {
            var checkResult: Bool?

            if textField.placeholder == "08/20" {
                checkResult = exam?.save(text, ifIsConformTo: .grade)
            } else if textField.placeholder == "1.0" {
                checkResult = exam?.save(text, ifIsConformTo: .coeff)
            }

            setStyle(for: textField, dependOf: checkResult ?? false)
        } else {
            exam?.grade = nil
        }

        simulationViewModelInput?.userDidChangeValue()
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
