//
//  SimulationViewModelTests.swift
//  PlomeTests
//
//  Created by Loic Mazuc on 07/06/2023.
//

import Combine
@testable import Plome
@testable import PlomeCoreKit
@testable import PlomeCoreKitTestsHelpers
import XCTest

final class SimulationViewModelTests: XCTestCase {
    private var simulationsRouter: SimulationsRouter!
    private var simulationRepository: CoreDataRepository<CDSimulation>!
    private var mockCoreData: MockStorageProvider!

    private var cancellables: Set<AnyCancellable> = []

    override func setUp() {
        super.setUp()

        mockCoreData = MockStorageProvider()
        simulationRepository = CoreDataRepository(storageProvider: mockCoreData)
        CoreKitContainer.shared.coreDataSimulationRepository.register { self.simulationRepository }

        simulationsRouter = SimulationsRouter(screens: .init(), rootTransition: EmptyTransition())
    }

    func testThatSimulationIsSavedWhenAllConditionsAreMet() throws {
        // Arrange
        let simulation = Simulation(name: "", date: nil, exams: .init(), type: .brevet)
        _ = simulation.exams?.insert(.init(name: "", coefficient: 1, grade: 2, ratio: 20, type: .option))

        let viewModel = createViewModel(with: simulation)

        // Act
        viewModel.saveSimulationIfAllConditionsAreMet()

        // Assert
        let simulations = try simulationRepository.list()
        XCTAssertEqual(simulations.count, 1)
    }

    func testThatSimulationIsNotSavedWhenAllConditionsAreNotMet() throws {
        // Arrange
        let simulation = Simulation(name: "", date: nil, exams: .init(), type: .brevet)
        _ = simulation.exams?.insert(.init(name: "", coefficient: 1, grade: nil, ratio: 20, type: .option))

        let viewModel = createViewModel(with: simulation)

        // Act
        viewModel.saveSimulationIfAllConditionsAreMet()

        // Assert
        let simulations = try simulationRepository.list()
        XCTAssertEqual(simulations.count, 0)
    }

    func testThatDraftSimulationIsSavedWhateverConditions() throws {
        // Arrange
        let simulation = Simulation(name: "", date: nil, exams: .init(), type: .brevet)
        _ = simulation.exams?.insert(.init(name: "", coefficient: 1, grade: nil, ratio: 20, type: .option))

        let viewModel = createViewModel(with: simulation)

        // Act
        viewModel.saveSimulationToDraft()

        // Assert
        let simulations = try simulationRepository.list()
        XCTAssertEqual(simulations.count, 1)
    }
}

extension SimulationViewModelTests {
    func createViewModel(with simulation: Simulation) -> SimulationViewModel {
        SimulationViewModel(router: simulationsRouter,
                            simulation: simulation,
                            editing: nil)
    }
}
