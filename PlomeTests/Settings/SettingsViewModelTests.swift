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
import Dependencies

final class SettingsViewModelTests: XCTestCase {
    private var simulationRepository: CoreDataRepository<CDSimulation>!
    private var mockCoreData: MockStorageProvider!
    private var settingsViewModel: SettingsViewModel!

    override func setUp() {
        super.setUp()

        mockCoreData = MockStorageProvider()
        simulationRepository = CoreDataRepository(storageProvider: mockCoreData)

        settingsViewModel = withDependencies {
            $0.coreDataSimulationRepository = simulationRepository
            $0.defaultSimulationModelsProvider = .init()
            $0.shareSimulationModelService = ShareSimulationModelService()
        } operation: {
            SettingsViewModel(router: .init(screens: .init(), rootTransition: EmptyTransition()))
        }
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
