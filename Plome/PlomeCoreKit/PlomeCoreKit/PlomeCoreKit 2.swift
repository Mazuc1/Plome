//
//  PlomeCoreKit.swift
//  PlomeCoreKit
//
//  Created by Loic Mazuc on 02/12/2022.
//

import Foundation

public final class PlomeCoreKit {
    public class func log(error: Error, comment _: String? = nil) {
        let crashlyticsError = NSError(domain: (error as NSError).domain, code: (error as NSError).code)

        // Log to crashlytics
        // Crashlytics.crashlytics().record(error: crashlyticsError)
    }
}
