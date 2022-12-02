//
//  SimulationResultViewModelTests.swift
//  PlomeTests
//
//  Created by Loic Mazuc on 23/11/2022.
//

@testable import Plome
@testable import PlomeCoreKit
@testable import PlomeCoreKitTestsHelpers
import XCTest

let testContext = Context()

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
