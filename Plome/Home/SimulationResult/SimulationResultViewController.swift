//
//  SimulationResultViewController.swift
//  Plome
//
//  Created by Loic Mazuc on 10/11/2022.
//

import PlomeCoreKit
import UIKit

final class SimulationResultViewController: AppViewController {
    // MARK: - Properties

    let viewModel: SimulationResultViewModel

    // MARK: - UI

    private let labelResult: UILabel = .init().configure {
        $0.font = PlomeFont.demiBoldS.font
        $0.numberOfLines = 0
        $0.textAlignment = .center
        $0.textColor = PlomeColor.darkBlue.color
        $0.translatesAutoresizingMaskIntoConstraints = false
    }

    // MARK: - Init

    required init(viewModel: SimulationResultViewModel) {
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
        navigationItem.title = "Résultat"

        setupLayout()

        labelResult.text = viewModel.calculate()
    }

    // MARK: - Methods

    private func setupLayout() {
        view.addSubview(labelResult)

        NSLayoutConstraint.activate([
            labelResult.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: AppStyles.defaultSpacing(factor: 2)),
            labelResult.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: AppStyles.defaultSpacing(factor: 3)),
            view.trailingAnchor.constraint(equalTo: labelResult.trailingAnchor, constant: AppStyles.defaultSpacing(factor: 3)),
        ])
    }
}
