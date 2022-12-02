//
//  SettingsViewModelTests.swift
//  PlomeTests
//
//  Created by Loic Mazuc on 02/12/2022.
//

@testable import Plome
@testable import PlomeCoreKit
@testable import PlomeCoreKitTestsHelpers
import XCTest

final class SettingsViewModelTests: XCTestCase {
    private var simulationsRouter: SimulationsRouter!
    private var simulationRepository: CoreDataRepository<CDSimulation>!
    private var mockCoreData: MockCoreData!
    private var settingsViewModel: SettingsViewModel!

    override func setUp() {
        super.setUp()

        mockCoreData = MockCoreData()
        simulationRepository = CoreDataRepository(storageProvider: mockCoreData)

        simulationsRouter = SimulationsRouter(screens: .init(context: testContext), rootTransition: EmptyTransition())
        settingsViewModel = SettingsViewModel(router: .init(screens: .init(context: testContext), rootTransition: EmptyTransition()), simulationRepository: simulationRepository, defaultSimulationModelsProvider: DefaultSimulationModelsProvider())
    }

    func testWhenDeleteSimulationsThenSimulationIsDeleted() {
        // Arrange
        try! simulationRepository.add { cdSimulation, _ in
            cdSimulation.name = "Test model"
        }
        try! simulationRepository.add { cdSimulation, _ in
            cdSimulation.name = "Test model"
            cdSimulation.date = Date()
        }

        // Act
        settingsViewModel.deleteSimulations()

        // Assert
        let result = try! simulationRepository.list()
        XCTAssertEqual(result.count, 1)
    }

    func testWhenDidTapAddDefaultSimulationModelsThenDefaultSimulationModelsAreAdded() {
        // Act
        settingsViewModel.userDidTapAddDefaultSimulationModel()

        // Assert
        let result = try! simulationRepository.list()
        XCTAssertEqual(result.count, 3)
    }
}
