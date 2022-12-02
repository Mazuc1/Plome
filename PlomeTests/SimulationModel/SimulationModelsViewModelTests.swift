//
//  SimulationModelsViewModelTests.swift
//  PlomeTests
//
//  Created by Loic Mazuc on 28/10/2022.
//

import Combine
import CoreData
@testable import Plome
@testable import PlomeCoreKit
import XCTest

final class SimulationModelsViewModelTests: XCTestCase {
    private var simulationModelsRouter: SimulationModelsRouter!
    private var simulationModelsViewModel: SimulationModelsViewModel!
    private var simulationRepository: CoreDataRepository<CDSimulation>!
    private var mockCoreData: MockCoreData!
    private var cancellables: Set<AnyCancellable> = []

    override func setUp() {
        super.setUp()

        mockCoreData = MockCoreData()
        simulationRepository = CoreDataRepository(storageProvider: mockCoreData)

        simulationModelsRouter = SimulationModelsRouter(screens: .init(context: testContext), rootTransition: EmptyTransition())
        simulationModelsViewModel = SimulationModelsViewModel(router: simulationModelsRouter, simulationRepository: simulationRepository)
    }

    func testWhenUpdatingSnapshotWithEmptyDatabaseThenSnapshotContainsOnlyDefaultSection() {
        // Act
        simulationModelsViewModel.updateSnapshot()

        simulationModelsViewModel.$snapshot
            .sink { snapshot in
                // Assert
                XCTAssertEqual(snapshot.sectionIdentifiers.count, 1)
                XCTAssertEqual(snapshot.sectionIdentifiers[0], 0)
            }
            .store(in: &cancellables)
    }

    func testWhenUpdatingSnapshotWithDatabaseValuesThenSnapshotContainsTwoSection() {
        // Arrange
        try! simulationRepository.add { simulation, _ in
            simulation.name = "Test modèle"
        }

        // Act
        simulationModelsViewModel.updateSnapshot()

        simulationModelsViewModel.$snapshot
            .sink { snapshot in
                // Assert
                XCTAssertEqual(snapshot.sectionIdentifiers.count, 2)
                XCTAssertEqual(snapshot.sectionIdentifiers[0], 0)
                XCTAssertEqual(snapshot.sectionIdentifiers[1], 0)
            }
            .store(in: &cancellables)
    }

    func testWhenDeletingSimulationThenSimulationIsDeleted() {
        // Arrange
        var simulationID: NSManagedObjectID?

        try! simulationRepository.add { simulation, _ in
            simulation.name = "Test modèle"
            simulationID = simulation.objectID
        }

        simulationModelsViewModel.updateSnapshot()

        // Act
        simulationModelsViewModel.userDidTapDeleteSimulationModel(at: 0)
        simulationModelsViewModel.updateSnapshot()

        // Assert
        XCTAssertThrowsError(try simulationRepository.get(with: simulationID!))
    }
}
