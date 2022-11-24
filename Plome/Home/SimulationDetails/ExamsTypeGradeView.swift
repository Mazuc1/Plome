//
//  ExamsTypeGradeView.swift
//  Plome
//
//  Created by Loic Mazuc on 24/11/2022.
//

import PlomeCoreKit
import UIKit

final class ExamsTypeGradeView: UIView {
    // MARK: - Properties



    // MARK: - UI

    private let dateLabel: UILabel = .init().configure {
        $0.font = PlomeFont.bodyM.font
        $0.textColor = PlomeColor.darkGray.color
        $0.textAlignment = .left
    }

    private let admissionLabel: UILabel = .init().configure {
        $0.font = PlomeFont.demiBoldM.font
        $0.textColor = PlomeColor.darkBlue.color
        $0.textAlignment = .left
    }

    private let imageView: UIImageView = .init()

    private let stackView: UIStackView = .init().configure {
        $0.axis = .horizontal
        $0.distribution = .fill
        $0.spacing = AppStyles.defaultSpacing
        $0.alignment = .center
        $0.isLayoutMarginsRelativeArrangement = true
    }

    // MARK: - Init

    override init(frame: CGRect) {
        
        super.init(frame: frame)
        setupView()
    }

    required init?(coder aDecoder: NSCoder) {

        super.init(coder: aDecoder)
        setupView()
    }

    // MARK: - Methods

    private func setupView() {
        translatesAutoresizingMaskIntoConstraints = false

        backgroundColor = .white
        layer.cornerRadius = AppStyles.defaultRadius


        stackView.addArrangedSubviews([imageView])

        stackView.layoutMargins = .init(top: AppStyles.defaultSpacing,
                                        left: AppStyles.defaultSpacing,
                                        bottom: AppStyles.defaultSpacing,
                                        right: AppStyles.defaultSpacing)

        stackView.stretchInView(parentView: self)
    }
}
