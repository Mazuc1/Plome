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
}

final class AddSimulationModelViewModel: ObservableObject {
    // MARK: - Properties

    private let router: SimulationModelsRouter
    private let simulationRepository: CoreDataRepository<CDSimulation>
    private let openAs: AddSimulationModelOpeningMode

    @Published var trials: [Exam] = []
    @Published var continousControls: [Exam] = []
    @Published var options: [Exam] = []
    
    var cdSimulation: CDSimulation?

    // MARK: - Init

    init(router: SimulationModelsRouter, simulationRepository: CoreDataRepository<CDSimulation>, openAs: AddSimulationModelOpeningMode) {
        self.router = router
        self.simulationRepository = simulationRepository
        self.openAs = openAs
        
        switch openAs {
        case .add: break
        case .edit(let cdSimulation): self.setupEditMode(with: cdSimulation)
        }
    }

    // MARK: - Methods
    
    private func setupEditMode(with cdSimulation: CDSimulation) {
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

    func userDidTapAddExam(in section: AddSimulationModelViewController.AddSimulationModelSection) {
        router.alertWithTextField(title: "Nouveau",
                                  message: "Comment se nomme votre examen ?",
                                  buttonActionName: "Ajouter")
        { [weak self] in
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

    func userDidTapSaveSimulationModel() {
        switch openAs {
        case .add:
            router.alertWithTextField(title: "Nouveau",
                                      message: "Comment souhaitez-vous nommer votre nouveau modèle ?",
                                      buttonActionName: "Enregistrer") { [weak self] in
                self?.saveNewSimulationModel(name: $0)
            }
        case .edit(_): saveEditSimulationModel()
        }
    }
    
    private func saveEditSimulationModel() {
//        cdSimulation?.addToExams(CDExam.init(context: simulationRepository.mainContext).configure(block: {
//            $0.name = "Du code"
//            $0.type = .option
//            $0.simulation = self.cdSimulation!
//        }))
        cdSimulation?.exams?.removeAll()
        
        try! simulationRepository.update()
        
//        do {
//
//
//            router.dismiss()
//        } catch {
//            router.alert(title: "Oups", message: "Une erreur est survenue 😕")
//        }
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
