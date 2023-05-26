//
//  SelectSimulationModelViewModelTests.swift
//  PlomeTests
//
//  Created by Loic Mazuc on 23/11/2022.
//

import Combine
@testable import Plome
@testable import PlomeCoreKit
@testable import PlomeCoreKitTestsHelpers
import XCTest

final class SelectSimulationModelViewModelTests: XCTestCase {
    private var simulationsRouter: SimulationsRouter!
    private var selectSimulationModelViewModel: SelectSimulationModelViewModel!
    private var simulationRepository: CoreDataRepository<CDSimulation>!
    private var mockCoreData: MockStorageProvider!

    private var cancellables: Set<AnyCancellable> = []

    override func setUp() {
        super.setUp()
        mockCoreData = MockStorageProvider()
        simulationRepository = CoreDataRepository(storageProvider: mockCoreData)
        
        CoreKitContainer.shared.coreDataSimulationRepository.register { self.simulationRepository }
        
        simulationsRouter = SimulationsRouter(screens: .init(), rootTransition: EmptyTransition())
        selectSimulationModelViewModel = SelectSimulationModelViewModel(router: simulationsRouter)
    }

    // MARK: - updateSnapshot

    func testWhenUpdatingSnapshotWithDatabaseValuesThenSnapshotContainsOneSection() {
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
                XCTAssertEqual(snapshot.sectionIdentifiers.count, 1)
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
}
