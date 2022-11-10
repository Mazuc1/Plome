//
//  SimulationViewModel.swift
//  Plome
//
//  Created by Loic Mazuc on 31/10/2022.
//

import Foundation
import PlomeCoreKit

protocol SimulationViewModelInput: AnyObject {
    func userDidChangeValue()
}

final class SimulationViewModel: ObservableObject {
    // MARK: - Properties

    private let router: SimulationsRouter

    @Published var simulation: Simulation
    @Published var canCalculate: Bool = false

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

    func addExam(name: String, in section: ExamTypeSection) {
        switch section {
        case .trial: simulation.add(exam: .init(name: name, coefficient: nil, grade: nil, type: .trial))
        case .continuousControl: simulation.add(exam: .init(name: name, coefficient: nil, grade: nil, type: .continuousControl))
        case .option: simulation.add(exam: .init(name: name, coefficient: nil, grade: nil, type: .option))
        }
    }
}

// MARK: - ExamTypeHeaderViewOutput

extension SimulationViewModel: ExamTypeHeaderViewOutput {
    func userDidTapAddExam(for section: PlomeCoreKit.ExamTypeSection) {
        router.alertWithTextField(title: "Nouveau",
                                  message: "Comment se nomme votre \(section.title) ?",
                                  buttonActionName: "Ajouter")
        { [weak self] in
            self?.addExam(name: $0, in: section)
        }
    }
}

extension SimulationViewModel: SimulationViewModelInput {
    func userDidChangeValue() {
        canCalculate = simulation.gradeIsSetForAllExams()
    }
}
