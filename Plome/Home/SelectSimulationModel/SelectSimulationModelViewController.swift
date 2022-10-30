//
//  SelectSimulationModelViewController.swift
//  Plome
//
//  Created by Loic Mazuc on 30/10/2022.
//

import PlomeCoreKit
import UIKit

final class SelectSimulationModelViewController: AppViewController {
    // MARK: - Properties

    let viewModel: SelectSimulationModelViewModel

    // MARK: - Init

    required init(viewModel: SelectSimulationModelViewModel) {
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
