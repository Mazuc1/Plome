//
//  AddSimulationModelViewController.swift
//  Plome
//
//  Created by Loic Mazuc on 21/10/2022.
//

import UIKit
import PlomeCoreKit

final class AddSimulationModelViewController: AppViewController {

    // MARK: - Properties
    
    let viewModel: AddSimulationModelViewModel

    // MARK: - UI
    
    
    // MARK: - Init
    
    required init(viewModel: AddSimulationModelViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Nouveau modèle"
    }
    
    // MARK: - Methods
    
    private func setupConstraint() {
       
    }
}
