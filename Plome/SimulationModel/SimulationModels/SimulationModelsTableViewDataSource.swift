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

final class SimulationModelsTableViewDataSource: UITableViewDiffableDataSource<SimulationModelsSection, Simulation> {
    override func tableView(_: UITableView, titleForHeaderInSection section: Int) -> String? {
        return snapshot().sectionIdentifiers[safe: section]?.sectionTitle
    }

    // Disable edit for default models
    override func tableView(_: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        if indexPath.section == 0 { return false }
        return true
    }
}
