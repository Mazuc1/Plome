//
//  FileIOEndPoint.swift
//  Gateway
//
//  Created by Loic Mazuc on 29/12/2022.
//

import Foundation

enum FileIOEndPoint {
    case upload(file: Data, expireAt: Date)
    case download(key: String)

    var endPoint: EndPoint {
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
