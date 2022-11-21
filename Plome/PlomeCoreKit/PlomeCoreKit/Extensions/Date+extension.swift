//
//  Date+extension.swift
//  PineappleCoreKit
//
//  Created by Loïc MAZUC on 20/07/2022.
//

import Foundation

public extension Date {
    enum DateFormat: String {
        /// Date format: 14/07/2022
        case classicSlash = "dd/MM/yyyy"
        /// Date format: 14-07-2022
        case classicUnionTrait = "dd-MM-yyyy"
        /// Date format: 14.07.2022
        case classicPoint = "dd.MM.yyyy"
        /// Date format: 14/07
        case classicDayMonth = "dd/MM"
    }

    func toString(format: DateFormat) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format.rawValue
        dateFormatter.locale = Locale(identifier: "FR-fr")

        return dateFormatter.string(from: self)
    }
}
