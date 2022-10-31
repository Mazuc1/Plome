//
//  SelectSimulationModelViewController.swift
//  Plome
//
//  Created by Loic Mazuc on 30/10/2022.
//

import Combine
import PlomeCoreKit
import UIKit

final class SelectSimulationModelViewController: AppViewController {
    // MARK: - Properties

    let viewModel: SelectSimulationModelViewModel

    private lazy var dataSource: SimulationModelsTableViewDataSource = self.createDataSource()
    private var cancellables: Set<AnyCancellable> = []

    // MARK: - UI

    private let labelActionDescription: UILabel = .init().configure {
        $0.text = "Sélectionnez un modèle"
        $0.font = PlomeFont.demiBoldS.font
        $0.numberOfLines = 0
        $0.textAlignment = .center
        $0.textColor = PlomeColor.darkBlue.color
        $0.translatesAutoresizingMaskIntoConstraints = false
    }

    private lazy var tableView = UITableView(frame: .zero, style: .grouped).configure { [weak self] in
        $0.delegate = self
        $0.register(SmallSimulationModelCell.self, forCellReuseIdentifier: SmallSimulationModelCell.reuseIdentifier)
        $0.backgroundColor = .clear
        $0.separatorStyle = .none
        $0.translatesAutoresizingMaskIntoConstraints = false
    }

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

        setupLayout()

        bindSnapshot()
        viewModel.updateSnapshot()
    }

    // MARK: - Methods

    private func setupLayout() {
        view.addSubview(labelActionDescription)

        NSLayoutConstraint.activate([
            labelActionDescription.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: AppStyles.defaultSpacing(factor: 2)),
            labelActionDescription.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: AppStyles.defaultSpacing(factor: 3)),
            view.trailingAnchor.constraint(equalTo: labelActionDescription.trailingAnchor, constant: AppStyles.defaultSpacing(factor: 3)),
        ])

        view.addSubview(tableView)

        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: labelActionDescription.bottomAnchor, constant: 0),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: AppStyles.defaultSpacing(factor: 3)),
            view.trailingAnchor.constraint(equalTo: tableView.trailingAnchor, constant: AppStyles.defaultSpacing(factor: 3)),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: AppStyles.defaultSpacing(factor: 2)),
        ])
    }

    private func bindSnapshot() {
        viewModel.$snapshot
            .receive(on: RunLoop.main)
            .sink { [weak self] in
                self?.dataSource.apply($0, animatingDifferences: false, completion: nil)
            }
            .store(in: &cancellables)
    }

    private func createDataSource() -> SimulationModelsTableViewDataSource {
        return .init(tableView: tableView) { tableView, _, itemIdentifier in
            if let cell = tableView.dequeueReusableCell(withIdentifier: SmallSimulationModelCell.reuseIdentifier) as? SmallSimulationModelCell {
                cell.setup(with: itemIdentifier)
                return cell
            }
            return UITableViewCell()
        }
    }

    @objc private func userDidTapCloseButton() {
        viewModel.userDidTapCloseButton()
    }
}

// MARK: - Table View delegate

extension SelectSimulationModelViewController: UITableViewDelegate {
    func tableView(_: UITableView, didSelectRowAt indexPath: IndexPath) {
        viewModel.userDidSelectSimulationModel(at: indexPath)
    }
}
