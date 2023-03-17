//
//  Decodable+extension.swift
//  BaluchonTests
//
//  Created by Loic Mazuc on 03/06/2022.
//

import Foundation

extension Decodable {
    static func generateJsonFilename(for function: String, in file: String, sender: AnyObject) -> (fileName: String, bundle: Bundle) {
        let filename = file.components(separatedBy: ".").first!.components(separatedBy: "/").last! + "_" + function
        let bundle = Bundle(for: type(of: sender))
        return (filename, bundle)
    }

    static func createFromJson(for function: String = #function, in file: String = #file, sender: AnyObject) -> Self {
        let (filename, bundle) = Self.generateJsonFilename(for: function, in: file, sender: sender)

        guard let path = bundle.path(forResource: filename, ofType: "json") else {
            fatalError("Failed to find: \"\(filename).json\"")
        }

        let jsonData = try! Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)

        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601

        return try! decoder.decode(self, from: jsonData)
    }

    static func jsonData(for function: String = #function, in file: String = #file, sender: AnyObject) -> Data {
        let (filename, bundle) = Self.generateJsonFilename(for: function, in: file, sender: sender)

        guard let path = bundle.path(forResource: filename, ofType: "json") else {
            fatalError("Failed to find: \"\(filename).json\"")
        }

        let jsonData = try! Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)

        return jsonData
    }
}
