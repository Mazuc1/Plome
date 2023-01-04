//
//  TestEndPoint.swift
//  GatewayTests
//
//  Created by Loic Mazuc on 02/01/2023.
//

import Foundation
@testable import Gateway

enum TestEndPoint {
    case test(someParameter: String)
    case dataTest

    var endPoint: EndPoint {
        switch self {
        case let .test(someParameter):
            return .init(method: .GET,
                         host: "google.com",
                         path: "/\(someParameter)",
                         parameters: nil,
                         body: ["bodyName": "bodyContent"])

        case .dataTest:
            return .init(method: .GET,
                         host: "google.com",
                         path: "/",
                         parameters: nil,
                         body: ["bodyName": Data("Data".utf8)])
        }
    }
}
