//
//  AddSimulationModelViewModel.swift
//  Plome
//
//  Created by Loic Mazuc on 21/10/2022.
//

import Foundation

final class AddSimulationModelViewModel {
    // MARK: - Properties
    
    let router: SimulationModelsRouter
    
    // MARK: - Init
    
    init(router: SimulationModelsRouter) {
        self.router = router
    }
    
    // MARK: - Methods
    
    func userDidTapAddExam(in section: AddSimulationModelViewController.AddSimulationModelSection) {
        router.openAddExamAlert {
            print("🫑", $0)
        }
    }
}
