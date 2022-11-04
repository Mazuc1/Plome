//
//  SimulationViewModel.swift
//  Plome
//
//  Created by Loic Mazuc on 31/10/2022.
//

import Foundation
import PlomeCoreKit

final class SimulationViewModel: ObservableObject {
    // MARK: - Properties

    private let router: SimulationsRouter

    @Published var simulation: Simulation

    // MARK: - Init

    init(router: SimulationsRouter, simulation: Simulation) {
        self.router = router
        self.simulation = simulation
    }

    // MARK: - Methods
}

// MARK: - ExamTypeHeaderViewOutput

extension SimulationViewModel: ExamTypeHeaderViewOutput {
    func userDidTapAddExam(for _: PlomeCoreKit.ExamTypeSection) {
        //
    }
}
