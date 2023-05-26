//
//  AddSimulationModelViewModel.swift
//  Plome
//
//  Created by Loic Mazuc on 21/10/2022.
//

import Combine
import CoreData
import Factory
import Foundation
import PlomeCoreKit

enum AddSimulationModelOpeningMode {
    case add
    case edit(CDSimulation)
}

protocol AddSimulationModelViewModelInput: AnyObject {
    func userDidChangeValue()
}

final class AddSimulationModelViewModel: ObservableObject {
    // MARK: - Properties

    private let router: SimulationModelsRouter
    private let openAs: AddSimulationModelOpeningMode
    
    @Injected(\CoreKitContainer.coreDataSimulationRepository) private var simulationRepository

    @Published var trials: [Exam] = []
    @Published var continousControls: [Exam] = []
    @Published var options: [Exam] = []
    @Published var canRegister: Bool = true

    var simulationName: String = L10n.SimulationModels.newModel

    private var cdSimulation: CDSimulation?

    // MARK: - Init

    init(router: SimulationModelsRouter, openAs: AddSimulationModelOpeningMode) {
        self.router = router
        self.openAs = openAs

        switch openAs {
        case .add: break
        case let .edit(cdSimulation): setupEditMode(with: cdSimulation)
        }
    }

    // MARK: - Methods

    private func setupEditMode(with cdSimulation: CDSimulation) {
        simulationName = cdSimulation.name
        self.cdSimulation = cdSimulation

        if let exams = cdSimulation.exams {
            trials = Array(exams.filter { $0.type == .trial })
                .map { Exam(name: $0.name, coefficient: $0.coefficient, grade: $0.grade, ratio: $0.ratio, type: $0.type) }
                .sorted { $0.name < $1.name }

            continousControls = Array(exams.filter { $0.type == .continuousControl })
                .map { Exam(name: $0.name, coefficient: $0.coefficient, grade: $0.grade, ratio: $0.ratio, type: $0.type) }
                .sorted { $0.name < $1.name }

            options = Array(exams.filter { $0.type == .option })
                .map { Exam(name: $0.name, coefficient: $0.coefficient, grade: $0.grade, ratio: $0.ratio, type: $0.type) }
                .sorted { $0.name < $1.name }
        }
    }

    func exam(for indexPath: IndexPath) -> Exam? {
        switch indexPath.section {
        case 0: return trials[indexPath.row]
        case 1: return continousControls[indexPath.row]
        case 2: return options[indexPath.row]
        default: return nil
        }
    }

    func userDidTapDeleteExam(at indexPath: IndexPath) {
        switch indexPath.section {
        case 0: trials.remove(at: indexPath.row)
        case 1: continousControls.remove(at: indexPath.row)
        case 2: options.remove(at: indexPath.row)
        default: break
        }
    }

    func addExam(name: String, in section: ExamTypeSection) {
        switch section {
        case .trial: trials.append(.init(name: name, coefficient: 1, grade: nil, ratio: 20, type: .trial))
        case .continuousControl: continousControls.append(.init(name: name, coefficient: 1, grade: nil, ratio: 20, type: .continuousControl))
        case .option: options.append(.init(name: name, coefficient: 1, grade: nil, ratio: 20, type: .option))
        }
    }

    func userDidTapSaveSimulationModel() {
        switch openAs {
        case .add: saveNewSimulationModel(name: simulationName)
        case .edit: saveEditSimulationModel()
        }
    }

    func dismiss() {
        router.dismiss()
    }

    func saveEditSimulationModel() {
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
            router.errorAlert()
        }
    }

    func saveNewSimulationModel(name: String) {
        do {
            try simulationRepository.add { [weak self] cdSimulation, context in
                cdSimulation.name = name
                cdSimulation.exams = self?.mergeAndConvertExams(in: context, for: cdSimulation)
                cdSimulation.type = .custom
            }

            router.dismiss()
        } catch {
            router.errorAlert()
        }
    }

    func mergeAndConvertExams(in context: NSManagedObjectContext, for simulation: CDSimulation) -> Set<CDExam> {
        var cdExams: Set<CDExam> = .init()

        _ = trials.map { cdExams.insert($0.toCoreDataModel(in: context, for: simulation)) }
        _ = continousControls.map { cdExams.insert($0.toCoreDataModel(in: context, for: simulation)) }
        _ = options.map { cdExams.insert($0.toCoreDataModel(in: context, for: simulation)) }

        return cdExams
    }
}

extension AddSimulationModelViewModel: ExamTypeHeaderViewOutput {
    func userDidTapAddExam(for section: ExamTypeSection) {
        router.alertWithTextField(title: PlomeCoreKit.L10n.General.new,
                                  message: L10n.howNamedYour(section.title),
                                  buttonActionName: PlomeCoreKit.L10n.General.add) { [weak self] in
            self?.addExam(name: $0, in: section)
        }
    }
}

extension AddSimulationModelViewModel: AddSimulationModelViewModelInput {
    func userDidChangeValue() {
        canRegister = [trials, continousControls, options]
            .flatMap { $0 }
            .allSatisfy { $0.coefficient != nil }
    }
}
