//
//  SimulationViewModel.swift
//  Plome
//
//  Created by Loic Mazuc on 31/10/2022.
//

import Combine
import Factory
import Foundation
import PlomeCoreKit
import UIKit

protocol SimulationViewModelInput: AnyObject {
    func didChangeSimulationExamGrade()
}

final class SimulationViewModel: ObservableObject {
    // MARK: - Properties

    private let router: SimulationsRouter

    @Injected(\CoreKitContainer.coreDataSimulationRepository) private var simulationRepository

    @Published var simulation: Simulation

    private var cdSimulation: CDSimulation?

    weak var examTypePageViewControllerInput: ExamTypePageViewControllerInput?
    weak var simulationLiveInfosInput: SimulationLiveInfosInput?

    lazy var examTypePageViewModel: ExamTypePageViewModel = {
        let viewModel = ExamTypePageViewModel(simulation: simulation)
        viewModel.simulationViewModelInput = self
        return viewModel
    }()

    // MARK: - Init

    init(router: SimulationsRouter, simulation: Simulation, editing cdSimulation: CDSimulation?) {
        self.router = router
        self.simulation = simulation
        self.cdSimulation = cdSimulation
    }

    // MARK: - Methods

    #if DEBUG
        func autoFillExams() {
            _ = simulation.exams!.map { $0.grade = Float.random(in: 1 ... 20).truncate(places: 2) }
            examTypePageViewControllerInput?.updateTableViews()
            didChangeSimulationExamGrade()
        }
    #endif

    func userDidTapShareResult(screenshot: UIImage) {
        guard let url = screenshot.url(name: L10n.Home.mySimulation) else {
            router.errorAlert()
            return
        }
        router.openActivityController(with: [url])
    }

    func saveSimulationIfAllConditionsAreMet() {
        guard simulation.gradeIsSetForAllExams() else {
            router.alert(title: PlomeCoreKit.L10n.General.oups,
                         message: L10n.Home.cantSaveSimulationMessage)
            return
        }

        saveSimulation(successMessage: L10n.Home.saved)
    }

    func saveSimulationToDraft() {
        saveSimulation(successMessage: L10n.Home.addToDraft)
    }

    private func saveSimulation(successMessage: String) {
        do {
            try simulationRepository.add { [simulation] cdSimulation, context in
                cdSimulation.name = simulation.name
                cdSimulation.exams = simulation.mergeAndConvertExams(in: context,
                                                                     for: cdSimulation)
                cdSimulation.type = simulation.type

                cdSimulation.date = Date()
            }

            router.showStatusBanner(title: successMessage, style: .info)
        } catch { router.errorAlert() }
    }
}

// MARK: - SimulationViewModelInput

extension SimulationViewModel: SimulationViewModelInput {
    func didChangeSimulationExamGrade() {
        let simulationLiveInfos = SimulationLiveInfos(average: simulation.average(),
                                                      isAllGradeSet: simulation.gradeIsSetForAllExams(),
                                                      mention: simulation.mention())
        simulationLiveInfosInput?.didUpdate(simulationLiveInfos: simulationLiveInfos)
    }
}
