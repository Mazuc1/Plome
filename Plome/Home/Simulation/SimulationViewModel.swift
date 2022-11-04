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
    
    func userDidTapDeleteExam(at indexPath: IndexPath) {
        var exam: Exam?
        
        switch indexPath.section {
        case 0: exam = simulation.exams(of: .trial)[indexPath.row]
        case 1: exam = simulation.exams(of: .continuousControl)[indexPath.row]
        case 2: exam = simulation.exams(of: .option)[indexPath.row]
        default: break
        }
        
        guard let exam else {
            router.alert(title: "Oups", message: "Une erreur est survenue 😕")
            return
        }
        
        simulation.remove(exam: exam)
    }
}

// MARK: - ExamTypeHeaderViewOutput

extension SimulationViewModel: ExamTypeHeaderViewOutput {
    func userDidTapAddExam(for _: PlomeCoreKit.ExamTypeSection) {
        //
    }
}
