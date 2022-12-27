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
        case .trial: return L10n.trialsType
        case .continuousControl: return L10n.continuousControlsType
        case .option: return L10n.optionsType
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
        $0.textColor = PlomeColor.darkBlue.color
        $0.textAlignment = .left
    }

    private var addButton: UIButton = .init().configure {
        $0.setBackgroundImage(Icons.add.configure(weight: .regular, color: .lightGreen, size: 23), for: .normal)
    }

    private var stackView: UIStackView = .init().configure {
        $0.axis = .horizontal
        $0.alignment = .center
        $0.distribution = .equalSpacing
        $0.spacing = AppStyles.defaultSpacing(factor: 0.5)
        $0.backgroundColor = .clear
        $0.layer.cornerRadius = AppStyles.defaultRadius
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

        backgroundConfiguration = .clear()
        backgroundConfiguration?.backgroundColor = PlomeColor.background.color
    }

    private func setupLayout() {
        stackView.addArrangedSubviews([titleLabel, UIView(), addButton])
        stackView.stretchInView(parentView: contentView)

        stackView.addSeparator(at: .bottom, color: UIColor.lightGray, weight: 0.5)

        stackView.layoutMargins = .init(top: AppStyles.defaultSpacing,
                                        left: AppStyles.defaultSpacing,
                                        bottom: AppStyles.defaultSpacing,
                                        right: AppStyles.defaultSpacing)

        NSLayoutConstraint.activate([
            stackView.heightAnchor.constraint(equalToConstant: 45),
        ])
    }

    @objc private func userDidTapAddExam() {
        examTypeHeaderViewOutput?.userDidTapAddExam(for: section)
    }
}
