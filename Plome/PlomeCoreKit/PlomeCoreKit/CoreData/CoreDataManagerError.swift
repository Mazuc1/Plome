//
//  CoreDataManagerError.swift
//  Reciplease
//
//  Created by Loic Mazuc on 28/06/2022.
//

import Foundation

enum CoreDataManagerError: Error {
    case objectNotFound
    case entityNameNotFound
    case failedToCast
}

extension CoreDataManagerError {
    var message: String {
        switch self {
        case .objectNotFound:
            return "Object not found"
            
        case .entityNameNotFound:
            return "Entity name not found"
            
        case .failedToCast:
            return "Cast failed"
        }
    }
}
