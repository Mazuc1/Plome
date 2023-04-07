//
//  AddSimulationModelViewController.swift
//  Plome
//
//  Created by Loic Mazuc on 21/10/2022.
//

import Combine
import PlomeCoreKit
import UIKit

final class AddSimulationModelViewController: AppViewController {
    // MARK: - Properties

    private let viewModel: AddSimulationModelViewModel
    private var cancellables: Set<AnyCancellable> = .init()

    // MARK: - UI

    private lazy var tableView = UITableView(frame: .zero, style: .grouped).configure { [weak self] in
        $0.delegate = self
        $0.dataSource = self
        $0.backgroundColor = .clear
        $0.separatorStyle = .none
        $0.showsVerticalScrollIndicator = false
        $0.estimatedRowHeight = 50
        $0.register(ModelExamCell.self, forCellReuseIdentifier: ModelExamCell.reuseIdentifier)
        $0.register(ExamTypeHeaderView.self, forHeaderFooterViewReuseIdentifier: ExamTypeHeaderView.reuseIdentifier)
        $0.translatesAutoresizingMaskIntoConstraints = false
    }

    private lazy var primaryCTARegisterModel: PrimaryCTA = .init(title: PlomeCoreKit.L10n.General.save).configure { [weak self] in
        $0.addTarget(self, action: #selector(self?.userDidTapSaveSimulationModel), for: .touchUpInside)
        $0.translatesAutoresizingMaskIntoConstraints = false
    }

    private lazy var textFieldTitle: UITextField = .init().configure { [weak self] in
        $0.delegate = self
        $0.placeholder = L10n.SimulationModels.simulationModelPlaceholderName
        $0.returnKeyType = .done
        $0.textAlignment = .center
        $0.font = PlomeFont.demiBoldM.font
        $0.textColor = PlomeColor.darkBlue.color
    }

    private lazy var buttonClose: UIBarButtonItem = .init().configure { [weak self] in
        $0.target = self
        $0.style = .plain
        $0.action = #selector(self?.userDidTapCloseButton)
        $0.image = Icons.xmark.configure(weight: .regular, color: .lagoon, size: 16)
    }

    private lazy var buttonEditTitle: UIBarButtonItem = .init().configure { [weak self] in
        $0.target = self
        $0.style = .plain
        $0.action = #selector(self?.userDidTapEditTitleButton)
        $0.image = Icons.pencil.configure(weight: .regular, color: .lagoon, size: 16)
    }

    // MARK: - Init

    required init(viewModel: AddSimulationModelViewModel) {
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
        textFieldTitle.text = viewModel.simulationName
        navigationItem.titleView = textFieldTitle

        navigationItem.leftBarButtonItem = buttonClose
        navigationItem.rightBarButtonItem = buttonEditTitle

        setupConstraint()

        subscribeToExams()
        subscribeToCanRegister()
    }

    // MARK: - Methods

    private func setupConstraint() {
        view.addSubview(primaryCTARegisterModel)

        NSLayoutConstraint.activate([
            primaryCTARegisterModel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: AppStyles.defaultSpacing(factor: 2)),
            view.safeAreaLayoutGuide.bottomAnchor.constraint(equalTo: primaryCTARegisterModel.bottomAnchor, constant: AppStyles.defaultSpacing(factor: 1)),
            view.trailingAnchor.constraint(equalTo: primaryCTARegisterModel.trailingAnchor, constant: AppStyles.defaultSpacing(factor: 2)),
            primaryCTARegisterModel.heightAnchor.constraint(equalToConstant: AppStyles.primaryCTAHeight),
        ])

        view.addSubview(tableView)

        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: AppStyles.defaultSpacing(factor: 2)),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: AppStyles.defaultSpacing(factor: 2)),
            view.trailingAnchor.constraint(equalTo: tableView.trailingAnchor, constant: AppStyles.defaultSpacing(factor: 2)),
            primaryCTARegisterModel.topAnchor.constraint(equalTo: tableView.bottomAnchor, constant: AppStyles.defaultSpacing(factor: 2)),
        ])
    }

    private func subscribeToExams() {
        viewModel.$trials
            .receive(on: RunLoop.main)
            .sink { [weak self] _ in
                self?.tableView.reloadData()
            }
            .store(in: &cancellables)

        viewModel.$continousControls
            .receive(on: RunLoop.main)
            .sink { [weak self] _ in
                self?.tableView.reloadData()
            }
            .store(in: &cancellables)

        viewModel.$options
            .receive(on: RunLoop.main)
            .sink { [weak self] _ in
                self?.tableView.reloadData()
            }
            .store(in: &cancellables)
    }

    private func subscribeToCanRegister() {
        viewModel.$canRegister
            .receive(on: RunLoop.main)
            .sink { [primaryCTARegisterModel] in
                primaryCTARegisterModel.isEnabled = $0
            }
            .store(in: &cancellables)
    }

    @objc private func userDidTapSaveSimulationModel() {
        viewModel.userDidTapSaveSimulationModel()
    }

    @objc private func userDidTapCloseButton() {
        viewModel.dismiss()
    }

    @objc private func userDidTapEditTitleButton() {
        textFieldTitle.becomeFirstResponder()
    }
}

// MARK: - Table View Data Source

extension AddSimulationModelViewController: UITableViewDataSource {
    func numberOfSections(in _: UITableView) -> Int {
        ExamTypeSection.allCases.count
    }

    func tableView(_: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0: return viewModel.trials.count
        case 1: return viewModel.continousControls.count
        case 2: return viewModel.options.count
        default: return 0
        }
    }

    func tableView(_: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let section = ExamTypeSection(rawValue: section) else { return nil }
        let simulationHeaderView = ExamTypeHeaderView(section: section, reuseIdentifier: ExamTypeHeaderView.reuseIdentifier)
        simulationHeaderView.examTypeHeaderViewOutput = viewModel
        simulationHeaderView.setup()
        return simulationHeaderView
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: ModelExamCell.reuseIdentifier) as? ModelExamCell,
           let exam = viewModel.exam(for: indexPath)
        {
            cell.setup(exam: exam)
            cell.addSimulationModelViewModelInput = viewModel
            return cell
        }

        return UITableViewCell()
    }
}

// MARK: - Table View Delegate

extension AddSimulationModelViewController: UITableViewDelegate {
    func tableView(_: UITableView, canEditRowAt _: IndexPath) -> Bool {
        true
    }

    func tableView(_: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = AppContextualAction.deleteAction { [weak self] in
            self?.viewModel.userDidTapDeleteExam(at: indexPath)
        }
        return UISwipeActionsConfiguration(actions: [deleteAction])
    }
}

// MARK: - UITextFieldDelegate

extension AddSimulationModelViewController: UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField) {
        if let text = textField.text,
           !text.isEmpty
        {
            viewModel.simulationName = text
        } else {
            textField.text = L10n.SimulationModels.newModel
        }
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
