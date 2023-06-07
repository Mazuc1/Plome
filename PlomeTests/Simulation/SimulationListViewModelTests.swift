//
//  SimulationListViewModelTests.swift
//  PlomeTests
//
//  Created by Loic Mazuc on 24/11/2022.
//

import Combine
@testable import Plome
@testable import PlomeCoreKit
@testable import PlomeCoreKitTestsHelpers
import XCTest

final class SimulationListViewModelTests: XCTestCase {
    private var simulationsRouter: SimulationsRouter!
    private var simulationListViewModel: SimulationListViewModel!
    private var simulationRepository: CoreDataRepository<CDSimulation>!
    private var mockCoreData: MockStorageProvider!

    private var cancellables: Set<AnyCancellable> = []

    override func setUp() {
        super.setUp()

        mockCoreData = MockStorageProvider()
        simulationRepository = CoreDataRepository(storageProvider: mockCoreData)
        CoreKitContainer.shared.coreDataSimulationRepository.register { self.simulationRepository }

        simulationsRouter = SimulationsRouter(screens: .init(), rootTransition: EmptyTransition())

        simulationListViewModel = SimulationListViewModel(router: simulationsRouter)
    }

    // MARK: - updateSnapshot

    func testWhenUpdatingSnapshotWithNotDraftSimulationThenSnapshotContainedDefaultSection() {
        // Arrange
        addDefaultSimulation()

        // Act
        simulationListViewModel.updateSnapshot()

        simulationListViewModel.$snapshot
            .sink { snapshot in
                // Assert
                print(snapshot)
                XCTAssertEqual(snapshot.numberOfSections, 1)
                XCTAssertEqual(snapshot.sectionIdentifiers[0], SimulationSection.default)
            }
            .store(in: &cancellables)
    }
    
    func testWhenUpdatingSnapshotWithDraftSimulationThenSnapshotContainedDraftSection() {
        // Arrange
        addDraftSimulation()

        // Act
        simulationListViewModel.updateSnapshot()

        simulationListViewModel.$snapshot
            .sink { snapshot in
                // Assert
                XCTAssertEqual(snapshot.numberOfSections, 1)
                XCTAssertEqual(snapshot.sectionIdentifiers[0], SimulationSection.draft)
            }
            .store(in: &cancellables)
    }
    
    func testWhenUpdatingSnapshotWithDraftAndDefaultSimulationThenSnapshotContainedBothSection() {
        // Arrange
        addDraftSimulation()
        addDefaultSimulation()

        // Act
        simulationListViewModel.updateSnapshot()

        simulationListViewModel.$snapshot
            .sink { snapshot in
                // Assert
                print(snapshot)
                XCTAssertEqual(snapshot.numberOfSections, 2)
                XCTAssertEqual(snapshot.sectionIdentifiers[0], SimulationSection.default)
                XCTAssertEqual(snapshot.sectionIdentifiers[1], SimulationSection.draft)
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
        let date = Date()
        
        try! simulationRepository.add { simulation, _ in
            simulation.name = "Test"
            simulation.date = date
        }

        try! simulationRepository.add { simulation, _ in
            simulation.name = "Test2"
            simulation.date = Date()
        }

        // Act
        simulationListViewModel.updateSnapshot()
        simulationListViewModel.userDidTapDelete(simulationItem: .default(.init(name: "", date: date, exams: nil, type: .brevet)))
        simulationListViewModel.updateSnapshot()

        simulationListViewModel.$snapshot
            .sink { snapshot in
                // Assert
                XCTAssertEqual(snapshot.numberOfItems, 1)
            }
            .store(in: &cancellables)
    }
}

extension SimulationListViewModelTests {
    func addDefaultSimulation() {
        try! simulationRepository.add { simulation, context in
            simulation.name = "Test"
            simulation.date = Date()
            simulation.exams = .init()
            let exam = CDExam(context: context)
            exam.simulation = simulation
            exam.name = "TestExam"
            simulation.exams?.insert(exam)
        }
    }
    
    func addDraftSimulation() {
        try! simulationRepository.add { simulation, context in
            simulation.name = "Test"
            simulation.date = Date()
            simulation.exams = .init()
            let exam = CDExam(context: context)
            exam.simulation = simulation
            exam.name = "TestExam"
            exam.grade = -1
            simulation.exams?.insert(exam)
        }
    }
}
