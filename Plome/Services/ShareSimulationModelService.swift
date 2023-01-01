//
//  ShareSimulationModelService.swift
//  Plome
//
//  Created by Loic Mazuc on 29/12/2022.
//

import Foundation
import Gateway
import PlomeCoreKit

protocol ShareSimulationModelServiceProtocol {
    func upload(simulationModel: Simulation) async throws -> SimulationModelUploadResponse
    func download(with key: String) async throws -> Simulation
}

final class ShareSimulationModelService: ShareSimulationModelServiceProtocol {
    //  MARK: - Properties

    enum ShareSimulationModelServiceError: Error {
        case cantBuildExpirationDate
        case cantBuildURL
    }

    private let urlSession: URLSession

    // MARK: - Init

    init(urlSession: URLSession = URLSession.shared) {
        self.urlSession = urlSession
    }

    // MARK: - Methods

    func upload(simulationModel: Simulation) async throws -> SimulationModelUploadResponse {
        let fileIOEndPoint = try createUploadEndpoint(with: simulationModel)
        let request = try MultipartFormDataRequest(endPoint: fileIOEndPoint.endPoint).build()

        let (data, _) = try await urlSession.data(for: request)

        return try JSONDecoder().decode(SimulationModelUploadResponse.self, from: data)
    }

    func download(with key: String) async throws -> Simulation {
        let fileIOEndPoint = FileIOEndPoint.download(key: key).endPoint
        guard let url = fileIOEndPoint.buildURL() else {
            throw ShareSimulationModelServiceError.cantBuildURL
        }

        let (data, _) = try await urlSession.data(from: url)

        return try JSONDecoder().decode(Simulation.self, from: data)
    }

    private func createUploadEndpoint(with simulation: Simulation) throws -> FileIOEndPoint {
        guard let expirationDate = Date.nowPlus(2, timeUnit: .hour) else {
            throw ShareSimulationModelServiceError.cantBuildExpirationDate
        }

        let jsonData = try JSONEncoder().encode(simulation)
        return FileIOEndPoint.upload(file: jsonData, expireAt: Date.ISOStringFromDate(date: expirationDate))
    }
}
