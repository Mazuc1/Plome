//
//  EndPoint.swift
//  Reciplease
//
//  Created by Loic Mazuc on 02/07/2022.
//

import Foundation

enum HTTPMethod: String {
    case GET
    case POST
}

public struct EndPoint {
    typealias Parameters = KeyValuePairs<String, Any>?

    let method: HTTPMethod
    private let host: String
    private let path: String
    private let parameters: Parameters?
    let body: [String: Any]?

    init(method: HTTPMethod, host: String, path: String, parameters: Parameters?, body: [String: Any]?) {
        self.method = method
        self.host = host
        self.path = path
        self.parameters = parameters
        self.body = body
    }

    public func buildURL() -> URL? {
        var components = URLComponents()
        components.host = host
        components.scheme = "https"
        components.path = path
        components.queryItems = parameters?.map {
            $0.map { key, value in
                URLQueryItem(name: key, value: value as? String)
            }
        }
        return components.url
    }
}
