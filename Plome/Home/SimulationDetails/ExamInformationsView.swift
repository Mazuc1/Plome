//
//  ExamInformationsView.swift
//  Plome
//
//  Created by Loic Mazuc on 25/11/2022.
//

import PlomeCoreKit
import UIKit

final class ExamInformationsView: UIView {
    // MARK: - Properties

    private static let betterGradeImage: UIImage = Icons.arrowUp.configure(weight: .regular, color: .success, size: 20)
    private static let worstGradeImage: UIImage = Icons.arrowDown.configure(weight: .regular, color: .fail, size: 20)

    private let shaper: CalculatorShaper
    private let gradeType: GradeType

    // MARK: - UI

    private let gradeTypeTitleLabel: UILabel = .init().configure {
        $0.font = PlomeFont.demiBoldM.font
        $0.textColor = PlomeColor.darkBlue.color
    }

    private let examNameLabel: UILabel = .init().configure {
        $0.font = PlomeFont.bodyM.font
        $0.textColor = PlomeColor.darkBlue.color
    }

    private let gradeLabel: UILabel = .init().configure {
        $0.font = PlomeFont.bodyM.font
        $0.textColor = PlomeColor.darkGray.color
    }

    private let coefficientLabel: UILabel = .init().configure {
        $0.font = PlomeFont.bodyM.font
        $0.textColor = PlomeColor.darkGray.color
    }

    private let imageView: UIImageView = .init()

    private let stackView: UIStackView = .init().configure {
        $0.axis = .vertical
        $0.distribution = .fill
        $0.spacing = AppStyles.defaultSpacing
        $0.alignment = .leading
        $0.isLayoutMarginsRelativeArrangement = true
        $0.layoutMargins = .init(top: AppStyles.defaultSpacing,
                                 left: AppStyles.defaultSpacing,
                                 bottom: AppStyles.defaultSpacing,
                                 right: AppStyles.defaultSpacing)
    }

    // MARK: - Init

    required init(frame: CGRect, shaper: CalculatorShaper, gradeType: GradeType) {
        self.shaper = shaper
        self.gradeType = gradeType

        super.init(frame: frame)
        setupView()
    }

    required init?(coder aDecoder: NSCoder) {
        shaper = .init(calculator: .init(simulation: .init(name: "", date: nil, exams: nil, type: .custom)))
        gradeType = .worst

        super.init(coder: aDecoder)
        setupView()
    }

    // MARK: - Methods

    private func setupView() {
        translatesAutoresizingMaskIntoConstraints = false
        setupLayout()

        backgroundColor = .white
        layer.cornerRadius = AppStyles.defaultRadius

        switch gradeType {
        case .worst:
            imageView.image = Self.worstGradeImage
            gradeTypeTitleLabel.text = "Pire note"
        case .better:
            imageView.image = Self.betterGradeImage
            gradeTypeTitleLabel.text = "Meilleur note"
        }

        guard let exam = shaper.getExamGradeWhere(is: gradeType) else { return }

        examNameLabel.text = exam.name
        gradeLabel.text = exam.truncatedGrade()
        coefficientLabel.text = "\(exam.coefficient ?? 1)"
    }

    private func setupLayout() {
        let headerStackView: UIStackView = .init().configure {
            $0.axis = .horizontal
            $0.distribution = .fill
            $0.spacing = AppStyles.defaultSpacing
            $0.alignment = .leading
            $0.addArrangedSubviews([gradeTypeTitleLabel, imageView])
        }

        let informationsStackView: UIStackView = .init().configure {
            $0.axis = .vertical
            $0.distribution = .fill
            $0.spacing = AppStyles.defaultSpacing(factor: 0.5)
            $0.alignment = .leading
            $0.addArrangedSubviews([examNameLabel, gradeLabel, coefficientLabel])
        }

        stackView.addArrangedSubviews([headerStackView, informationsStackView])

        stackView.stretchInView(parentView: self)
    }
}
