//
//  HttpRequest.swift
//  Gateway
//
//  Created by Loic Mazuc on 29/12/2022.
//

import Foundation

enum HttpError: Swift.Error {
    case cantBuildURL
}

public struct HttpRequest {
    public typealias HTTPHeaders = [String: String]

    var endPoint: EndPoint
    var headers: HTTPHeaders?

    public init(endPoint: EndPoint, headers: HTTPHeaders? = nil) {
        self.endPoint = endPoint
        self.headers = headers
    }

    public func build() throws -> URLRequest {
        guard let url = endPoint.buildURL() else {
            throw HttpError.cantBuildURL
        }

        var request = URLRequest(url: url)
        request.httpMethod = endPoint.method.rawValue

        _ = headers?.map { key, value in
            request.addValue(value, forHTTPHeaderField: key)
        }

        return request
    }
}
