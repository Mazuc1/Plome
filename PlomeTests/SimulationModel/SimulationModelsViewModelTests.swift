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
@testable import PlomeCoreKitTestsHelpers
import XCTest
import Dependencies

final class SimulationModelsViewModelTests: XCTestCase {
    private var simulationModelsRouter: SimulationModelsRouter!
    private var simulationModelsViewModel: SimulationModelsViewModel!
    private var simulationRepository: CoreDataRepository<CDSimulation>!
    private var mockCoreData: MockStorageProvider!
    private var cancellables: Set<AnyCancellable> = []

    override func setUp() {
        super.setUp()

        mockCoreData = MockStorageProvider()
        simulationRepository = CoreDataRepository(storageProvider: mockCoreData)

        simulationModelsRouter = SimulationModelsRouter(screens: .init(), rootTransition: EmptyTransition())
        simulationModelsViewModel = withDependencies {
            $0.coreDataSimulationRepository = simulationRepository
            $0.shareSimulationModelService = ShareSimulationModelService()
        } operation: {
            SimulationModelsViewModel(router: simulationModelsRouter)
        }
    }

    func testWhenUpdatingSnapshotWithDatabaseValuesThenSnapshotContainsOneSection() {
        // Arrange
        try! simulationRepository.add { simulation, _ in
            simulation.name = "Test modèle"
        }

        // Act
        simulationModelsViewModel.updateSnapshot()

        simulationModelsViewModel.$snapshot
            .sink { snapshot in
                // Assert
                XCTAssertEqual(snapshot.sectionIdentifiers.count, 1)
            }
            .store(in: &cancellables)
    }

    @MainActor
    func testWhenDeletingSimulationThenSimulationIsDeleted() async {
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
        await XCTAssertThrowsError(try simulationRepository.get(with: simulationID!))
    }
}
