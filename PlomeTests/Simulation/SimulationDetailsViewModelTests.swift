//
//  SimulationDetailsViewModelTests.swift
//  PlomeTests
//
//  Created by Loic Mazuc on 28/11/2022.
//

@testable import Plome
@testable import PlomeCoreKit
@testable import PlomeCoreKitTestsHelpers
import XCTest

final class SimulationDetailsViewModelTests: XCTestCase {
    private var simulationsRouter: SimulationsRouter!
    private var simulationRepository: CoreDataRepository<CDSimulation>!
    private var mockCoreData: MockCoreData!

    override func setUp() {
        super.setUp()

        mockCoreData = MockCoreData()
        simulationRepository = CoreDataRepository(storageProvider: mockCoreData)

        simulationsRouter = SimulationsRouter(screens: .init(context: testContext), rootTransition: EmptyTransition())
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

        let viewModel = SimulationDetailsViewModel(router: simulationsRouter, simulation: simulation, cdSimulation: cdSimulationTest!, simulationRepository: simulationRepository)

        // Act
        viewModel.userDidTapDeleteSimulation()

        // Assert
        let cdSimulations = try! simulationRepository.list()
        XCTAssertTrue(cdSimulations.isEmpty)
    }
}
