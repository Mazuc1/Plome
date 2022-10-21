//
//  SimulationCell.swift
//  Plome
//
//  Created by Loic Mazuc on 21/10/2022.
//

import UIKit
import PlomeCoreKit

final class SimulationCell: UITableViewCell {
    
    // MARK: - Properties
    
    static let reuseIdentifier: String = "SimulationCell"
    
    // MARK: - UI
    
    private var labelSimulationName: UILabel = UILabel().configure {
        $0.font = PlomeFont.demiBoldL.font
        $0.numberOfLines = 1
        $0.textAlignment = .left
        $0.textColor = PlomeColor.darkBlue.color
    }
    
    private var labelTrials: UILabel = UILabel().configure {
        $0.font = PlomeFont.bodyL.font
        $0.textAlignment = .left
        $0.textColor = PlomeColor.darkGray.color
    }
    
    private var labelContinuousControls: UILabel = UILabel().configure {
        $0.font = PlomeFont.bodyL.font
        $0.textAlignment = .left
        $0.textColor = PlomeColor.darkGray.color
    }
    
    private var labelOptions: UILabel = UILabel().configure {
        $0.font = PlomeFont.bodyL.font
        $0.textAlignment = .left
        $0.textColor = PlomeColor.darkGray.color
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
    
    func setup(with simulation: Simulation) {
        setupLayout()
        
        labelSimulationName.text = simulation.name
        labelTrials.text = "\(simulation.number(of: .trial)) Epreuve(s)"
        labelContinuousControls.text = "\(simulation.number(of: .continuousControl)) Contrôle(s) continue"
        labelOptions.text = "\(simulation.number(of: .option)) Option(s)"
                
        backgroundColor = .clear
        selectionStyle = .none
    }
    
    private func setupLayout() {
        stackView.stretchInView(parentView: contentView)
        stackView.addArrangedSubviews([labelSimulationName, labelTrials, labelContinuousControls, labelOptions])
        
        stackView.layoutMargins = .init(top: AppStyles.defaultSpacing,
                                        left: AppStyles.defaultSpacing,
                                        bottom: AppStyles.defaultSpacing,
                                        right: AppStyles.defaultSpacing)
        
        NSLayoutConstraint.activate([
            contentView.bottomAnchor.constraint(equalTo: stackView.bottomAnchor, constant: AppStyles.defaultSpacing),
        ])
    }
}
