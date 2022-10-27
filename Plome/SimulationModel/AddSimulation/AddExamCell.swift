//
//  AddExamCell.swift
//  Plome
//
//  Created by Loic Mazuc on 21/10/2022.
//

import PlomeCoreKit
import UIKit

final class AddExamCell: UITableViewCell {
    // MARK: - Properties

    static let reuseIdentifier: String = "AddExamCell"

    // MARK: - UI

    private var iconImageView: UIImageView = .init().configure {
        $0.image = Icons.add.configure(weight: .regular, color: .darkBlue, size: 25)
        $0.translatesAutoresizingMaskIntoConstraints = false
    }

    // MARK: - Init

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    // MARK: - Methods

    func setup() {
        setupLayout()
        contentView.backgroundColor = PlomeColor.darkBlue.color.withAlphaComponent(0.1)
        contentView.layer.cornerRadius = AppStyles.defaultRadius

        backgroundColor = .clear
        selectionStyle = .none
    }

    private func setupLayout() {
        contentView.addSubview(iconImageView)

        NSLayoutConstraint.activate([
            contentView.heightAnchor.constraint(equalToConstant: AppStyles.defaultCellHeight),
            iconImageView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            iconImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
        ])
    }
}
