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

    weak var simulationViewModelInput: SimulationViewModelInput?

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
        $0.font = PlomeFont.bodyM.font
        $0.keyboardType = .numbersAndPunctuation
        $0.borderStyle = .roundedRect
        $0.returnKeyType = .done
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.widthAnchor.constraint(greaterThanOrEqualToConstant: 100).isActive = true
    }

    private var textFieldGrade: UITextField = .init().configure {
        $0.placeholder = "08/20"
        $0.font = PlomeFont.bodyM.font
        $0.keyboardType = .numbersAndPunctuation
        $0.borderStyle = .roundedRect
        $0.returnKeyType = .done
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

        textFieldGrade.backgroundColor = nil
        textFieldCoeff.backgroundColor = nil

        textFieldGrade.font = PlomeFont.bodyM.font
        textFieldCoeff.font = PlomeFont.bodyM.font
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

// MARK: - Table View Delegate

extension ExamCell: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }

    // Set default style of textField when start editing to avoid error style when user entry new correct value during editing
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.textColor = .black
        textField.backgroundColor = nil
        textField.font = PlomeFont.bodyM.font
    }

    func textFieldDidEndEditing(_ textField: UITextField) {
        if let text = textField.text,
           !text.isEmpty
        {
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
        if !result {
            textField.textColor = .red
            textField.font = PlomeFont.demiBoldM.font
            textField.backgroundColor = .red.withAlphaComponent(0.1)
        } else {
            textField.textColor = .black
            textField.backgroundColor = nil
            textField.font = PlomeFont.bodyM.font
        }
    }
}
