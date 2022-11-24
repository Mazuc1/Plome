//
//  SimulationListViewModelTests.swift
//  PlomeTests
//
//  Created by Loic Mazuc on 24/11/2022.
//

import Combine
@testable import Plome
@testable import PlomeCoreKit
import PlomeCoreKitTestsHelpers
import XCTest

final class SimulationListViewModelTests: XCTestCase {
    private var simulationsRouter: SimulationsRouter!
    private var simulationListViewModel: SimulationListViewModel!
    private var simulationRepository: CoreDataRepository<CDSimulation>!
    private var mockCoreData: MockCoreData!

    private var cancellables: Set<AnyCancellable> = []

    override func setUp() {
        super.setUp()

        mockCoreData = MockCoreData()
        simulationRepository = CoreDataRepository(storageProvider: mockCoreData)

        simulationsRouter = SimulationsRouter(screens: .init(context: testContext), rootTransition: EmptyTransition())
        simulationListViewModel = SimulationListViewModel(router: simulationsRouter, simulationRepository: simulationRepository)
    }

    // MARK: - updateSnapshot

    func testWhenUpdatingSnapshotWithDatabaseValuesThenSnapshotContainsOneSection() {
        // Arrange
        try! simulationRepository.add { simulation, context in
            simulation.name = "Test"
            simulation.date = Date()
            simulation.exams = .init()
            let exam = CDExam(context: context)
            exam.simulation = simulation
            exam.name = "TestExam"
            simulation.exams?.insert(exam)
        }

        // Act
        simulationListViewModel.updateSnapshot()

        simulationListViewModel.$snapshot
            .sink { snapshot in
                // Assert
                XCTAssertEqual(snapshot.numberOfSections, 1)
                XCTAssertEqual(snapshot.sectionIdentifiers[0], 0)
            }
            .store(in: &cancellables)
    }

    func testWhenUpdatingSnapshotWithDatabaseSimulationsDateNilThenSnapshotIsEmpty() {
        // Arrange
        try! simulationRepository.add { simulation, _ in
            simulation.name = "Test"
            simulation.date = nil
        }

        // Act
        simulationListViewModel.updateSnapshot()

        simulationListViewModel.$snapshot
            .sink { snapshot in
                // Assert
                XCTAssertEqual(snapshot.numberOfSections, 0)
            }
            .store(in: &cancellables)
    }

    // MARK: - userDidTapDeleteSimulation

    func testWhenDeleteSimulationThenSimulationIsDeleted() {
        // Arrange
        try! simulationRepository.add { simulation, _ in
            simulation.name = "Test"
            simulation.date = Date()
        }

        try! simulationRepository.add { simulation, _ in
            simulation.name = "Test2"
            simulation.date = Date()
        }

        // Act
        simulationListViewModel.updateSnapshot()
        simulationListViewModel.userDidTapDeleteSimulation(at: 0)
        simulationListViewModel.updateSnapshot()

        simulationListViewModel.$snapshot
            .sink { snapshot in
                // Assert
                XCTAssertEqual(snapshot.numberOfItems, 1)
            }
            .store(in: &cancellables)
    }
}
