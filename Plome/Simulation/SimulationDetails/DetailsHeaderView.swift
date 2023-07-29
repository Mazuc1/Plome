//
//  DetailsHeaderView.swift
//  Plome
//
//  Created by Loic Mazuc on 24/11/2022.
//

import PlomeCoreKit
import UIKit

final class DetailsHeaderView: UIView {
    // MARK: - Properties

    private static let succeessImage: UIImage = Icons.success.configure(weight: .regular, color: .success, size: 30)
    private static let failureImage: UIImage = Icons.fail.configure(weight: .regular, color: .fail, size: 30)

    private let shaper: CalculatorShaper

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

    required init(frame: CGRect, shaper: CalculatorShaper) {
        self.shaper = shaper

        super.init(frame: frame)
        setupView()
    }

    required init?(coder aDecoder: NSCoder) {
        shaper = .init(calculator: .init(simulation: .init(name: "", date: nil, exams: nil, type: .custom)))

        super.init(coder: aDecoder)
        setupView()
    }

    // MARK: - Methods

    private func setupView() {
        translatesAutoresizingMaskIntoConstraints = false

        backgroundColor = .white
        layer.cornerRadius = AppStyles.defaultRadius

        dateLabel.text = L10n.Home.simulationFromDate(shaper.date(with: .classicPoint))
        admissionLabel.text = shaper.admissionSentence()

        let informationStackView: UIStackView = .init().configure {
            $0.axis = .vertical
            $0.distribution = .equalSpacing
            $0.spacing = AppStyles.defaultSpacing(factor: 0.5)
            $0.alignment = .leading
            $0.addArrangedSubviews([dateLabel, admissionLabel])

            $0.addArrangedSubview(MentionView(frame: .zero, mention: shaper.mention()))
        }

        imageView.image = shaper.hasSucceedExam() ? Self.succeessImage : Self.failureImage

        stackView.addArrangedSubviews([informationStackView, imageView])

        stackView.layoutMargins = .init(top: AppStyles.defaultSpacing,
                                        left: AppStyles.defaultSpacing,
                                        bottom: AppStyles.defaultSpacing,
                                        right: AppStyles.defaultSpacing)

        stackView.stretchInView(parentView: self)
    }
}

// MARK: - MentionView

final class MentionView: UIView {
    // MARK: - Properties

    private var mention: Mention

    // MARK: - UI

    private let imageView: UIImageView = .init()

    private let titleLabel: UILabel = .init().configure {
        $0.font = PlomeFont.bodyM.font
        $0.textAlignment = .left
    }

    private let stackView: UIStackView = .init().configure {
        $0.axis = .horizontal
        $0.distribution = .equalSpacing
        $0.spacing = AppStyles.defaultSpacing
        $0.alignment = .center
        $0.isLayoutMarginsRelativeArrangement = true
    }

    // MARK: - Init

    required init(frame: CGRect, mention: Mention) {
        self.mention = mention

        super.init(frame: frame)
        setupView()
    }

    required init?(coder aDecoder: NSCoder) {
        mention = .without

        super.init(coder: aDecoder)
        setupView()
    }

    // MARK: - Methods

    private func setupView() {
        imageView.image = Icons.medal.configure(weight: .regular, color: mention.plomeColor, size: 15)
        titleLabel.text = mention.name
        titleLabel.textColor = mention.plomeColor.color
        backgroundColor = mention.plomeColor.color.withAlphaComponent(0.1)
        layer.cornerRadius = AppStyles.defaultRadius

        stackView.addArrangedSubviews([imageView, titleLabel])

        let margin = AppStyles.defaultSpacing(factor: 0.5)
        stackView.layoutMargins = .init(top: margin, left: margin, bottom: margin, right: margin)

        stackView.stretchInView(parentView: self)
    }

    func update(mention: Mention) {
        self.mention = mention

        titleLabel.text = mention.name
        titleLabel.textColor = mention.plomeColor.color
        imageView.image = Icons.medal.configure(weight: .regular, color: mention.plomeColor, size: 15)
        backgroundColor = mention.plomeColor.color.withAlphaComponent(0.1)
    }
}
