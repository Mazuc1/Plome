//
//  SimulationResultViewModelTests.swift
//  PlomeTests
//
//  Created by Loic Mazuc on 23/11/2022.
//

import Dependencies
@testable import Plome
@testable import PlomeCoreKit
@testable import PlomeCoreKitTestsHelpers
import XCTest

final class SimulationResultViewModelTests: XCTestCase {
    private var simulationsRouter: SimulationsRouter!
    private var simulationRepository: CoreDataRepository<CDSimulation>!
    private var mockCoreData: MockStorageProvider!

    override func setUp() {
        super.setUp()

        mockCoreData = MockStorageProvider()
        simulationRepository = CoreDataRepository(storageProvider: mockCoreData)

        simulationsRouter = SimulationsRouter(screens: .init(), rootTransition: EmptyTransition())
    }

    // MARK: - Save

    func testWhenAddingSimulationToCoreDataThenSimulationIsAdded() {
        // Arrange
        let simulation = TestSimulations.generalBACSimulation(targetedMention: .mediumFailure)
        let simulationResultViewModel = withDependencies {
            $0.coreDataSimulationRepository = simulationRepository
        } operation: {
            SimulationResultViewModel(router: simulationsRouter, simulation: simulation)
        }

        let cdSimulationsBeforeAddingNewSimulation = try! simulationRepository.list()

        // Act
        simulationResultViewModel.save()

        // Assert
        let cdSimulationsAfterAddingNewSimulation = try! simulationRepository.list()
        XCTAssertTrue((cdSimulationsBeforeAddingNewSimulation.count + 1) == cdSimulationsAfterAddingNewSimulation.count)
    }
}
