//
//  ShareSimulationModelServiceTests.swift
//  PlomeTests
//
//  Created by Loic Mazuc on 04/01/2023.
//

@testable import Plome
import PlomeCoreKit
import XCTest

final class ShareSimulationModelServiceTests: XCTestCase {
    private var shareSimulationModelService: ShareSimulationModelServiceProtocol!
    private var mockURLProtocol: MockURLProtocol!

    override func setUp() {
        super.setUp()
        let configuration = URLSessionConfiguration.ephemeral
        configuration.protocolClasses = [MockURLProtocol.self]
        shareSimulationModelService = ShareSimulationModelService(urlSession: URLSession(configuration: configuration))
    }

    func testWhenUploadSimulationModelThenSimulationModelUploadResponseIsReturned() async throws {
        // Arrange
        let simulation = Simulation(name: "", date: nil, exams: nil, type: .custom)

        let sampleData = SimulationModelUploadResponse(key: "key")
        let mockData = try! JSONEncoder().encode(sampleData)

        MockURLProtocol.requestHandler = { _ in
            (HTTPURLResponse(), mockData)
        }

        // Act
        let result = try await shareSimulationModelService.upload(simulationModel: simulation)

        // Assert
        XCTAssertEqual(result.key, "key")
    }

    func testWhenUploadSimulationModelAndResponseFailsToDecodeThenThrow() async throws {
        // Arrange
        let simulation = Simulation(name: "", date: nil, exams: nil, type: .custom)

        let mockData = "Error".data(using: .utf8)!

        MockURLProtocol.requestHandler = { _ in
            (HTTPURLResponse(), mockData)
        }

        // Assert
        await XCTAssertThrowsError(try await shareSimulationModelService.upload(simulationModel: simulation))
    }

    func testWhenDownloadSimulationModelThenSimulationModelIsReturned() async throws {
        // Arrange
        let sampleData = Simulation(name: "Model", date: nil, exams: nil, type: .custom)
        let mockData = try! JSONEncoder().encode(sampleData)

        MockURLProtocol.requestHandler = { _ in
            (HTTPURLResponse(), mockData)
        }

        // Act
        let result = try await shareSimulationModelService.download(with: "someKey")

        // Assert
        XCTAssertEqual(result.name, "Model")
    }

    func testWhenDownloadSimulationModelAndResponseFailsToDecodeThenThrow() async throws {
        // Arrange
        let mockData = "Error".data(using: .utf8)!

        MockURLProtocol.requestHandler = { _ in
            (HTTPURLResponse(), mockData)
        }

        // Assert
        await XCTAssertThrowsError(try await shareSimulationModelService.download(with: "someKey"))
    }
}
