//
//  SimulationViewController.swift
//  Plome
//
//  Created by Loic Mazuc on 31/10/2022.
//

import Combine
import PlomeCoreKit
import UIKit

protocol SimulationViewControllerOutput: AnyObject {
    func reloadTableView()
}

final class SimulationViewController: AppViewController {
    // MARK: - Properties

    private let viewModel: SimulationViewModel
    private var cancellables: Set<AnyCancellable> = .init()

    // MARK: - UI

    private lazy var tableView = UITableView(frame: .zero, style: .plain).configure { [weak self] in
        $0.delegate = self
        $0.dataSource = self
        $0.backgroundColor = .clear
        $0.separatorStyle = .none
        $0.showsVerticalScrollIndicator = false
        $0.register(ExamTypeHeaderView.self, forHeaderFooterViewReuseIdentifier: ExamTypeHeaderView.reuseIdentifier)
        $0.register(ExamCell.self, forCellReuseIdentifier: ExamCell.reuseIdentifier)
        $0.translatesAutoresizingMaskIntoConstraints = false
    }

    private lazy var primaryCTACalculate: PrimaryCTA = .init(title: L10n.Home.calculate).configure { [weak self] in
        $0.addTarget(self, action: #selector(userDidTapCalculate), for: .touchUpInside)
        $0.translatesAutoresizingMaskIntoConstraints = false
    }

    // MARK: - Init

    required init(viewModel: SimulationViewModel) {
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
        navigationItem.title = viewModel.simulation.name
        navigationItem.rightBarButtonItem = createInfoBarButton()
        navigationItem.backButtonDisplayMode = .minimal

        setupConstraint()
        subscribeToCapabilityToRunSimulation()
    }

    // MARK: - Methods

    private func setupConstraint() {
        view.addSubview(primaryCTACalculate)

        NSLayoutConstraint.activate([
            primaryCTACalculate.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: AppStyles.defaultSpacing(factor: 2)),
            view.safeAreaLayoutGuide.bottomAnchor.constraint(equalTo: primaryCTACalculate.bottomAnchor),
            view.trailingAnchor.constraint(equalTo: primaryCTACalculate.trailingAnchor, constant: AppStyles.defaultSpacing(factor: 2)),
            primaryCTACalculate.heightAnchor.constraint(equalToConstant: AppStyles.primaryCTAHeight),
        ])

        view.addSubview(tableView)

        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: AppStyles.defaultSpacing),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: AppStyles.defaultSpacing(factor: 2)),
            view.trailingAnchor.constraint(equalTo: tableView.trailingAnchor, constant: AppStyles.defaultSpacing(factor: 2)),
            primaryCTACalculate.topAnchor.constraint(equalTo: tableView.bottomAnchor, constant: AppStyles.defaultSpacing),
        ])
    }

    private func subscribeToCapabilityToRunSimulation() {
        viewModel.$canCalculate
            .receive(on: RunLoop.main)
            .sink { [weak self] in
                self?.primaryCTACalculate.isEnabled = $0
            }
            .store(in: &cancellables)
    }

    private func createInfoBarButton() -> UIBarButtonItem {
        UIBarButtonItem(image: Icons.info.configure(weight: .regular, color: .lagoon, size: 20), style: .plain, target: self, action: #selector(userDidTapInfo))
    }

    @objc private func userDidTapInfo() {
        let alertController = UIAlertController(title: L10n.Home.howToCompleteSimulation,
                                                message: L10n.Home.simulationRules,
                                                preferredStyle: .actionSheet)
        alertController.addAction(UIAlertAction(title: PlomeCoreKit.L10n.General.ok, style: .cancel))
        alertController.view.tintColor = PlomeColor.lagoon.color

        present(alertController, animated: true)
    }

    @objc private func userDidTapCalculate() {
        viewModel.userDidTapCalculate()
    }
}

// MARK: - Table view data source

extension SimulationViewController: UITableViewDataSource {
    func numberOfSections(in _: UITableView) -> Int {
        ExamTypeSection.allCases.count
    }

    func tableView(_: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0: return viewModel.simulation.number(of: .trial)
        case 1: return viewModel.simulation.number(of: .continuousControl)
        case 2: return viewModel.simulation.number(of: .option)
        default: return 0
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: ExamCell.reuseIdentifier) as? ExamCell {
            switch indexPath.section {
            case 0: cell.setup(exam: viewModel.simulation.exams(of: .trial)[indexPath.row])
            case 1: cell.setup(exam: viewModel.simulation.exams(of: .continuousControl)[indexPath.row])
            case 2: cell.setup(exam: viewModel.simulation.exams(of: .option)[indexPath.row])
            default: break
            }
            cell.simulationViewModelInput = viewModel
            return cell
        }
        return UITableViewCell()
    }
}

// MARK: -  UITableViewDelegate

extension SimulationViewController: UITableViewDelegate {
    func tableView(_: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let section = ExamTypeSection(rawValue: section) else { return nil }
        let simulationHeaderView = ExamTypeHeaderView(section: section, reuseIdentifier: ExamTypeHeaderView.reuseIdentifier)
        simulationHeaderView.setup()
        return simulationHeaderView
    }
}

// MARK: -  SimulationViewControllerOutput

extension SimulationViewController: SimulationViewControllerOutput {
    func reloadTableView() {
        tableView.reloadData()
    }
}
