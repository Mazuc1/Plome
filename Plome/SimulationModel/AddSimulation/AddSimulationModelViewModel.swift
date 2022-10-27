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

final class AddSimulationModelViewModel: ObservableObject {
    // MARK: - Properties

    private let router: SimulationModelsRouter
    private let simulationRepository: CoreDataRepository<CDSimulation>

    @Published var trials: [Exam] = []
    @Published var continousControls: [Exam] = []
    @Published var options: [Exam] = []

    // MARK: - Init

    init(router: SimulationModelsRouter, simulationRepository: CoreDataRepository<CDSimulation>) {
        self.router = router
        self.simulationRepository = simulationRepository
    }

    // MARK: - Methods

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
        router.alertWithTextField(title: "Nouveau",
                                  message: "Comment souhaitez-vous nommer votre nouveau modèle ?",
                                  buttonActionName: "Enregistrer")
        { [weak self] in
            self?.saveNewSimulationModel(name: $0)
        }
    }

    private func saveNewSimulationModel(name: String) {
        do {
            try simulationRepository.add { [weak self] cdSimulation, context in
                cdSimulation.name = name
                cdSimulation.exams = self?.mergeAndConvertExams(in: context)
            }

            router.dismiss()
        } catch {
            router.alert(title: "Oups", message: "Une erreur est survenue 😕")
        }
    }

    private func mergeAndConvertExams(in context: NSManagedObjectContext) -> Set<CDExam> {
        var cdExams: Set<CDExam> = .init()

        _ = trials.map { cdExams.insert($0.toCoreDataModel(in: context)) }
        _ = continousControls.map { cdExams.insert($0.toCoreDataModel(in: context)) }
        _ = options.map { cdExams.insert($0.toCoreDataModel(in: context)) }

        return cdExams
    }
}
