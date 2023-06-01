//
//  SimulationTableViewDataSource.swift
//  Plome
//
//  Created by Loic Mazuc on 01/06/2023.
//

import UIKit
import PlomeCoreKit

enum SimulationSection {
    case `default`
    case cached
    
    var sectionTitle: String? {
        switch self {
        case .`default`: return "Vos simulations"
        case .cached: return "Vos brouillon"
        }
    }
}

class SimulationTableViewDataSource: UITableViewDiffableDataSource<SimulationSection, Simulation> {
    override func tableView(_: UITableView, titleForHeaderInSection section: Int) -> String? {
        return snapshot().sectionIdentifiers[safe: section]?.sectionTitle
    }
}
