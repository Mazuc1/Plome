//
//  CatchUpView.swift
//  Plome
//
//  Created by Loic Mazuc on 18/11/2022.
//

import PlomeCoreKit
import UIKit

class CatchUpView: UIView {
    // MARK: - Properties

    let grade: Float
    let differenceAfterCatchUp: [Exam: Int]

    // MARK: - UI

    private let titleLabel: UILabel = .init().configure {
        $0.text = "Comment vous rattrapez ?"
        $0.font = PlomeFont.demiBoldM.font
        $0.numberOfLines = 0
        $0.textAlignment = .left
        $0.textColor = PlomeColor.darkBlue.color
    }

    private let descriptionLabel: UILabel = .init().configure {
        $0.text = "Vous obtiendrez votre diplôme en obtenant des points supplémentaires:"
        $0.font = PlomeFont.bodyM.font
        $0.textColor = PlomeColor.darkGray.color
        $0.textAlignment = .left
        $0.numberOfLines = 0
    }

    private let gradeInformationStackView: UIStackView = .init().configure {
        $0.axis = .vertical
        $0.distribution = .equalSpacing
        $0.spacing = AppStyles.defaultSpacing
        $0.alignment = .leading
    }

    private let resultLabel: UILabel = .init().configure {
        $0.text = "Votre note sera alors de"
        $0.font = PlomeFont.bodyM.font
        $0.textAlignment = .center
        $0.textColor = PlomeColor.darkBlue.color
    }

    private let gradeLabel: AppLabel = .init(withInsets: AppStyles.defaultSpacing(factor: 2),
                                             AppStyles.defaultSpacing(factor: 2),
                                             AppStyles.defaultSpacing(factor: 2),
                                             AppStyles.defaultSpacing(factor: 2)).configure {
        $0.text = "10.36/20"
        $0.font = PlomeFont.demiBoldM.font
        $0.textAlignment = .center
        $0.textColor = PlomeColor.darkBlue.color
        $0.backgroundColor = .white
        $0.layer.cornerRadius = AppStyles.defaultRadius
        $0.clipsToBounds = true
    }

    private let stackView: UIStackView = .init().configure {
        $0.axis = .vertical
        $0.distribution = .equalSpacing
        $0.spacing = AppStyles.defaultSpacing(factor: 2)
        $0.alignment = .center
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.isLayoutMarginsRelativeArrangement = true
    }

    // MARK: - Init

    required init(frame: CGRect, grade: Float, differenceAfterCatchUp: [Exam: Int]) {
        self.grade = grade
        self.differenceAfterCatchUp = differenceAfterCatchUp

        super.init(frame: frame)
        setupView()
    }

    required init?(coder aDecoder: NSCoder) {
        grade = 0
        differenceAfterCatchUp = .init()

        super.init(coder: aDecoder)
        setupView()
    }

    // MARK: - Methods

    private func setupView() {
        _ = differenceAfterCatchUp
            .sorted { $0.key.name < $1.key.name }
            .map { [gradeInformationStackView] key, value in
                guard let grade = key.grade else { return }
                let cell = GradeInformationCell(frame: .zero, title: key.name, grade: grade, optionalInformation: "+\(value)")
                gradeInformationStackView.addArrangedSubview(cell)
                cell.attachToSides(parentView: gradeInformationStackView)
            }

        setupLayout()
    }

    private func setupLayout() {
        let labelStackView = UIStackView().configure(block: {
            $0.axis = .vertical
            $0.distribution = .equalSpacing
            $0.spacing = AppStyles.defaultSpacing
            $0.alignment = .leading
            $0.addArrangedSubviews([titleLabel, descriptionLabel])
        })

        let resultStackView = UIStackView().configure(block: {
            $0.axis = .vertical
            $0.distribution = .equalSpacing
            $0.spacing = AppStyles.defaultSpacing(factor: 1.5)
            $0.alignment = .center
            $0.addArrangedSubviews([resultLabel, gradeLabel])
        })

        stackView.addArrangedSubviews([labelStackView, gradeInformationStackView, resultStackView])
        labelStackView.attachToSides(parentView: stackView)
        resultStackView.attachToSides(parentView: stackView)
        gradeInformationStackView.attachToSides(parentView: stackView)

        stackView.stretchInView(parentView: self)
    }
}
