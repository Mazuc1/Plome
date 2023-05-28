//
//  FileIOEndPoint.swift
//  Gateway
//
//  Created by Loic Mazuc on 29/12/2022.
//

import Foundation

public enum FileIOEndPoint {
    case upload(file: Data, expireAt: String)
    case download(key: String)

    public var endPoint: EndPoint {
        switch self {
        case let .upload(file, expireAt):
            return .init(method: .POST,
                         host: "file.io",
                         path: "/",
                         parameters: nil,
                         body: ["file": file, "expires": expireAt, "maxDownloads": 1, "autoDelete": true])
        case let .download(key):
            return .init(method: .GET,
                         host: "file.io",
                         path: "/\(key)",
                         parameters: nil,
                         body: nil)
        }
    }
}
