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

    let viewModel: AddSimulationModelViewModel
    var cancellables: Set<AnyCancellable> = .init()

    static let numberOfAddExamRowInSection: Int = 1

    enum AddSimulationModelSection: Int, CaseIterable {
        case trial = 0
        case continuousControl = 1
        case option = 2

        var sectionTitle: String {
            switch self {
            case .trial: return "Épreuve(s)"
            case .continuousControl: return "Contrôle(s) continue"
            case .option: return "Option(s)"
            }
        }
    }

    // MARK: - UI

    lazy var tableView = UITableView(frame: .zero, style: .grouped).configure { [weak self] in
        $0.delegate = self
        $0.dataSource = self
        $0.backgroundColor = .clear
        $0.separatorStyle = .none
        $0.showsVerticalScrollIndicator = false
        $0.register(AddExamCell.self, forCellReuseIdentifier: AddExamCell.reuseIdentifier)
        $0.register(ModelExamCell.self, forCellReuseIdentifier: ModelExamCell.reuseIdentifier)
        $0.register(AddSimulationModelHeaderView.self, forHeaderFooterViewReuseIdentifier: AddSimulationModelHeaderView.reuseIdentifier)
        $0.translatesAutoresizingMaskIntoConstraints = false
    }

    lazy var primaryCTARegisterModel: PrimaryCTA = .init(title: "Enregistrer").configure { [weak self] in
        $0.addTarget(self, action: #selector(userDidTapSaveSimulationModel), for: .touchUpInside)
        $0.translatesAutoresizingMaskIntoConstraints = false
    }

    lazy var textFieldTitle: UITextField = .init().configure { [weak self] in
        $0.delegate = self
        $0.placeholder = "Bac Pro..."
        $0.returnKeyType = .done
        $0.textAlignment = .center
        $0.font = PlomeFont.demiBoldM.font
        $0.textColor = PlomeColor.darkBlue.color
    }

    lazy var buttonClose: UIBarButtonItem = .init().configure { [weak self] in
        $0.target = self
        $0.style = .plain
        $0.action = #selector(self?.userDidTapCloseButton)
        $0.image = Icons.xmark.configure(weight: .regular, color: .pink, size: 20)
    }

    lazy var buttonEditTitle: UIBarButtonItem = .init().configure { [weak self] in
        $0.target = self
        $0.style = .plain
        $0.action = #selector(self?.userDidTapEditTitleButton)
        $0.image = Icons.pencil.configure(weight: .regular, color: .pink, size: 20)
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
    }

    // MARK: - Methods

    private func setupConstraint() {
        view.addSubview(primaryCTARegisterModel)

        NSLayoutConstraint.activate([
            primaryCTARegisterModel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: AppStyles.defaultSpacing(factor: 3)),
            view.safeAreaLayoutGuide.bottomAnchor.constraint(equalTo: primaryCTARegisterModel.bottomAnchor, constant: AppStyles.defaultSpacing(factor: 1)),
            view.trailingAnchor.constraint(equalTo: primaryCTARegisterModel.trailingAnchor, constant: AppStyles.defaultSpacing(factor: 3)),
            primaryCTARegisterModel.heightAnchor.constraint(equalToConstant: AppStyles.primaryCTAHeight),
        ])

        view.addSubview(tableView)

        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 0),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: AppStyles.defaultSpacing(factor: 3)),
            view.trailingAnchor.constraint(equalTo: tableView.trailingAnchor, constant: AppStyles.defaultSpacing(factor: 3)),
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
        AddSimulationModelSection.allCases.count
    }

    func tableView(_: UITableView, numberOfRowsInSection section: Int) -> Int {
        var numberOfRows: Int = Self.numberOfAddExamRowInSection

        switch section {
        case 0: numberOfRows += viewModel.trials.count
        case 1: numberOfRows += viewModel.continousControls.count
        case 2: numberOfRows += viewModel.options.count
        default: return 0
        }

        return numberOfRows
    }

    func tableView(_: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let sectionName = AddSimulationModelSection(rawValue: section)?.sectionTitle else { return nil }
        return AddSimulationModelHeaderView(text: sectionName, reuseIdentifier: AddSimulationModelHeaderView.reuseIdentifier)
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            if let cell = tableView.dequeueReusableCell(withIdentifier: AddExamCell.reuseIdentifier) as? AddExamCell {
                cell.setup()
                return cell
            }
        } else {
            if let cell = tableView.dequeueReusableCell(withIdentifier: ModelExamCell.reuseIdentifier) as? ModelExamCell,
               let exam = exam(for: indexPath)
            {
                cell.setup(exam: exam)
                return cell
            }
        }

        return UITableViewCell()
    }

    // `indexPath.row - 1` avoid crashes when attemps to access wrong index in array
    // Because of we had first a custom cell to add exam, when `cellForRowAt` will fetch exams in viewModel
    // indexPath will already be at 1, and skip the first item of arrays
    private func exam(for indexPath: IndexPath) -> Exam? {
        switch indexPath.section {
        case 0: return viewModel.trials[indexPath.row - 1]
        case 1: return viewModel.continousControls[indexPath.row - 1]
        case 2: return viewModel.options[indexPath.row - 1]
        default: return nil
        }
    }
}

// MARK: - Table View Delegate

extension AddSimulationModelViewController: UITableViewDelegate {
    func tableView(_: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            var section: AddSimulationModelSection = .option

            switch indexPath.section {
            case 0: section = .trial
            case 1: section = .continuousControl
            case 2: section = .option
            default: break
            }

            viewModel.userDidTapAddExam(in: section)
        }
    }

    // Disable edit for AddExamRow
    func tableView(_: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        if indexPath.row == 0 { return false }
        return true
    }

    // `indexPath.row - 1` avoid crashes when attemps to access wrong index in array
    // Because of we had first a custom cell to add exam, when `cellForRowAt` will fetch exams in viewModel
    // indexPath will already be at 1, and skip the first item of arrays
    func tableView(_: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive, title: nil) { [weak self] _, _, completion in
            var section: AddSimulationModelSection = .option

            switch indexPath.section {
            case 0: section = .trial
            case 1: section = .continuousControl
            case 2: section = .option
            default: break
            }

            self?.viewModel.userDidTapDeleteExam(at: indexPath.row - 1, in: section)

            completion(true)
        }

        deleteAction.image = Icons.trash.configure(weight: .regular, color: .fail, size: 25)
        deleteAction.backgroundColor = PlomeColor.background.color
        let configuration = UISwipeActionsConfiguration(actions: [deleteAction])
        return configuration
    }
}

// MARK: - Table View Delegate

extension AddSimulationModelViewController: UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField) {
        if let text = textField.text,
           !text.isEmpty
        {
            viewModel.simulationName = text
        } else {
            textField.text = "Nouveau modèle"
        }
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
