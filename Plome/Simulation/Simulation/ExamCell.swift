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

    private static let cellHeight: CGFloat = 60
    private static let textFieldGradeWidth: CGFloat = 80

    // MARK: - UI

    private let labelExamName: UILabel = .init().configure {
        $0.font = PlomeFont.bodyM.font
        $0.textColor = PlomeColor.darkBlue.color
        $0.textAlignment = .left
        $0.numberOfLines = 1
    }

    private let labelRatio: UILabel = .init().configure {
        $0.font = PlomeFont.demiBoldM.font
        $0.textColor = PlomeColor.darkBlue.color
        $0.textAlignment = .left
    }

    private let labelCoefficient: AppLabel = .init(withInsets: AppStyles.defaultSpacing(factor: 0.5),
                                                   AppStyles.defaultSpacing(factor: 0.5),
                                                   AppStyles.defaultSpacing(factor: 0.5),
                                                   AppStyles.defaultSpacing(factor: 0.5)).configure {
        $0.font = PlomeFont.bodyS.font
        $0.textColor = PlomeColor.darkBlue.color
        $0.textAlignment = .center
        $0.layer.cornerRadius = AppStyles.defaultRadius
        $0.clipsToBounds = true
        $0.backgroundColor = PlomeColor.darkGray.color.withAlphaComponent(0.2)
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
        $0.widthAnchor.constraint(equalToConstant: 70).isActive = true
    }

    private lazy var leftStackView = UIStackView().configure {
        $0.axis = .vertical
        $0.alignment = .leading
        $0.distribution = .fill
        $0.spacing = AppStyles.defaultSpacing(factor: 0.5)
        $0.addArrangedSubviews([labelExamName, labelCoefficient])
        $0.translatesAutoresizingMaskIntoConstraints = false
    }

    private lazy var rightStackView = UIStackView().configure {
        $0.axis = .horizontal
        $0.alignment = .center
        $0.distribution = .fill
        $0.spacing = AppStyles.defaultSpacing(factor: 0.5)
        $0.addArrangedSubviews([textFieldGrade, labelRatio])
        $0.translatesAutoresizingMaskIntoConstraints = false
    }

    private let containerView: UIView = .init().configure {
        $0.backgroundColor = .white
        $0.layer.cornerRadius = AppStyles.defaultRadius
    }

    // MARK: - Init

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        textFieldGrade.delegate = self
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        textFieldGrade.text = nil

        textFieldGrade.setOutlineColor(.lightGray, for: .normal)
        textFieldGrade.setFloatingLabelColor(PlomeColor.black.color, for: .normal)
    }

    // MARK: - Methods

    func setup(exam: Exam?) {
        self.exam = exam
        setupLayout()

        labelExamName.text = exam?.name

        if let grade = exam?.grade {
            textFieldGrade.text = "\(grade)"
        }

        if let ratio = exam?.ratio {
            labelRatio.text = "/ \(ratio)"
        }

        if let coeff = exam?.coefficient {
            labelCoefficient.text = "\(L10n.Home.coeff): \(coeff)"
        }

        backgroundColor = .clear
        selectionStyle = .none
    }

    private func setupLayout() {
        containerView.stretchInView(parentView: contentView, edges: .init(top: AppStyles.defaultSpacing(factor: 0.5),
                                                                          left: AppStyles.defaultSpacing,
                                                                          bottom: AppStyles.defaultSpacing(factor: 0.5),
                                                                          right: AppStyles.defaultSpacing))

        containerView.addSubview(leftStackView)
        containerView.addSubview(rightStackView)

        NSLayoutConstraint.activate([
            containerView.heightAnchor.constraint(equalToConstant: Self.cellHeight),
            leftStackView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: AppStyles.defaultSpacing),
            leftStackView.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),

            containerView.trailingAnchor.constraint(equalTo: rightStackView.trailingAnchor, constant: AppStyles.defaultSpacing),
            rightStackView.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
            rightStackView.leadingAnchor.constraint(equalTo: leftStackView.trailingAnchor, constant: AppStyles.defaultSpacing),
        ])
    }
}

// MARK: - UITextFieldDelegate

extension ExamCell: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }

    func textFieldDidEndEditing(_ textField: UITextField) {
        let saveResult = exam?.saveIfRulesAreRespected(textField.text, in: .grade)

        setStyle(for: textField, saveSucceed: saveResult ?? false)

        simulationViewModelInput?.didChangeSimulationExamGrade()
    }

    private func setStyle(for textField: UITextField, saveSucceed: Bool) {
        guard let mdcTextField = textField as? MDCOutlinedTextField else { return }

        if saveSucceed {
            mdcTextField.setOutlineColor(.lightGray, for: .normal)
            mdcTextField.setFloatingLabelColor(PlomeColor.black.color, for: .normal)
        } else {
            mdcTextField.setOutlineColor(PlomeColor.fail.color, for: .normal)
            mdcTextField.setFloatingLabelColor(PlomeColor.fail.color, for: .normal)
        }
    }
}
