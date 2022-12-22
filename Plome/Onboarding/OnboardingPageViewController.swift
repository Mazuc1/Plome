//
//  OnboardingPageViewController.swift
//  Plome
//
//  Created by Loic Mazuc on 22/12/2022.
//

import UIKit
import PlomeCoreKit

final class OnboardingPageViewController: AppViewController {
    // MARK: - Properties

    let page: OnboardingPages
    private static let imageSize: CGSize = .init(width: 250, height: 250)

    // MARK: - UI

    private let titleLabel: UILabel = .init().configure {
        $0.font = PlomeFont.demiBoldL.font
        $0.textColor = PlomeColor.darkBlue.color
    }

    private let descriptionLabel: UILabel = .init().configure {
        $0.font = PlomeFont.bodyL.font
        $0.textColor = PlomeColor.darkBlue.color
        $0.numberOfLines = 0
        $0.textAlignment = .center
    }

    private let imageView: UIImageView = .init()

    private let stackView: UIStackView = .init().configure {
        $0.axis = .vertical
        $0.alignment = .center
        $0.distribution = .fillProportionally
        $0.spacing = AppStyles.defaultSpacing(factor: 3)
        $0.translatesAutoresizingMaskIntoConstraints = false
    }

    // MARK: - Init

    required init(page: OnboardingPages) {
        self.page = page
        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Life cycle

    override func viewDidLoad() {
        super.viewDidLoad()

        setupLayout()
        fillUI()
    }

    private func fillUI() {
        titleLabel.text = page.title
        descriptionLabel.text = page.text
        imageView.image = page.image.imageResize(sizeChange: OnboardingPageViewController.imageSize)
    }

    private func setupLayout() {
        stackView.addArrangedSubviews([imageView, titleLabel, descriptionLabel])

        view.addSubview(stackView)
        NSLayoutConstraint.activate([
            stackView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            stackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            stackView.widthAnchor.constraint(equalToConstant: 250),
        ])
    }
}
