//
//  ExamTypeHeaderView.swift
//  Plome
//
//  Created by Loic Mazuc on 21/10/2022.
//

import UIKit

public enum ExamTypeSection: Int, CaseIterable {
    case trial = 0
    case continuousControl = 1
    case option = 2

    public var title: String {
        switch self {
        case .trial: return "Épreuve"
        case .continuousControl: return "Contrôle continue"
        case .option: return "Option"
        }
    }
}

public protocol ExamTypeHeaderViewOutput: AnyObject {
    func userDidTapAddExam(for section: ExamTypeSection)
}

public final class ExamTypeHeaderView: UITableViewHeaderFooterView {
    // MARK: - Properties

    public static let reuseIdentifier: String = "ExamTypeHeaderView"
    private let section: ExamTypeSection

    public weak var examTypeHeaderViewOutput: ExamTypeHeaderViewOutput?

    // MARK: - UI

    private var titleLabel: UILabel = .init().configure {
        $0.font = PlomeFont.demiBoldL.font
        $0.textColor = PlomeColor.darkGray.color
        $0.textAlignment = .left
        $0.numberOfLines = 1
        $0.translatesAutoresizingMaskIntoConstraints = false
    }

    private var addButton: UIButton = .init().configure {
        $0.setBackgroundImage(Icons.add.configure(weight: .regular, color: .pink, size: 23), for: .normal)
    }

    private var stackView: UIStackView = .init().configure {
        $0.axis = .horizontal
        $0.alignment = .leading
        $0.distribution = .equalSpacing
        $0.spacing = AppStyles.defaultSpacing(factor: 0.5)
        $0.backgroundColor = .clear
        $0.layer.cornerRadius = AppStyles.defaultRadius
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.isLayoutMarginsRelativeArrangement = true
    }

    // MARK: - Init

    public required init(section: ExamTypeSection, reuseIdentifier: String?) {
        self.section = section
        super.init(reuseIdentifier: reuseIdentifier)
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Methods

    public func setup() {
        setupLayout()
        titleLabel.text = section.title

        addButton.addTarget(self, action: #selector(userDidTapAddExam), for: .touchUpInside)
    }

    private func setupLayout() {
        stackView.addArrangedSubviews([titleLabel, UIView(), addButton])
        stackView.stretchInView(parentView: contentView)

        NSLayoutConstraint.activate([
            stackView.heightAnchor.constraint(equalToConstant: 30),
        ])
    }

    @objc private func userDidTapAddExam() {
        examTypeHeaderViewOutput?.userDidTapAddExam(for: section)
    }
}
