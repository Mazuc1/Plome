//
//  SimulationCellHeaderView.swift
//  Plome
//
//  Created by Loic Mazuc on 01/06/2023.
//

import PlomeCoreKit
import UIKit

public final class SimulationCellHeaderView: UITableViewHeaderFooterView {
    // MARK: - Properties

    public static let reuseIdentifier: String = "SimulationCellHeaderView"

    // MARK: - UI

    private var titleLabel: UILabel = .init().configure {
        $0.font = PlomeFont.bodyM.font
        $0.textColor = PlomeColor.darkGray.color
        $0.textAlignment = .left
    }

    // MARK: - Init

    public required init(text: String, reuseIdentifier: String?) {
        titleLabel.text = text
        super.init(reuseIdentifier: reuseIdentifier)
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Methods

    public func setup() {
        setupLayout()

        backgroundConfiguration = .clear()
        backgroundConfiguration?.backgroundColor = PlomeColor.background.color
    }

    private func setupLayout() {
        titleLabel.stretchInView(parentView: contentView,
                                 edges: .init(top: AppStyles.defaultSpacing(factor: 0.5),
                                              left: AppStyles.defaultSpacing,
                                              bottom: AppStyles.defaultSpacing(factor: 0.5),
                                              right: 0))
    }
}
