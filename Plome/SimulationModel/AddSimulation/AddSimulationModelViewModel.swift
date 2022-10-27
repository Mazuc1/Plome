//
//  AddSimulationModelViewModel.swift
//  Plome
//
//  Created by Loic Mazuc on 21/10/2022.
//

import Combine
import Foundation
import PlomeCoreKit

final class AddSimulationModelViewModel: ObservableObject {
    // MARK: - Properties

    let router: SimulationModelsRouter

    @Published var trials: [Exam] = []
    @Published var continousControls: [Exam] = []
    @Published var options: [Exam] = []

    // MARK: - Init

    init(router: SimulationModelsRouter) {
        self.router = router
    }

    // MARK: - Methods

    func userDidTapAddExam(in section: AddSimulationModelViewController.AddSimulationModelSection) {
        router.openAddExamAlert { [weak self] in
            self?.addExam(name: $0, in: section)
        }
    }

    func userDidTapDeleteExam(at index: Int, in section: AddSimulationModelViewController.AddSimulationModelSection) {
        switch section {
        case .trial: trials.remove(at: index)
        case .continuousControl: continousControls.remove(at: index)
        case .option: options.remove(at: index)
        }
    }

    private func addExam(name: String, in section: AddSimulationModelViewController.AddSimulationModelSection) {
        switch section {
        case .trial: trials.append(.init(name: name, coefficient: nil, grade: nil, type: .trial))
        case .continuousControl: continousControls.append(.init(name: name, coefficient: nil, grade: nil, type: .continuousControl))
        case .option: options.append(.init(name: name, coefficient: nil, grade: nil, type: .option))
        }
    }
}
