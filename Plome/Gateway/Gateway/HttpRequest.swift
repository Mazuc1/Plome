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

struct HttpRequest {
    typealias HTTPHeaders = [String: String]

    var endPoint: EndPoint
    var headers: HTTPHeaders?

    init(endPoint: EndPoint, headers: HTTPHeaders? = nil) {
        self.endPoint = endPoint
        self.headers = headers
    }

    func build() throws -> URLRequest {
        guard let url = endPoint.buildURL() else {
            throw HttpError.cantBuildURL
        }

        var request = URLRequest(url: url)

        _ = headers?.map { key, value in
            request.addValue(value, forHTTPHeaderField: key)
        }

        var bodyData: Data?
        if let body = endPoint.body {
            bodyData = try JSONSerialization.data(withJSONObject: body)
        }

        request.httpBody = bodyData

        return request
    }
}
