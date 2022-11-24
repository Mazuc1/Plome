//
//  SimulationResultViewModelTests.swift
//  PlomeTests
//
//  Created by Loic Mazuc on 23/11/2022.
//

@testable import Plome
@testable import PlomeCoreKit
import PlomeCoreKitTestsHelpers
import XCTest

final class SimulationResultViewModelTests: XCTestCase {
    private var simulationsRouter: SimulationsRouter!
    private var simulationRepository: CoreDataRepository<CDSimulation>!
    private var mockCoreData: MockCoreData!

    override func setUp() {
        super.setUp()

        mockCoreData = MockCoreData()
        simulationRepository = CoreDataRepository(storageProvider: mockCoreData)

        simulationsRouter = SimulationsRouter(screens: .init(context: testContext), rootTransition: EmptyTransition())
    }

    // MARK: - simulationContainTrials

    func testWhenSimulationContainsTrialsThenReturnedTrue() {
        // Arrange
        let simulation = TestSimulations.brevetSimulation(targetedMention: .AB)
        let simulationResultViewModel = SimulationResultViewModel(router: simulationsRouter, simulation: simulation, simulationRepository: simulationRepository)
        simulationResultViewModel.calculator.calculate()

        // Act
        let containTrials = simulationResultViewModel.simulationContainTrials()

        // Assert
        XCTAssertTrue(containTrials)
    }

    func testWhenSimulationDonNotContainsTrialsThenReturnedFalse() {
        // Arrange
        let simulation = Simulation(name: "", date: nil, exams: .init(), type: .generalBAC)
        let simulationResultViewModel = SimulationResultViewModel(router: simulationsRouter, simulation: simulation, simulationRepository: simulationRepository)
        simulationResultViewModel.calculator.calculate()

        // Act
        let containTrials = simulationResultViewModel.simulationContainTrials()

        // Assert
        XCTAssertFalse(containTrials)
    }

    // MARK: - simulationContainContinousControls

    func testWhenSimulationContainsContinuousControlThenReturnedTrue() {
        // Arrange
        let simulation = TestSimulations.brevetSimulation(targetedMention: .AB)
        let simulationResultViewModel = SimulationResultViewModel(router: simulationsRouter, simulation: simulation, simulationRepository: simulationRepository)
        simulationResultViewModel.calculator.calculate()

        // Act
        let containContinuousControl = simulationResultViewModel.simulationContainContinousControls()

        // Assert
        XCTAssertTrue(containContinuousControl)
    }

    func testWhenSimulationDonNotContainsContinuousControlThenReturnedFalse() {
        // Arrange
        let simulation = Simulation(name: "", date: nil, exams: .init(), type: .generalBAC)
        let simulationResultViewModel = SimulationResultViewModel(router: simulationsRouter, simulation: simulation, simulationRepository: simulationRepository)
        simulationResultViewModel.calculator.calculate()

        // Act
        let containContinuousControl = simulationResultViewModel.simulationContainContinousControls()

        // Assert
        XCTAssertFalse(containContinuousControl)
    }

    // MARK: - simulationContainOptions

    func testWhenSimulationContainsOptionsThenReturnedTrue() {
        // Arrange
        let simulation = TestSimulations.brevetSimulation(targetedMention: .AB, withOptions: true)
        let simulationResultViewModel = SimulationResultViewModel(router: simulationsRouter, simulation: simulation, simulationRepository: simulationRepository)
        simulationResultViewModel.calculator.calculate()

        // Act
        let containOptions = simulationResultViewModel.simulationContainOptions()

        // Assert
        XCTAssertTrue(containOptions)
    }

    func testWhenSimulationDonNotContainsOptionsThenReturnedFalse() {
        // Arrange
        let simulation = TestSimulations.brevetSimulation(targetedMention: .AB, withOptions: false)
        let simulationResultViewModel = SimulationResultViewModel(router: simulationsRouter, simulation: simulation, simulationRepository: simulationRepository)
        simulationResultViewModel.calculator.calculate()

        // Act
        let containOptions = simulationResultViewModel.simulationContainOptions()

        // Assert
        XCTAssertFalse(containOptions)
    }

    // MARK: - hasSucceedExam

