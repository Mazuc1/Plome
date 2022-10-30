//
//  EmptySimulationListView.swift
//  Plome
//
//  Created by Loic Mazuc on 30/10/2022.
//

import PlomeCoreKit
import UIKit

final class EmptySimulationListView: UIView {
    // MARK: - UI

    private let imageView: UIImageView = .init().configure {
        $0.image = Icons.list.configure(weight: .regular, color: .pink, size: 50)
        $0.sizeToFit()
    }

    private let textLabel: UILabel = .init().configure {
        $0.text = "Vous retrouverez ici toutes vos simulations d’examens.\n\nVous pouvez reprendre une existante pour la modifier."
        $0.font = PlomeFont.bodyM.font
        $0.textColor = PlomeColor.darkGray.color
        $0.textAlignment = .center
        $0.numberOfLines = 0
    }

    private let stackView: UIStackView = .init().configure {
        $0.axis = .vertical
        $0.distribution = .fill
        $0.spacing = AppStyles.defaultSpacing(factor: 2)
        $0.alignment = .center
        $0.translatesAutoresizingMaskIntoConstraints = false
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

        stackView.addArrangedSubviews([imageView, textLabel])
        stackView.stretchInView(parentView: self)
    }
}
