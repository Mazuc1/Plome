//
//  SimulationDetailsViewController.swift
//  Plome
//
//  Created by Loic Mazuc on 24/11/2022.
//

import PlomeCoreKit
import UIKit

class SimulationDetailsViewController: AppViewController {
    // MARK: - Properties

    let viewModel: SimulationDetailsViewModel

    // MARK: - UI

    // MARK: - Init

    required init(viewModel: SimulationDetailsViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)

        hidesBottomBarWhenPushed = true
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Life cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = viewModel.simulation.name

        setupLayout()
    }

    // MARK: - Methods

    private func setupLayout() {}
}
