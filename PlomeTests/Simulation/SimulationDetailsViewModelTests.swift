//
//  SimulationDetailsViewModelTests.swift
//  PlomeTests
//
//  Created by Loic Mazuc on 28/11/2022.
//

import Dependencies
@testable import Plome
@testable import PlomeCoreKit
@testable import PlomeCoreKitTestsHelpers
import XCTest

final class SimulationDetailsViewModelTests: XCTestCase {
    private var simulationsRouter: SimulationsRouter!
    private var simulationRepository: CoreDataRepository<CDSimulation>!
    private var mockCoreData: MockStorageProvider!

    override func setUp() {
        super.setUp()

        mockCoreData = MockStorageProvider()
        simulationRepository = CoreDataRepository(storageProvider: mockCoreData)

        simulationsRouter = SimulationsRouter(screens: .init(), rootTransition: EmptyTransition())
    }

    func testWhenDeleteSimulationThenSimulationIsDeleted() {
        // Arrange
        let simulation = Simulation(name: "", date: nil, exams: nil, type: .custom)
        var cdSimulationTest: CDSimulation?

        try! simulationRepository.add { cdSimulation, _ in
            cdSimulation.name = ""
            cdSimulation.type = .custom
            cdSimulationTest = cdSimulation
        }

        let viewModel = withDependencies {
            $0.coreDataSimulationRepository = simulationRepository
        } operation: {
            SimulationDetailsViewModel(router: simulationsRouter, simulation: simulation, cdSimulation: cdSimulationTest!)
        }

        // Act
        viewModel.userDidTapDeleteSimulation()

        // Assert
        let cdSimulations = try! simulationRepository.list()
        XCTAssertTrue(cdSimulations.isEmpty)
    }
}
