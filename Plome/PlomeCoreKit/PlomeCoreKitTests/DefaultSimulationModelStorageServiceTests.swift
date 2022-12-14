//
//  DefaultSimulationModelStorageServiceTests.swift
//  PlomeCoreKitTests
//
//  Created by Loic Mazuc on 02/12/2022.
//

@testable import PlomeCoreKit
@testable import PlomeCoreKitTestsHelpers
import XCTest

final class DefaultSimulationModelStorageServiceTests: XCTestCase {
    private var userDefauls: DefaultsProtocol!
    private var defaultSimulationModelStorageService: DefaultSimulationModelStorageServiceProtocol!
    private var mockCoreData: MockCoreData!
    private var simulationRepository: CoreDataRepository<CDSimulation>!

    override func setUp() {
        super.setUp()
        mockCoreData = MockCoreData()
        simulationRepository = CoreDataRepository(storageProvider: mockCoreData)

        userDefauls = Defaults(userDefaults: .init(suiteName: "UserDefaultTests")!)
        defaultSimulationModelStorageService = DefaultSimulationModelStorageService(userDefault: userDefauls, simulationRepository: simulationRepository)
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
