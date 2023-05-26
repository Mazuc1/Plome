//
//  SimulationViewModel.swift
//  Plome
//
//  Created by Loic Mazuc on 31/10/2022.
//

import Combine
import Foundation
import PlomeCoreKit
import UIKit

protocol SimulationViewModelInput: AnyObject {
    func didChangeSimulationExamGrade()
}

final class SimulationViewModel: ObservableObject {
    // MARK: - Properties

    private let router: SimulationsRouter

    @Published var simulation: Simulation

    weak var examTypePageViewControllerInput: ExamTypePageViewControllerInput?
    weak var simulationLiveInfosInput: SimulationLiveInfosInput?

    lazy var examTypePageViewModel: ExamTypePageViewModel = {
        let viewModel = ExamTypePageViewModel(simulation: simulation)
        viewModel.simulationViewModelInput = self
        return viewModel
    }()

    // MARK: - Init

    init(router: SimulationsRouter, simulation: Simulation) {
        self.router = router
        self.simulation = simulation

        didChangeSimulationExamGrade()
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
