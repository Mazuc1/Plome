//
//  AddSimulationModelViewModel.swift
//  Plome
//
//  Created by Loic Mazuc on 21/10/2022.
//

import Combine
import CoreData
import Foundation
import PlomeCoreKit

enum AddSimulationModelOpeningMode {
    case add
    case edit(CDSimulation)
    case editFromDefault(Simulation)
}

final class AddSimulationModelViewModel: ObservableObject {
    // MARK: - Properties

    private let router: SimulationModelsRouter
    private let simulationRepository: CoreDataRepository<CDSimulation>
    private let openAs: AddSimulationModelOpeningMode

    @Published var trials: [Exam] = []
    @Published var continousControls: [Exam] = []
    @Published var options: [Exam] = []

    var simulationName: String = "Nouveau modèle"

    private var cdSimulation: CDSimulation?

    // MARK: - Init

    init(router: SimulationModelsRouter, simulationRepository: CoreDataRepository<CDSimulation>, openAs: AddSimulationModelOpeningMode) {
        self.router = router
        self.simulationRepository = simulationRepository
        self.openAs = openAs

        switch openAs {
        case .add: break
        case let .edit(cdSimulation): setupEditMode(with: cdSimulation)
        case let .editFromDefault(simulation): setupEditModeFromDefault(with: simulation)
        }
    }

    // MARK: - Methods

    private func setupEditMode(with cdSimulation: CDSimulation) {
        simulationName = cdSimulation.name
        self.cdSimulation = cdSimulation

        if let exams = cdSimulation.exams {
            trials = Array(exams.filter { $0.type == .trial })
                .map { Exam(name: $0.name, coefficient: $0.coefficient, grade: $0.grade, type: $0.type) }

            continousControls = Array(exams.filter { $0.type == .continuousControl })
                .map { Exam(name: $0.name, coefficient: $0.coefficient, grade: $0.grade, type: $0.type) }

            options = Array(exams.filter { $0.type == .option })
                .map { Exam(name: $0.name, coefficient: $0.coefficient, grade: $0.grade, type: $0.type) }
        }
    }

    private func setupEditModeFromDefault(with simulation: Simulation) {
        simulationName = simulation.name
        if let exams = simulation.exams {
            trials = Array(exams.filter { $0.type == .trial })
            continousControls = Array(exams.filter { $0.type == .continuousControl })
            options = Array(exams.filter { $0.type == .option })
        }
    }

    func userDidTapAddExam(at indexPath: IndexPath) {
        if indexPath.row == 0 {
            var section: AddSimulationModelViewController.AddSimulationModelSection = .trial
            switch indexPath.section {
            case 0: section = .trial
            case 1: section = .continuousControl
            case 2: section = .option
            default: break
            }

            router.alertWithTextField(title: "Nouveau",
                                      message: "Comment se nomme votre examen ?",
                                      buttonActionName: "Ajouter")
            { [weak self] in
                self?.addExam(name: $0, in: section)
            }
        }
    }

    // `indexPath.row - 1` avoid crashes when attemps to access wrong index in array
    // Because of we had first a custom cell to add exam, when `cellForRowAt` will fetch exams in viewModel
    // indexPath will already be at 1, and skip the first item of arrays
    func exam(for indexPath: IndexPath) -> Exam? {
        switch indexPath.section {
        case 0: return trials[indexPath.row - 1]
        case 1: return continousControls[indexPath.row - 1]
        case 2: return options[indexPath.row - 1]
        default: return nil
        }
    }

    // `indexPath.row - 1` avoid crashes when attemps to access wrong index in array
    // Because of we had first a custom cell to add exam, when `cellForRowAt` will fetch exams in viewModel
    // indexPath will already be at 1, and skip the first item of arrays
    func userDidTapDeleteExam(at indexPath: IndexPath) {
        switch indexPath.section {
        case 0: trials.remove(at: indexPath.row - 1)
        case 1: continousControls.remove(at: indexPath.row - 1)
        case 2: options.remove(at: indexPath.row - 1)
        default: break
        }
    }

    private func addExam(name: String, in section: AddSimulationModelViewController.AddSimulationModelSection) {
        switch section {
        case .trial: trials.append(.init(name: name, coefficient: nil, grade: nil, type: .trial))
        case .continuousControl: continousControls.append(.init(name: name, coefficient: nil, grade: nil, type: .continuousControl))
        case .option: options.append(.init(name: name, coefficient: nil, grade: nil, type: .option))
        }
    }

    func userDidTapSaveSimulationModel() {
        switch openAs {
        case .add: saveNewSimulationModel(name: simulationName)
        case .edit: saveEditSimulationModel()
        case .editFromDefault: saveNewSimulationModel(name: simulationName)
        }
    }

    func dismiss() {
        router.dismiss()
    }

    private func saveEditSimulationModel() {
        let _mergeAndConvertExams = mergeAndConvertExams
        do {
            try simulationRepository.update { [cdSimulation, simulationName] in
                if let cdSimulation {
                    cdSimulation.name = simulationName
                    cdSimulation.exams = _mergeAndConvertExams($0, cdSimulation)
                }
            }

            router.dismiss()
        } catch {
            router.alert(title: "Oups", message: "Une erreur est survenue 😕")
        }
    }

    private func saveNewSimulationModel(name: String) {
        do {
            try simulationRepository.add { [weak self] cdSimulation, context in
                cdSimulation.name = name
                cdSimulation.exams = self?.mergeAndConvertExams(in: context, for: cdSimulation)
            }

            router.dismiss()
        } catch {
            router.alert(title: "Oups", message: "Une erreur est survenue 😕")
        }
    }

    private func mergeAndConvertExams(in context: NSManagedObjectContext, for simulation: CDSimulation) -> Set<CDExam> {
        var cdExams: Set<CDExam> = .init()

        _ = trials.map { cdExams.insert($0.toCoreDataModel(in: context, for: simulation)) }
        _ = continousControls.map { cdExams.insert($0.toCoreDataModel(in: context, for: simulation)) }
        _ = options.map { cdExams.insert($0.toCoreDataModel(in: context, for: simulation)) }

        return cdExams
    }
}
