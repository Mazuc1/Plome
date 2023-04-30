//
//  ExamTypePageViewModel.swift
//  Plome
//
//  Created by Loic Mazuc on 30/04/2023.
//

import Foundation
import PlomeCoreKit

final class ExamTypePageViewModel {
    // MARK: - Properties
    
    let simulation: Simulation
    
    lazy var examSectionsName: [String] = {
        var sectionsName: [String] = []
        
        simulation.examsContainTrials() ? sectionsName.append(PlomeCoreKit.L10n.trialsType) : doNothing()
        simulation.examsContainContinuousControls() ? sectionsName.append(PlomeCoreKit.L10n.continuousControlsType) : doNothing()
        simulation.examsContainOptions() ? sectionsName.append(PlomeCoreKit.L10n.optionsType) : doNothing()
        
        return sectionsName
    }()
    
    // MARK: - Init
    
    init(simulation: Simulation) {
        self.simulation = simulation
    }
    
    // MARK: - Methods
    
}
