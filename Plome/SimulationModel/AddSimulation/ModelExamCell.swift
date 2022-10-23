//
//  ModelExamCell.swift
//  Plome
//
//  Created by Loic Mazuc on 23/10/2022.
//

import UIKit
import PlomeCoreKit

final class ModelExamCell: UITableViewCell {

    // MARK: - Properties
    
    static let reuseIdentifier: String = "ModelExamCell"
    static let modelExamCellHeight: CGFloat = 40
    
    // MARK: - UI
    
    private var labelExamName: UILabel = UILabel().configure {
        $0.font = PlomeFont.bodyL.font
        $0.textColor = PlomeColor.darkBlue.color
        $0.textAlignment = .left
        $0.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private var stackView: UIStackView = UIStackView().configure {
        $0.axis = .vertical
        $0.alignment = .leading
        $0.distribution = .equalSpacing
        $0.spacing = AppStyles.defaultSpacing(factor: 0.5)
        $0.backgroundColor = .white
        $0.layer.cornerRadius = AppStyles.defaultRadius
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.isLayoutMarginsRelativeArrangement = true
    }
    
    // MARK: - Init
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    // MARK: - Methods
    
    func setup(exam: Exam) {
        setupLayout()
        
        labelExamName.text = exam.name
        
        backgroundColor = .clear
        selectionStyle = .none
    }
    
    private func setupLayout() {
        contentView.addSubview(stackView)
        stackView.addArrangedSubviews([labelExamName])
        
        NSLayoutConstraint.activate([
            stackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: 0),
            stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 0),
            stackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: AppStyles.defaultSpacing),
            stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: 0),
            stackView.heightAnchor.constraint(equalToConstant: Self.modelExamCellHeight),
        ])
        
        stackView.layoutMargins = .init(top: AppStyles.defaultSpacing,
                                        left: AppStyles.defaultSpacing,
                                        bottom: AppStyles.defaultSpacing,
                                        right: AppStyles.defaultSpacing)
    }

}
