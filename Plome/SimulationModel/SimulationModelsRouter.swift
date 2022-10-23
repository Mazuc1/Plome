//
//  SimulationModelsRouter.swift
//  Plome
//
//  Created by Loic Mazuc on 21/10/2022.
//

import Foundation
import PlomeCoreKit
import UIKit

final class SimulationModelsRouter: DefaultRouter {
    // MARK: - Properties

    let screens: Screens
    
    // MARK: - Init

    init(screens: Screens, rootTransition: Transition) {
        self.screens = screens
        super.init(rootTransition: rootTransition)
    }
    
    // MARK: - Methods

    func makeRootViewController() -> UIViewController {
        let router = SimulationModelsRouter(screens: screens, rootTransition: EmptyTransition())
        let simulationModelsViewController = screens.createSimulationModelsTab(router: router)
        router.rootViewController = simulationModelsViewController

        return simulationModelsViewController
    }
    
    func openAddSimulationModel() {
        let transition = ModalTransition()
        let router = SimulationModelsRouter(screens: screens, rootTransition: transition)
        let addSimulationViewController = screens.createAddSimulationModel(router: router)
        router.rootViewController = addSimulationViewController

        route(to: addSimulationViewController, as: transition)
    }
    
    func openAddExamAlert(saveAction: @escaping (String) -> Void) {
        let alertController = UIAlertController(title: "Nouveau", message: "Ajoutez votre examen", preferredStyle: .alert)
        
        alertController.addTextField { $0.placeholder = "Mathématiques..." }
        alertController.addAction(UIAlertAction(title: "Annuler", style: .cancel))
        alertController.addAction(UIAlertAction(title: "Ajouter", style: .default, handler: { _ in
            guard let examName = alertController.textFields?[0].text,
            !examName.isEmpty else { return }
            saveAction(examName)
        }))
        
        alertController.view.tintColor = PlomeColor.pink.color
        rootViewController?.present(alertController, animated: true)
    }
}
