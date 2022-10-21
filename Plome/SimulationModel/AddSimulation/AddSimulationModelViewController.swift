//
//  AddSimulationModelViewController.swift
//  Plome
//
//  Created by Loic Mazuc on 21/10/2022.
//

import UIKit
import PlomeCoreKit

final class AddSimulationModelViewController: AppViewController {

    // MARK: - Properties
    
    let viewModel: AddSimulationModelViewModel
    
    private enum AddSimulationModelSection: Int, CaseIterable {
        case trial = 0
        case continuousControl = 1
        case option = 2
        
        var name: String {
            switch self {
            case .trial: return "Épreuve(s)"
            case .continuousControl: return "Contrôle(s) continue"
            case .option: return "Option(s)"
            }
        }
    }

    // MARK: - UI
    
    lazy var tableView = UITableView(frame: .zero, style: .plain).configure { [weak self] in
        $0.delegate = self
        $0.dataSource = self
        $0.backgroundColor = .clear
        $0.separatorStyle = .none
        $0.translatesAutoresizingMaskIntoConstraints = false
    }
    
    lazy var primaryCTARegisterModel: PrimaryCTA = PrimaryCTA(title: "Enregistrer").configure { [weak self] in
        $0.addTarget(self, action: #selector(userDidTapRegisterModel), for: .touchUpInside)
        $0.translatesAutoresizingMaskIntoConstraints = false
    }
    
    // MARK: - Init
    
    required init(viewModel: AddSimulationModelViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Nouveau modèle"
        
        setupConstraint()
    }
    
    // MARK: - Methods
    
    private func setupConstraint() {
        view.addSubview(primaryCTARegisterModel)
        
        NSLayoutConstraint.activate([
            primaryCTARegisterModel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: AppStyles.defaultSpacing(factor: 3)),
            view.safeAreaLayoutGuide.bottomAnchor.constraint(equalTo: primaryCTARegisterModel.bottomAnchor, constant: AppStyles.defaultSpacing(factor: 1)),
            view.trailingAnchor.constraint(equalTo: primaryCTARegisterModel.trailingAnchor, constant: AppStyles.defaultSpacing(factor: 3)),
            primaryCTARegisterModel.heightAnchor.constraint(equalToConstant: PrimaryCTA.height),
        ])
        
        view.addSubview(tableView)
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: AppStyles.defaultSpacing(factor: 3)),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: AppStyles.defaultSpacing(factor: 3)),
            view.trailingAnchor.constraint(equalTo: tableView.trailingAnchor, constant: AppStyles.defaultSpacing(factor: 3)),
            primaryCTARegisterModel.topAnchor.constraint(equalTo: tableView.bottomAnchor, constant: AppStyles.defaultSpacing(factor: 2))
        ])
    }
    
    @objc private func userDidTapRegisterModel() {
        print("🫑")
    }
}

// MARK: - Table View Data Source

extension AddSimulationModelViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        AddSimulationModelSection.allCases.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        AddSimulationModelSection.init(rawValue: section)?.name
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell()
    }
}

// MARK: - Table View Delegate

extension AddSimulationModelViewController: UITableViewDelegate {}
