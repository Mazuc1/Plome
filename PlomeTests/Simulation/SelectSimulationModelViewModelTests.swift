//
//  SelectSimulationModelViewModelTests.swift
//  PlomeTests
//
//  Created by Loic Mazuc on 23/11/2022.
//

import Combine
@testable import Plome
@testable import PlomeCoreKit
import PlomeCoreKitTestsHelpers
import XCTest

final class SelectSimulationModelViewModelTests: XCTestCase {
    private var simulationsRouter: SimulationsRouter!
    private var selectSimulationModelViewModel: SelectSimulationModelViewModel!
    private var simulationRepository: CoreDataRepository<CDSimulation>!
    private var mockCoreData: MockCoreData!

    private var cancellables: Set<AnyCancellable> = []

    override func setUp() {
        super.setUp()

        mockCoreData = MockCoreData()
        simulationRepository = CoreDataRepository(storageProvider: mockCoreData)

        simulationsRouter = SimulationsRouter(screens: .init(context: testContext), rootTransition: EmptyTransition())
        selectSimulationModelViewModel = SelectSimulationModelViewModel(router: simulationsRouter, defaultSimulationModelsProvider: testContext.defaultSimulationModelsProvider, simulationRepository: simulationRepository)
    }

    // MARK: - updateSnapshot

    func testWhenUpdatingSnapshotWithEmptyDatabaseThenSnapshotContainsOnlyDefaultSection() {
        // Act
        selectSimulationModelViewModel.updateSnapshot()

        selectSimulationModelViewModel.$snapshot
            .sink { snapshot in
                // Assert
                XCTAssertEqual(snapshot.sectionIdentifiers.count, 1)
                XCTAssertEqual(snapshot.sectionIdentifiers[0], .default)
            }
            .store(in: &cancellables)
    }

    func testWhenUpdatingSnapshotWithDatabaseValuesThenSnapshotContainsTwoSection() {
        // Arrange
        try! simulationRepository.add { simulation, context in
            simulation.name = "Test"
            simulation.exams = .init()
            let exam = CDExam(context: context)
            exam.simulation = simulation
            exam.name = "TestExam"
            simulation.exams?.insert(exam)
        }

        // Act
        selectSimulationModelViewModel.updateSnapshot()

        selectSimulationModelViewModel.$snapshot
            .sink { snapshot in
                // Assert
                XCTAssertEqual(snapshot.sectionIdentifiers.count, 2)
                XCTAssertEqual(snapshot.sectionIdentifiers[0], .default)
                XCTAssertEqual(snapshot.sectionIdentifiers[1], .coreData)
            }
            .store(in: &cancellables)
    }

    // MARK: - getSimulation

    func testWhenGetCoreDataSimulationThenCoreDataSimulationIsReturned() {
        // Arrange
        try! simulationRepository.add { simulation, _ in
            simulation.name = "Test model"
        }

        selectSimulationModelViewModel.updateSnapshot()

        // Act
        let simulation = selectSimulationModelViewModel.getSimulation(indexPath: .init(row: 0, section: 1))

        // Assert
        XCTAssertEqual(simulation!.name, "Test model")
    }

    func testWhenGetDefaultSimulationThenDefaultSimulationIsReturned() {
        // Arrange
        selectSimulationModelViewModel.updateSnapshot()

        // Act
        let simulation = selectSimulationModelViewModel.getSimulation(indexPath: .init(row: 2, section: 0))

        // Assert
        XCTAssertEqual(simulation!.name, "BAC Technologique")
    }

    func testWhenGetSimulationWithBadIndexPathSectionThenNilIsReturned() {
        // Arrange
        selectSimulationModelViewModel.updateSnapshot()

        // Act
        let simulation = selectSimulationModelViewModel.getSimulation(indexPath: .init(row: 0, section: 3))

        // Assert
        XCTAssertNil(simulation)
    }
}
