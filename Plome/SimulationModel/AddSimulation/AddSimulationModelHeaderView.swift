//
//  AddSimulationModelHeaderView.swift
//  Plome
//
//  Created by Loic Mazuc on 21/10/2022.
//

import UIKit
import PlomeCoreKit

final class AddSimulationModelHeaderView: UITableViewHeaderFooterView {
    
    // MARK: - Properties
    
    static let reuseIdentifier: String = "AddSimulationModelHeaderView"
    
    // MARK: - Init
    
    required init(text: String, reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        
        textLabel?.text = text.uppercased()
        textLabel?.font = PlomeFont.bodyS.font
        textLabel?.textColor = PlomeColor.darkGray.color
    }

    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Methods

    override func layoutSubviews() {
        super.layoutSubviews()

        textLabel?.font = PlomeFont.bodyS.font
        textLabel?.textColor = PlomeColor.darkGray.color
        textLabel?.sizeToFit()
    }

}
