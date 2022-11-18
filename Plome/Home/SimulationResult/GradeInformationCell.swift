//
//  GradeInformationCell.swift
//  Plome
//
//  Created by Loic Mazuc on 14/11/2022.
//

import PlomeCoreKit
import UIKit

class GradeInformationCell: UIView {
    // MARK: - Properties

    let title: String
    let grade: String
    let optionalInformation: String?

    // MARK: - UI

    private let titleLabel: UILabel = .init().configure {
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

    private let optionalInformationLabel: UILabel = .init().configure {
        $0.font = PlomeFont.demiBoldS.font
        $0.textColor = PlomeColor.success.color
        $0.textAlignment = .center
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

    required init(frame: CGRect, title: String, grade: String, optionalInformation: String? = nil) {
        self.grade = grade
        self.title = title
        self.optionalInformation = optionalInformation

        super.init(frame: frame)
        setupView()
    }

    required init?(coder aDecoder: NSCoder) {
        grade = ""
        title = ""
        optionalInformation = nil

        super.init(coder: aDecoder)
        setupView()
    }

    // MARK: - Methods

    private func setupView() {
        translatesAutoresizingMaskIntoConstraints = false

        backgroundColor = .white
        layer.cornerRadius = AppStyles.defaultRadius

        titleLabel.text = title
        gradeLabel.text = "\(grade)"

        let informationsStackView = UIStackView().configure {
            $0.axis = .horizontal
            $0.distribution = .equalSpacing
            $0.spacing = AppStyles.defaultSpacing
            $0.alignment = .leading
            $0.addArrangedSubview(gradeLabel)
        }

        if optionalInformation != nil {
            optionalInformationLabel.text = "\(optionalInformation!)"
            informationsStackView.insertArrangedSubview(optionalInformationLabel, at: 0)
        }

        stackView.addArrangedSubviews([titleLabel, UIView(), informationsStackView])

        stackView.stretchInView(parentView: self)

        stackView.layoutMargins = .init(top: AppStyles.defaultSpacing,
                                        left: AppStyles.defaultSpacing,
                                        bottom: AppStyles.defaultSpacing,
                                        right: AppStyles.defaultSpacing)
    }
}
