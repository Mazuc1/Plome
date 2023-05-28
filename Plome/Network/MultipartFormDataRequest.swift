//
//  MultipartFormDataRequest.swift
//  Gateway
//
//  Created by Loic Mazuc on 30/12/2022.
//

import Foundation
import PlomeCoreKit

enum HttpError: Swift.Error {
    case cantBuildURL
}

enum MIMEType {
    case json

    var value: String {
        switch self {
        case .json: return "application/json"
        }
    }
}

public struct MultipartFormDataRequest {
    private let boundary: String = UUID().uuidString
    private var httpBody = NSMutableData()
    let endPoint: EndPoint

    public init(endPoint: EndPoint) {
        self.endPoint = endPoint
    }

    public func build() throws -> URLRequest {
        guard let url = endPoint.buildURL() else {
            throw HttpError.cantBuildURL
        }

        addBodyField()

        var request = URLRequest(url: url)

        request.httpMethod = endPoint.method.rawValue
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")

        httpBody.appendString("--\(boundary)--")
        request.httpBody = httpBody as Data

        return request
    }

    private func addTextField(named name: String, value: String) {
        httpBody.appendString(textFormField(named: name, value: value))
    }

    private func textFormField(named name: String, value: String) -> String {
        var fieldString = "--\(boundary)\r\n"
        fieldString += "Content-Disposition: form-data; name=\"\(name)\"\r\n"
        fieldString += "Content-Type: text/plain; charset=ISO-8859-1\r\n"
        fieldString += "Content-Transfer-Encoding: 8bit\r\n"
        fieldString += "\r\n"
        fieldString += "\(value)\r\n"

        return fieldString
    }

    private func addDataField(named name: String, data: Data, mimeType: MIMEType) {
        httpBody.append(dataFormField(named: name, data: data, mimeType: mimeType))
    }

    private func dataFormField(named name: String, data: Data, mimeType: MIMEType) -> Data {
        let fieldData = NSMutableData()

        fieldData.appendString("--\(boundary)\r\n")
        fieldData.appendString("Content-Disposition: form-data; name=\"\(name)\"; filename=\"\(fileName())\"\r\n")
        fieldData.appendString("Content-Type: \(mimeType.value)\r\n")
        fieldData.appendString("\r\n")
        fieldData.append(data)
        fieldData.appendString("\r\n")

        return fieldData as Data
    }

    private func addBodyField() {
        guard let body = endPoint.body else { return }
        _ = body.map { key, value in
            if value is Data,
               let data = value as? Data
            {
                addDataField(named: key, data: data, mimeType: .json)
            } else {
                addTextField(named: key, value: "\(value)")
            }
        }
    }

    private func fileName() -> String {
        return String.random()
    }
}