    func testWhenCalculationOfSimulationIsSuccessThenReturnedTrue() {
        // Arrange
        let simulation = TestSimulations.generalBACSimulation(targetedMention: .AB)
        let simulationResultViewModel = SimulationResultViewModel(router: simulationsRouter, simulation: simulation, simulationRepository: simulationRepository)
        simulationResultViewModel.calculator.calculate()

        // Act
        let examSucceed = simulationResultViewModel.hasSucceedExam()

        // Assert
        XCTAssertTrue(examSucceed)
    }

    func testWhenCalculationOfSimulationIsFailureThenReturnedFalse() {
        // Arrange
        let simulation = TestSimulations.brevetSimulation(targetedMention: .mediumFailure)
        let simulationResultViewModel = SimulationResultViewModel(router: simulationsRouter, simulation: simulation, simulationRepository: simulationRepository)
        simulationResultViewModel.calculator.calculate()

        // Act
        let examSucceed = simulationResultViewModel.hasSucceedExam()

        // Assert
        XCTAssertFalse(examSucceed)
    }

    // MARK: - displayCatchUpSectionIfNeeded

    func testWhenCalculationOfSimulationIsSuccessThenCatchUpSectionIsHidden() {
        // Arrange
        let simulation = TestSimulations.generalBACSimulation(targetedMention: .AB)
        let simulationResultViewModel = SimulationResultViewModel(router: simulationsRouter, simulation: simulation, simulationRepository: simulationRepository)
        simulationResultViewModel.calculator.calculate()

        // Act
        let displayCatchUpSection = simulationResultViewModel.displayCatchUpSectionIfNeeded()

        // Assert
        XCTAssertFalse(displayCatchUpSection)
    }

    func testWhenCalculationOfSimulationIsFailureThenCatchUpSectionNeededToBeDisplayed() {
        // Arrange
        let simulation = TestSimulations.brevetSimulation(targetedMention: .mediumFailure)
        let simulationResultViewModel = SimulationResultViewModel(router: simulationsRouter, simulation: simulation, simulationRepository: simulationRepository)
        simulationResultViewModel.calculator.calculate()

        // Act
        let displayCatchUpSection = simulationResultViewModel.displayCatchUpSectionIfNeeded()

        // Assert
        XCTAssertTrue(displayCatchUpSection)
    }

    // MARK: - getCatchUpInformations

    func testWhenCalculationOfSimulationIsFailureThenCatchUpInformationsIsAccessible() {
        // Arrange
        let simulation = TestSimulations.brevetSimulation(targetedMention: .mediumFailure)
        let simulationResultViewModel = SimulationResultViewModel(router: simulationsRouter, simulation: simulation, simulationRepository: simulationRepository)
        simulationResultViewModel.calculator.calculate()

        // Act
        let catchUpInformations = simulationResultViewModel.getCatchUpInformations()

        // Assert
        XCTAssertNotNil(catchUpInformations)
    }

    func testWhenCalculationOfSimulationIsSuccessThenCatchUpInformationsIsNotAccessible() {
        // Arrange
        let simulation = TestSimulations.brevetSimulation(targetedMention: .AB)
        let simulationResultViewModel = SimulationResultViewModel(router: simulationsRouter, simulation: simulation, simulationRepository: simulationRepository)
        simulationResultViewModel.calculator.calculate()

        // Act
        let catchUpInformations = simulationResultViewModel.getCatchUpInformations()

        // Assert
        XCTAssertNil(catchUpInformations)
    }

    // MARK: - admissionSentence

    func testWhenCalculationOfSimulationIsSuccessThenAdmissionSentenceMatch() {
        // Arrange
        let simulation = TestSimulations.generalBACSimulation(targetedMention: .TB)
        let simulationResultViewModel = SimulationResultViewModel(router: simulationsRouter, simulation: simulation, simulationRepository: simulationRepository)
        simulationResultViewModel.calculator.calculate()

        // Act
        let admissionSentence = simulationResultViewModel.admissionSentence()

        // Assert
        XCTAssertEqual(admissionSentence, "Vous êtes admis ! 🥳")
    }

