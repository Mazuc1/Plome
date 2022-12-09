//
//  DefaultSimulationModelsProvider.swift
//  PlomeCoreKit
//
//  Created by Loic Mazuc on 14/10/2022.
//

import CoreData
import Foundation

public final class DefaultSimulationModelsProvider {
    // MARK: - Properties

    public lazy var simulations: [Simulation] = {
        [
            buildBrevetSimluationModel(),
            buildGeneralBACSimluationModel(),
            buildTechnologicalBACSimluationModel(),
        ]
    }()

    // MARK: - Init

    public init() {}

    // MARK: - Methods

    private func buildBrevetSimluationModel() -> Simulation {
        let examsSet = Set(BrevetExamsProvider.allExams().map { $0 })
        return Simulation(name: L10n.brevet, date: nil, exams: examsSet, type: .brevet)
    }

    private func buildGeneralBACSimluationModel() -> Simulation {
        let examsSet = Set(GeneralBACExamsProvider.allExams().map { $0 })
        return Simulation(name: L10n.generalBAC, date: nil, exams: examsSet, type: .generalBAC)
    }

    private func buildTechnologicalBACSimluationModel() -> Simulation {
        let examsSet = Set(TechnologicalBACExamsProvider.allExams().map { $0 })
        return Simulation(name: L10n.technologicalBAC, date: nil, exams: examsSet, type: .technologicalBAC)
    }
}
