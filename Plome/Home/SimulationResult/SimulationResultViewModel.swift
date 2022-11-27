//
//  SimulationResultViewModel.swift
//  Plome
//
//  Created by Loic Mazuc on 10/11/2022.
//

import CoreData
import Foundation
import PlomeCoreKit
import UIKit

final class SimulationResultViewModel {
    // MARK: - Properties

    private let router: SimulationsRouter
    private let simulationRepository: CoreDataRepository<CDSimulation>

    private let calculator: Calculator
    let simulation: Simulation
    let shaper: CalculatorShaper

    enum Save {
        case simulation
        case simulationModel
    }

    // MARK: - Init

    init(router: SimulationsRouter, simulation: Simulation, simulationRepository: CoreDataRepository<CDSimulation>) {
        self.router = router
        self.simulation = simulation
        self.simulationRepository = simulationRepository

        calculator = .init(simulation: simulation)
        calculator.calculate()

        shaper = CalculatorShaper(calculator: calculator)
    }

    // MARK: - Methods

    func userDidTapRemakeSimulate() {
        router.popViewController()
    }

    func userDidTapBackToHome() {
        router.popToRootViewController()
    }

    func save(_ type: Save) {
        let _mergeAndConvertExams = mergeAndConvertExams
        do {
            try simulationRepository.add { [simulation] cdSimulation, context in
                cdSimulation.name = simulation.name
                cdSimulation.exams = _mergeAndConvertExams(context, cdSimulation)
                cdSimulation.type = simulation.type

                switch type {
                case .simulation: cdSimulation.date = Date()
                case .simulationModel: cdSimulation.date = nil
                }
            }

            if type == .simulationModel {
                router.alert(title: "C'est fait !", message: "Le modèle à bien été enregistrer")
            }
        } catch {
            router.alert(title: "Oups", message: "Une erreur est survenue 😕")
        }
    }

    private func mergeAndConvertExams(in context: NSManagedObjectContext, for simulation: CDSimulation) -> Set<CDExam>? {
        guard let exams = self.simulation.exams else { return nil }
        var cdExams: Set<CDExam> = .init()

        _ = exams.map { cdExams.insert($0.toCoreDataModel(in: context, for: simulation)) }

        return cdExams
    }

    func userDidTapShareResult(screenshot: UIImage) {
        guard let url = screenshot.url(name: "Ma simulation") else {
            router.alert(title: "Oups...", message: "Impossible de partager.")
            return
        }
        router.openActivityController(with: [url])
    }
}
