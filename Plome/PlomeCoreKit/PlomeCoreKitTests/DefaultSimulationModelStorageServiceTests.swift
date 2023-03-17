//
//  DefaultSimulationModelStorageServiceTests.swift
//  PlomeCoreKitTests
//
//  Created by Loic Mazuc on 02/12/2022.
//

@testable import PlomeCoreKit
@testable import PlomeCoreKitTestsHelpers
import XCTest
import Dependencies

final class DefaultSimulationModelStorageServiceTests: XCTestCase {
    private var userDefauls: DefaultsProtocol!
    private var defaultSimulationModelStorageService: DefaultSimulationModelStorageServiceProtocol!
    private var mockCoreData: MockStorageProvider!
    private var simulationRepository: CoreDataRepository<CDSimulation>!

    override func setUp() {
        super.setUp()
        mockCoreData = MockStorageProvider()
        simulationRepository = CoreDataRepository(storageProvider: mockCoreData)

        userDefauls = Defaults(userDefaults: .init(suiteName: "UserDefaultTests")!)
        
        defaultSimulationModelStorageService = withDependencies {
            $0.userDefault = userDefauls
            $0.defaultSimulationModelsProvider = .init()
            $0.coreDataSimulationRepository = simulationRepository
        } operation: {
            DefaultSimulationModelStorageService()
        }
    }

    func testWhenIsSimulationModelRegisterIsNotInUserDefaultThenDefaultSimulationModelsAreAdded() {
        // Arrange
        // To ensure of the non existance of the key
        userDefauls.removeData(key: .isSimulationModelRegister)

        // Act
        defaultSimulationModelStorageService.addDefaultSimulationModelIfNeeded()

        let cdSimulation = try! simulationRepository.list()

        // Assert
        XCTAssertEqual(userDefauls.getData(type: Bool.self, forKey: .isSimulationModelRegister)!, true)
        XCTAssertEqual(cdSimulation.count, 3)
    }

    func testWhenIsSimulationModelRegisterIsInUserDefaultThenNothingAppend() {
        // Arrange
        userDefauls.setData(value: true, key: .isSimulationModelRegister)

        // Act
        defaultSimulationModelStorageService.addDefaultSimulationModelIfNeeded()

        let cdSimulation = try! simulationRepository.list()

        // Assert
        XCTAssertEqual(cdSimulation.count, 0)
    }
}
