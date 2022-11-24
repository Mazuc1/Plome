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

    private var widthWithoutMargin: CGFloat = 100

    // MARK: - UI

    private let scrollViewContainerStackView: UIStackView = .init().configure {
        $0.axis = .vertical
        $0.distribution = .fill
        $0.spacing = AppStyles.defaultSpacing(factor: 2)
        $0.alignment = .center
        $0.isLayoutMarginsRelativeArrangement = true
        $0.layoutMargins = .init(top: AppStyles.defaultSpacing(factor: 2),
                                 left: AppStyles.defaultSpacing(factor: 2),
                                 bottom: AppStyles.defaultSpacing(factor: 2),
                                 right: AppStyles.defaultSpacing(factor: 2))
    }

    private let scrollView: UIScrollView = .init().configure {
        $0.showsVerticalScrollIndicator = false
        $0.translatesAutoresizingMaskIntoConstraints = false
    }

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
        widthWithoutMargin = view.frame.width - AppStyles.defaultSpacing(factor: 4)
        setupLayout()
    }

    // MARK: - Methods

    private func setupLayout() {
        let detailsHeaderView = createDetailsHeaderView()
        scrollViewContainerStackView.addArrangedSubviews([detailsHeaderView])

        scrollViewContainerStackView.stretchInView(parentView: scrollView)

        view.addSubview(scrollView)

        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            view.safeAreaLayoutGuide.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            view.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            scrollViewContainerStackView.widthAnchor.constraint(equalToConstant: view.frame.width),
            detailsHeaderView.widthAnchor.constraint(equalToConstant: widthWithoutMargin),
        ])
    }

    private func createDetailsHeaderView() -> UIView {
        DetailsHeaderView(frame: .zero,
                          date: viewModel.date(),
                          admission: viewModel.admissionSentence(),
                          isAdmitted: viewModel.hasSucceedExam(),
                          mention: viewModel.mention())
    }
}
