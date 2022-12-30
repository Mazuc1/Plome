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
    func upload(simulationModel: Simulation) async throws
}

final class ShareSimulationModelService: ShareSimulationModelServiceProtocol {
    //  MARK: - Properties

    enum ShareSimulationModelServiceError: Error {
        // case invalidURL
    }

    let urlSession: URLSession

    // MARK: - Init

    init(urlSession: URLSession = URLSession.shared) {
        self.urlSession = urlSession
    }

    // MARK: - Methods

    func upload(simulationModel _: Simulation) async throws {
        let dataTest = "Test".data(using: .utf8)!
        let modifiedDate = Calendar.current.date(byAdding: .hour, value: 5, to: Date())!

        let fileIOEndPoint = FileIOEndPoint.upload(file: dataTest, expireAt: Date.ISOStringFromDate(date: modifiedDate))
        let request = try MultipartFormDataRequest(endPoint: fileIOEndPoint.endPoint).build()

        let result = try await urlSession.data(for: request)

        // print("🐛", result.0, result.1)
        print(String(decoding: result.0, as: UTF8.self))
        // print(String(decoding: request.httpBody!, as: UTF8.self))
    }
}
