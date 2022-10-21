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
    
    var secondaryIconCTAAdd: SecondaryIconCTA = SecondaryIconCTA(icon: icon).configure {
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
        
        backgroundColor = .clear
        selectionStyle = .none
    }
    
    private func setupLayout() {
        secondaryIconCTAAdd.stretchInView(parentView: contentView)
        
        NSLayoutConstraint.activate([
            secondaryIconCTAAdd.heightAnchor.constraint(equalToConstant: AppStyles.secondaryIconCTAHeight),
        ])
    }

}
