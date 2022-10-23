//
//  AddExamCell.swift
//  Plome
//
//  Created by Loic Mazuc on 21/10/2022.
//

import UIKit
import PlomeCoreKit

final class AddExamCell: UITableViewCell {

    // MARK: - Properties
    
    static let reuseIdentifier: String = "AddExamCell"
    private static let icon = Icons.add
    
    // MARK: - UI
    
    var iconImageView: UIImageView = UIImageView().configure {
        let imageWeightConfiguration = UIImage.SymbolConfiguration(weight: .regular)
        let imageColorConfiguration = UIImage.SymbolConfiguration(paletteColors: [PlomeColor.pink.color])
        let imageSizeConfiguration = UIImage.SymbolConfiguration(pointSize: 25)
        
        let imageWeightAndColorConfiguration = imageWeightConfiguration.applying(imageColorConfiguration)
        let imageFinalConfiguration = imageWeightAndColorConfiguration.applying(imageSizeConfiguration)
        
        $0.image = UIImage(systemName: icon.name, withConfiguration: imageFinalConfiguration)
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
        contentView.backgroundColor = PlomeColor.pink.color.withAlphaComponent(0.2)
        contentView.layer.cornerRadius = AppStyles.defaultRadius
        
        backgroundColor = .clear
        selectionStyle = .none
    }
    
    private func setupLayout() {
        contentView.addSubview(iconImageView)
        
        NSLayoutConstraint.activate([
            contentView.heightAnchor.constraint(equalToConstant: AppStyles.secondaryIconCTAHeight),
            iconImageView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            iconImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
        ])
    }
}
