//
//  SimulationResultViewModel.swift
//  Plome
//
//  Created by Loic Mazuc on 10/11/2022.
//

import CoreData
import Foundation
import PlomeCoreKit

final class SimulationResultViewModel {
    // MARK: - Properties

    private let router: SimulationsRouter
    private let calculator: Calculator
    private let simulationRepository: CoreDataRepository<CDSimulation>

    let simulation: Simulation

    enum Save {
        case simulation
        case simulationModel
    }

    // MARK: - Init

    init(router: SimulationsRouter, simulation: Simulation, simulationRepository: CoreDataRepository<CDSimulation>) {
        self.router = router
        self.simulation = simulation
        self.simulationRepository = simulationRepository

        calculator = .init(simulation: simulation)
        calculator.calculate()
    }

    // MARK: - Methods

    func finalGradeOutOfTwenty() -> String {
        "\(calculator.finalGrade.truncate(places: 2))/20"
    }

    func finalGradeBeforeTwentyConform() -> String {
        "\(calculator.totalGrade.truncate(places: 2))/\(calculator.totalOutOf.truncate(places: 0))"
    }

    func hasSucceedExam() -> Bool {
        calculator.hasSucceed()
    }

    func displayCatchUpSectionIfNeeded() -> Bool {
        !hasSucceedExam() && calculator.differenceAfterCatchUp != nil && calculator.gradeOutOfTwentyAfterCatchUp != nil
    }

    func getCatchUpInformations() -> (grade: Float, difference: [Exam: Int])? {
        guard let grade = calculator.gradeOutOfTwentyAfterCatchUp,
              let difference = calculator.differenceAfterCatchUp else { return nil }

        return (grade, difference)
    }

    func admissionSentence() -> String {
        hasSucceedExam() ? "Vous êtes admis ! 🥳" : "Vous n'êtes pas admis 😕"
    }

    func resultSentence() -> String {
        hasSucceedExam() ? "Félicitation !" : "Oups..."
    }

    func mentionSentence() -> String {
        guard let mention = calculator.mention else { return "Sans mention" }
        return mention.name
    }

    func trialsGrade() -> String {
        guard let grade = calculator.trialsGrade else { return "" }
        return "\(grade.truncate(places: 2))/20"
    }

    func continousControlGrade() -> String {
        guard let grade = calculator.continousControlGrade else { return "" }
        return "\(grade.truncate(places: 2))/20"
    }

    func optionGrade() -> String {
        guard let grade = calculator.optionsGrade else { return "" }
        return "\(grade.truncate(places: 2))/20"
    }

    func simulationContainTrials() -> Bool {
        simulation.examsContainTrials()
    }

    func simulationContainContinousControls() -> Bool {
        simulation.examsContainContinuousControls()
    }

    func simulationContainOptions() -> Bool {
        simulation.examsContainOptions()
    }

    func userDidTapRemakeSimulate() {
        router.popViewController()
    }

    // MARK: - Save simulation / simulation model

    func save(_ type: Save) {
        let _mergeAndConvertExams = mergeAndConvertExams
        do {
            try simulationRepository.add { [simulation] cdSimulation, context in
                cdSimulation.name = simulation.name
                cdSimulation.exams = _mergeAndConvertExams(context, cdSimulation)
                cdSimulation.type = simulation.type

                switch type {
                case .simulation: cdSimulation.date = Date()
                case .simulationModel: cdSimulation.date = nil
                }
            }

            if type == .simulationModel {
                router.alert(title: "C'est fait !", message: "Le modèle à bien été enregistrer")
            }
        } catch {
            router.alert(title: "Oups", message: "Une erreur est survenue 😕")
        }
    }

    private func mergeAndConvertExams(in context: NSManagedObjectContext, for simulation: CDSimulation) -> Set<CDExam>? {
        guard let exams = self.simulation.exams else { return nil }
        var cdExams: Set<CDExam> = .init()

        _ = exams.map { cdExams.insert($0.toCoreDataModel(in: context, for: simulation)) }

        return cdExams
    }
}
