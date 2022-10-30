//
//  SimulationListViewController.swift
//  Plome
//
//  Created by Loic Mazuc on 09/10/2022.
//

import PlomeCoreKit
import UIKit

final class SimulationListViewController: AppViewController {
    // MARK: - Properties

    private let viewModel: SimulationListViewModel

    // MARK: - UI

    // MARK: - Init

    required init(viewModel: SimulationListViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Life cycle

    override func viewDidLoad() {
        super.viewDidLoad()
    }
}
