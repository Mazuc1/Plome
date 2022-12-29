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
        dateFormatter.locale = Locale(identifier: L10n.General.locale)

        return dateFormatter.string(from: self)
    }
}
public extension Date {
    static func ISOStringFromDate(date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.timeZone = TimeZone(abbreviation: "GMT")
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS"
        
        return dateFormatter.string(from: date).appending("Z")
    }
}
