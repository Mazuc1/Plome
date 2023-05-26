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
    private var userDefaults: DefaultsProtocol!
    private var defaultSimulationModelStorageService: DefaultSimulationModelStorageServiceProtocol!
    private var mockCoreData: MockStorageProvider!
    private var simulationRepository: CoreDataRepository<CDSimulation>!

    override func setUp() {
        super.setUp()
        mockCoreData = MockStorageProvider()
        simulationRepository = CoreDataRepository(storageProvider: mockCoreData)
        userDefaults = Defaults(userDefaults: .init(suiteName: "UserDefaultTests")!)
        
        CoreKitContainer.shared.coreDataSimulationRepository.register { self.simulationRepository }
        CoreKitContainer.shared.userDefault.register { self.userDefaults }

        defaultSimulationModelStorageService = DefaultSimulationModelStorageService()
    }

    func testWhenIsSimulationModelRegisterIsNotInUserDefaultThenDefaultSimulationModelsAreAdded() {
        // Arrange
        // To ensure of the non existance of the key
        userDefaults.removeData(key: .isSimulationModelRegister)

        // Act
        defaultSimulationModelStorageService.addDefaultSimulationModelIfNeeded()

        let cdSimulation = try! simulationRepository.list()

        // Assert
        XCTAssertEqual(userDefaults.getData(type: Bool.self, forKey: .isSimulationModelRegister)!, true)
        XCTAssertEqual(cdSimulation.count, 3)
    }

    func testWhenIsSimulationModelRegisterIsInUserDefaultThenNothingAppend() {
        // Arrange
        userDefaults.setData(value: true, key: .isSimulationModelRegister)

        // Act
        defaultSimulationModelStorageService.addDefaultSimulationModelIfNeeded()

        let cdSimulation = try! simulationRepository.list()

        // Assert
        XCTAssertEqual(cdSimulation.count, 0)
    }
}
