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

    // MARK: - UI

    private lazy var closeButton: UIBarButtonItem = .init().configure { [weak self] in
        $0.target = self
        $0.style = .plain
        $0.action = #selector(self?.userDidTapCloseButton)
        $0.image = Icons.xmark.configure(weight: .regular, color: .pink, size: 20)
    }

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

        navigationItem.title = "Nouvelle simulation"
        navigationItem.leftBarButtonItem = closeButton
    }

    // MARK: - Methods

    @objc private func userDidTapCloseButton() {
        viewModel.userDidTapCloseButton()
    }
}
