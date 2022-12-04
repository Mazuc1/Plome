//
//  PlomeCoreKit.swift
//  PlomeCoreKit
//
//  Created by Loic Mazuc on 02/12/2022.
//

import Foundation
import FirebaseCrashlytics

public final class PlomeCoreKit {
    public class func log(error: Error, comment _: String? = nil) {
        let crashlyticsError = NSError(domain: (error as NSError).domain, code: (error as NSError).code)
        Crashlytics.crashlytics().record(error: crashlyticsError)
    }
}
