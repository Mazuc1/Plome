//
//  SomeNumberCell.swift
//  Plome
//
//  Created by Loic Mazuc on 14/11/2022.
//

import PlomeCoreKit
import UIKit

class SomeNumberCell: UIView {
    // MARK: - Properties

    let examTypeName: String
    let grade: String

    // MARK: - UI

    private let examTypeNameLabel: UILabel = .init().configure {
        $0.font = PlomeFont.bodyM.font
        $0.textColor = PlomeColor.darkBlue.color
        $0.textAlignment = .center
        $0.numberOfLines = 0
    }

    private let gradeLabel: UILabel = .init().configure {
        $0.font = PlomeFont.bodyM.font
        $0.textColor = PlomeColor.darkGray.color
        $0.textAlignment = .center
        $0.numberOfLines = 0
    }

    private let stackView: UIStackView = .init().configure {
        $0.axis = .horizontal
        $0.distribution = .equalSpacing
        $0.spacing = AppStyles.defaultSpacing
        $0.alignment = .leading
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.isLayoutMarginsRelativeArrangement = true
    }

    // MARK: - Init

    required init(frame: CGRect, examTypeName: String, grade: String) {
        self.grade = grade
        self.examTypeName = examTypeName

        super.init(frame: frame)
        setupView()
    }

    required init?(coder aDecoder: NSCoder) {
        grade = ""
        examTypeName = ""

        super.init(coder: aDecoder)
        setupView()
    }

    // MARK: - Methods

    private func setupView() {
        translatesAutoresizingMaskIntoConstraints = false

        backgroundColor = .white
        layer.cornerRadius = AppStyles.defaultRadius

        examTypeNameLabel.text = examTypeName
        gradeLabel.text = "\(grade)/20"

        stackView.addArrangedSubviews([examTypeNameLabel, UIView(), gradeLabel])
        stackView.stretchInView(parentView: self)

        stackView.layoutMargins = .init(top: AppStyles.defaultSpacing,
                                        left: AppStyles.defaultSpacing,
                                        bottom: AppStyles.defaultSpacing,
                                        right: AppStyles.defaultSpacing)
    }
}
