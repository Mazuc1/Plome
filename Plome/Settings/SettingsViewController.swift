//
//  SettingsViewController.swift
//  Plome
//
//  Created by Loic Mazuc on 09/10/2022.
//

import PlomeCoreKit
import UIKit

struct SettingsSection {
    var title: String
    var footer: String? = nil
    var cells: [SettingsItem]
}

struct SettingsItem {
    var createdCell: () -> UITableViewCell
    var action: (() -> Void)?
}

final class SettingsViewController: AppViewController {
    // MARK: - Properties

    private let viewModel: SettingsViewModel

    private var tableViewSections = [SettingsSection]()
    static let reuseIdentifier = "SettingsCell"

    // MARK: - UI

    private lazy var tableView = UITableView(frame: .zero, style: .insetGrouped).configure { [weak self] in
        $0.delegate = self
        $0.dataSource = self
        $0.backgroundColor = .clear
        $0.showsVerticalScrollIndicator = false
        $0.translatesAutoresizingMaskIntoConstraints = false
    }

    // MARK: - Init

    required init(viewModel: SettingsViewModel) {
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
        navigationItem.title = "Réglages"

        setupLayout()
        configureDatasource()
    }

    // MARK: - Methods

    private func setupLayout() {
        tableView.stretchInView(parentView: view)
    }

    private func configureDatasource() {
        let generalSection = SettingsSection(title: "Général", cells: [
            SettingsItem(createdCell: {
                let cell = UITableViewCell(style: .value1, reuseIdentifier: Self.reuseIdentifier)
                cell.textLabel?.text = "Ajouter les modèles par défaut"
                cell.textLabel?.font = PlomeFont.bodyM.font
                cell.imageView?.image = Icons.addRectangleStack.configure(weight: .light, color: .black, size: 20)
                cell.selectionStyle = .none
                return cell
            }, action: { [weak self] in
                self?.viewModel.userDidTapAddDefaultSimulationModel()
            }),

            SettingsItem(createdCell: {
                let cell = UITableViewCell(style: .value1, reuseIdentifier: Self.reuseIdentifier)
                cell.textLabel?.text = "Supprimer les simulations"
                cell.textLabel?.font = PlomeFont.bodyM.font
                cell.imageView?.image = Icons.trash.configure(weight: .light, color: .black, size: 20)
                cell.selectionStyle = .none
                return cell
            }, action: { [weak self] in
                self?.viewModel.userDidTapDeleteSimulations()
            }),
        ])

        let otherSection = SettingsSection(title: "Autres", cells: [
            SettingsItem(createdCell: {
                let cell = UITableViewCell(style: .value1, reuseIdentifier: Self.reuseIdentifier)
                cell.textLabel?.text = "Contacter l'assistance"
                cell.textLabel?.font = PlomeFont.bodyM.font
                cell.imageView?.image = Icons.envelope.configure(weight: .light, color: .black, size: 20)
                cell.selectionStyle = .none
                return cell
            }, action: { [weak self] in
                self?.viewModel.userDidTapContactAssistance()
            }),
        ])

        let reinitializeSection = SettingsSection(title: "", footer: viewModel.getVersion(), cells: [
            SettingsItem(createdCell: {
                let cell = UITableViewCell(style: .value1, reuseIdentifier: Self.reuseIdentifier)
                cell.textLabel?.text = "Réinitialiser l'application"
                cell.textLabel?.font = PlomeFont.bodyM.font
                cell.textLabel?.textColor = PlomeColor.fail.color
                cell.selectionStyle = .none
                return cell
            }, action: { [weak self] in
                self?.viewModel.userDidTapReinitializeApplication()
            }),
        ])

        tableViewSections = [generalSection, otherSection, reinitializeSection]
        tableView.reloadData()
    }
}

// MARK: - Table view Data source

extension SettingsViewController: UITableViewDataSource {
    func tableView(_: UITableView, numberOfRowsInSection section: Int) -> Int {
        tableViewSections[section].cells.count
    }

    func tableView(_: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableViewSections[indexPath.section].cells[indexPath.row]
        return cell.createdCell()
    }

    func numberOfSections(in _: UITableView) -> Int {
        tableViewSections.count
    }

    func tableView(_: UITableView, titleForHeaderInSection section: Int) -> String? {
        tableViewSections[section].title
    }

    func tableView(_: UITableView, titleForFooterInSection section: Int) -> String? {
        tableViewSections[section].footer
    }
}

// MARK: - Table view Delegate

extension SettingsViewController: UITableViewDelegate {
    func tableView(_: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableViewSections[indexPath.section].cells[indexPath.row]
        cell.action?()
    }
}
