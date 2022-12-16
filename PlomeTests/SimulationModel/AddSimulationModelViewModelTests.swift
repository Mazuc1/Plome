//
//  AddSimulationModelViewModelTests.swift
//  PlomeTests
//
//  Created by Loic Mazuc on 28/10/2022.
//

import Combine
import CoreData
@testable import Plome
@testable import PlomeCoreKit
@testable import PlomeCoreKitTestsHelpers
import XCTest

final class AddSimulationModelViewModelTests: XCTestCase {
    private var simulationModelsRouter: SimulationModelsRouter!
    private var addSimulationModelViewModel: AddSimulationModelViewModel!
    private var simulationRepository: CoreDataRepository<CDSimulation>!
    private var mockCoreData: MockCoreData!
    private var cancellables: Set<AnyCancellable> = []

    override func setUp() {
        super.setUp()

        mockCoreData = MockCoreData()
        simulationRepository = CoreDataRepository(storageProvider: mockCoreData)

        simulationModelsRouter = SimulationModelsRouter(screens: .init(context: testContext), rootTransition: EmptyTransition())
        addSimulationModelViewModel = AddSimulationModelViewModel(router: simulationModelsRouter, simulationRepository: simulationRepository, openAs: .add)
    }

    // MARK: - Init default value

    func testWhenOpeningAddSimulationModelVCAsAddOpeningModeThenExamsAreEmpty() {
        // Act
        let addSimulationModelViewModel = AddSimulationModelViewModel(router: simulationModelsRouter, simulationRepository: simulationRepository, openAs: .add)

        // Assert
        XCTAssertEqual(addSimulationModelViewModel.trials.count, 0)
        XCTAssertEqual(addSimulationModelViewModel.continousControls.count, 0)
        XCTAssertEqual(addSimulationModelViewModel.options.count, 0)
    }

    func testWhenOpeningAddSimulationModelVCAsEditOpeningModeThenExamsIsNotEmpty() {
        // Arrange
        let cdExam = CDExam(context: simulationRepository.mainContext)
        cdExam.name = "Test"
        cdExam.type = .trial

        let cdSimulation = CDSimulation(context: simulationRepository.mainContext)
        cdSimulation.name = "Test"
        cdSimulation.exams = .init()
        cdSimulation.exams?.insert(cdExam)

        // Act
        let addSimulationModelViewModel = AddSimulationModelViewModel(router: simulationModelsRouter, simulationRepository: simulationRepository, openAs: .edit(cdSimulation))

        // Assert
        let allExams = addSimulationModelViewModel.trials + addSimulationModelViewModel.continousControls + addSimulationModelViewModel.options
        XCTAssertTrue(allExams.count > 0)
    }

    // MARK: - Navigation title

    func testWhenOpeningAddSimulationModelVCAsAddOpeningModeThenTitleIsDefaultTitle() {
        // Act
        let addSimulationModelViewModel = AddSimulationModelViewModel(router: simulationModelsRouter, simulationRepository: simulationRepository, openAs: .add)

        // Assert
        XCTAssertEqual(addSimulationModelViewModel.simulationName, "Nouveau modèle")
    }

    func testWhenOpeningAddSimulationModelVCAsEditOpeningModeThenTitleIsCDSimulationName() {
        // Arrange
        let cdSimulation = CDSimulation(context: simulationRepository.mainContext)
        cdSimulation.name = "Test"

        // Act
        let addSimulationModelViewModel = AddSimulationModelViewModel(router: simulationModelsRouter, simulationRepository: simulationRepository, openAs: .edit(cdSimulation))

        // Assert
        XCTAssertEqual(addSimulationModelViewModel.simulationName, "Test")
    }

    // MARK: - Add Exam

    func testWhenAddingTrialExamThenTrialIsAdded() {
        // Act
        addSimulationModelViewModel.addExam(name: "Test", in: .trial)

        // Assert
        XCTAssertEqual(addSimulationModelViewModel.trials.count, 1)
    }

    func testWhenAddingContinuousControlExamThenContinuousControlIsAdded() {
        // Act
        addSimulationModelViewModel.addExam(name: "Test", in: .continuousControl)

        // Assert
        XCTAssertEqual(addSimulationModelViewModel.continousControls.count, 1)
    }

    func testWhenAddingOptionExamThenOptionIsAdded() {
        // Act
        addSimulationModelViewModel.addExam(name: "Test", in: .option)

        // Assert
        XCTAssertEqual(addSimulationModelViewModel.options.count, 1)
    }

