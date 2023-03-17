//
//  SimulationResultViewModel.swift
//  Plome
//
//  Created by Loic Mazuc on 10/11/2022.
//

import CoreData
import Dependencies
import Foundation
import PlomeCoreKit
import UIKit

final class SimulationResultViewModel {
    // MARK: - Properties

    private let router: SimulationsRouter
    @Dependency(\.coreDataSimulationRepository) private var simulationRepository

    private let calculator: Calculator
    let simulation: Simulation
    let shaper: CalculatorShaper

    // MARK: - Init

    init(router: SimulationsRouter, simulation: Simulation) {
        self.router = router
        self.simulation = simulation

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

    func save() {
        let _mergeAndConvertExams = mergeAndConvertExams
        do {
            try simulationRepository.add { [simulation] cdSimulation, context in
                cdSimulation.name = simulation.name
                cdSimulation.exams = _mergeAndConvertExams(context, cdSimulation)
                cdSimulation.type = simulation.type

                cdSimulation.date = Date()
            }
        } catch {
            router.errorAlert()
        }
    }

    private func mergeAndConvertExams(in context: NSManagedObjectContext, for simulation: CDSimulation) -> Set<CDExam>? {
        guard let exams = self.simulation.exams else { return nil }
        var cdExams: Set<CDExam> = .init()

        _ = exams.map { cdExams.insert($0.toCoreDataModel(in: context, for: simulation)) }

        return cdExams
    }

    func userDidTapShareResult(screenshot: UIImage) {
        guard let url = screenshot.url(name: L10n.Home.mySimulation) else {
            router.errorAlert()
            return
        }
        router.openActivityController(with: [url])
    }
}
