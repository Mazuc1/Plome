//
//  SimulationTableViewDataSource.swift
//  Plome
//
//  Created by Loic Mazuc on 01/06/2023.
//

import PlomeCoreKit
import UIKit

enum SimulationItem: Hashable {
    case `default`(Simulation)
    case draft(Simulation)
}

enum SimulationSection: Int {
    case `default` = 0
    case draft = 1

    var sectionTitle: String? {
        switch self {
        case .default: return L10n.Home.yourSimulations
        case .draft: return L10n.Home.yourDrafts
        }
    }
}

class SimulationTableViewDataSource: UITableViewDiffableDataSource<SimulationSection, SimulationItem> {
    override func tableView(_: UITableView, titleForHeaderInSection section: Int) -> String? {
        return snapshot().sectionIdentifiers[safe: section]?.sectionTitle
    }
}