    func testWhenCalculationOfSimulationIsFailureThenAdmissionSentenceMatch() {
        // Arrange
        let simulation = TestSimulations.brevetSimulation(targetedMention: .mediumFailure)
        let simulationResultViewModel = SimulationResultViewModel(router: simulationsRouter, simulation: simulation, simulationRepository: simulationRepository)
        simulationResultViewModel.calculator.calculate()

        // Act
        let admissionSentence = simulationResultViewModel.admissionSentence()

        // Assert
        XCTAssertEqual(admissionSentence, "Vous n'êtes pas admis 😕")
    }

    // MARK: - resultSentence

    func testWhenCalculationOfSimulationIsSuccessThenResultSentenceMatch() {
        // Arrange
        let simulation = TestSimulations.generalBACSimulation(targetedMention: .TB)
        let simulationResultViewModel = SimulationResultViewModel(router: simulationsRouter, simulation: simulation, simulationRepository: simulationRepository)
        simulationResultViewModel.calculator.calculate()

        // Act
        let resultSentence = simulationResultViewModel.resultSentence()

        // Assert
        XCTAssertEqual(resultSentence, "Félicitation !")
    }

    func testWhenCalculationOfSimulationIsFailureThenResultSentenceMatch() {
        // Arrange
        let simulation = TestSimulations.brevetSimulation(targetedMention: .mediumFailure)
        let simulationResultViewModel = SimulationResultViewModel(router: simulationsRouter, simulation: simulation, simulationRepository: simulationRepository)
        simulationResultViewModel.calculator.calculate()

        // Act
        let resultSentence = simulationResultViewModel.resultSentence()

        // Assert
        XCTAssertEqual(resultSentence, "Oups...")
    }

    // MARK: - mentionSentence

    func testWhenCalculationOfSimulationIsSuccessThenMentionSentenceMatch() {
        // Arrange
        let simulation = TestSimulations.generalBACSimulation(targetedMention: .TB)
        let simulationResultViewModel = SimulationResultViewModel(router: simulationsRouter, simulation: simulation, simulationRepository: simulationRepository)
        simulationResultViewModel.calculator.calculate()

        // Act
        let resultSentence = simulationResultViewModel.mentionSentence()

        // Assert
        XCTAssertEqual(resultSentence, Mention.TB.name)
    }

    func testWhenCalculationOfSimulationIsFailureThenMentionSentenceMatch() {
        // Arrange
        let simulation = TestSimulations.generalBACSimulation(targetedMention: .mediumFailure)
        let simulationResultViewModel = SimulationResultViewModel(router: simulationsRouter, simulation: simulation, simulationRepository: simulationRepository)
        simulationResultViewModel.calculator.calculate()

        // Act
        let resultSentence = simulationResultViewModel.mentionSentence()

        // Assert
        XCTAssertEqual(resultSentence, "Sans mention")
    }

    // MARK: - Save

    func testWhenAddingSimulationToCoreDataThenSimulationIsAdded() {
        // Arrange
        let simulation = TestSimulations.generalBACSimulation(targetedMention: .mediumFailure)
        let simulationResultViewModel = SimulationResultViewModel(router: simulationsRouter, simulation: simulation, simulationRepository: simulationRepository)

        let cdSimulationsBeforeAddingNewSimulation = try! simulationRepository.list()

        // Act
        simulationResultViewModel.save(.simulation)

        // Assert
        let cdSimulationsAfterAddingNewSimulation = try! simulationRepository.list()
        XCTAssertTrue((cdSimulationsBeforeAddingNewSimulation.count + 1) == cdSimulationsAfterAddingNewSimulation.count)
    }

    func testWhenAddingSimulationModelToCoreDataThenSimulationModelIsAdded() {
        // Arrange
        let simulation = TestSimulations.generalBACSimulation(targetedMention: .mediumFailure)
        let simulationResultViewModel = SimulationResultViewModel(router: simulationsRouter, simulation: simulation, simulationRepository: simulationRepository)

        let cdSimulationsBeforeAddingNewSimulation = try! simulationRepository.list()

        // Act
        simulationResultViewModel.save(.simulationModel)

        // Assert
        let cdSimulationsAfterAddingNewSimulation = try! simulationRepository.list()
        XCTAssertTrue((cdSimulationsBeforeAddingNewSimulation.count + 1) == cdSimulationsAfterAddingNewSimulation.count)
    }
}
