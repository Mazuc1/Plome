//
//  DestinationsSearchTableViewDataSource.swift
//  Explorer
//
//  Created by Loïc MAZUC on 28/09/2022.
//

import PlomeCoreKit
import UIKit

enum SimulationModelsSection {
    case `default`
    case coreData

    var sectionTitle: String? {
        switch self {
        case .default: return "Modèles par défaut"
        case .coreData: return "Vos modèle(s)"
        }
    }
}

class SimulationModelsTableViewDataSource: UITableViewDiffableDataSource<SimulationModelsSection, Simulation> {
    override func tableView(_: UITableView, titleForHeaderInSection section: Int) -> String? {
        return snapshot().sectionIdentifiers[safe: section]?.sectionTitle
    }
}
