//
//  OnboardingViewController.swift
//  Plome
//
//  Created by Loic Mazuc on 16/12/2022.
//

import PlomeCoreKit
import UIKit

class OnboardingViewController: AppViewController {
    // MARK: - Properties

    private let viewModel: OnboardingViewModel

    // MARK: - Init

    required init(viewModel: OnboardingViewModel) {
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
