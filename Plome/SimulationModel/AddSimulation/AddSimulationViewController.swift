//
//  AddSimulationViewController.swift
//  Plome
//
//  Created by Loic Mazuc on 21/10/2022.
//

import UIKit
import PlomeCoreKit

final class AddSimulationViewController: AppViewController {

    // MARK: - Properties
    
    let viewModel: AddSimulationViewModel

    // MARK: - UI
    
    
    // MARK: - Init
    
    required init(viewModel: AddSimulationViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    // MARK: - Methods
    
    private func setupConstraint() {
       
    }
}