    // MARK: - Getting Exam

    func testWhenGettingTrialExamThenTrialIsReturned() {
        // Arrange
        addSimulationModelViewModel.addExam(name: "Trial", in: .trial)

        // Act
        let trial = addSimulationModelViewModel.exam(for: .init(row: 0, section: 0))

        // Assert
        XCTAssertEqual(trial?.name, "Trial")
    }

    func testWhenGettingContinousControlExamThenContinousControlIsReturned() {
        // Arrange
        addSimulationModelViewModel.addExam(name: "Continuous Control", in: .continuousControl)

        // Act
        let continuousControl = addSimulationModelViewModel.exam(for: .init(row: 0, section: 1))

        // Assert
        XCTAssertEqual(continuousControl?.name, "Continuous Control")
    }

    func testWhenGettingOptionExamThenOptionIsReturned() {
        // Arrange
        addSimulationModelViewModel.addExam(name: "Option", in: .option)

        // Act
        let option = addSimulationModelViewModel.exam(for: .init(row: 0, section: 2))

        // Assert
        XCTAssertEqual(option?.name, "Option")
    }

    // MARK: - Remove Exam

    func testWhenDeletingTrialExamThenTrialIsDeleted() {
        // Arrange
        addSimulationModelViewModel.addExam(name: "Trial", in: .trial)

        // Act
        addSimulationModelViewModel.userDidTapDeleteExam(at: .init(row: 0, section: 0))

        // Assert
        XCTAssertEqual(addSimulationModelViewModel.options.count, 0)
    }

    func testWhenDeletingContinuousControlExamThenContinuousControlIsDeleted() {
        // Arrange
        addSimulationModelViewModel.addExam(name: "Continuous Control", in: .continuousControl)

        // Act
        addSimulationModelViewModel.userDidTapDeleteExam(at: .init(row: 0, section: 1))

        // Assert
        XCTAssertEqual(addSimulationModelViewModel.options.count, 0)
    }

    func testWhenDeletingOptionExamThenOptionIsDeleted() {
        // Arrange
        addSimulationModelViewModel.addExam(name: "Option", in: .option)

        // Act
        addSimulationModelViewModel.userDidTapDeleteExam(at: .init(row: 0, section: 2))

        // Assert
        XCTAssertEqual(addSimulationModelViewModel.options.count, 0)
    }

    // MARK: - Merge

    func testThatMergeExamsReturnsSetOfCDExams() {
        // Arrange
        addSimulationModelViewModel.addExam(name: "Trial", in: .trial)
        addSimulationModelViewModel.addExam(name: "Continuous Control", in: .continuousControl)
        addSimulationModelViewModel.addExam(name: "Option", in: .option)

        let cdSimulation = CDSimulation(context: simulationRepository.mainContext)
        cdSimulation.name = "Test"

        // Act
        let cdExams = addSimulationModelViewModel.mergeAndConvertExams(in: simulationRepository.mainContext, for: cdSimulation)

        // Assert
        XCTAssertTrue(cdExams.count > 0)
    }

    // MARK: - Add Simulation model

    func testThatAddingSimulationModelIsCorrectlyAdded() {
        // Act
        addSimulationModelViewModel.saveNewSimulationModel(name: "Test")
        let cdSimulations = try! simulationRepository.list()

        // Assert
        XCTAssertTrue(cdSimulations.count > 0)
    }

    // MARK: - Update simulation model

    func testThatEditingSimulationModelIsCorrectlyUpdated() {
        // Arrange
        let cdExam = CDExam(context: simulationRepository.mainContext)
        cdExam.name = "Test"
        cdExam.type = .trial

        let cdSimulation = CDSimulation(context: simulationRepository.mainContext)
        cdSimulation.name = "Test"
        cdSimulation.exams = .init()
        cdSimulation.exams?.insert(cdExam)

        let addSimulationModelViewModel = AddSimulationModelViewModel(router: simulationModelsRouter, simulationRepository: simulationRepository, openAs: .edit(cdSimulation))

        addSimulationModelViewModel.simulationName = "New test"
        addSimulationModelViewModel.trials.removeAll()

        let cdSimulationFromCD = try! simulationRepository.list().first

        // Act
        addSimulationModelViewModel.saveEditSimulationModel()

        // Assert
        XCTAssertEqual(cdSimulationFromCD?.name, "New test")
        XCTAssertTrue(cdSimulationFromCD?.exams?.count == 0)
    }
}
