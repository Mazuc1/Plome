//
//  PlomeCoreKitModule.swift
//  PlomeCoreKitModule
//
//  Created by Loic Mazuc on 02/12/2022.
//

import FirebaseCrashlytics
import Foundation

public final class PlomeCoreKitModule {
    public class func log(error: Error, comment _: String? = nil) {
        let crashlyticsError = NSError(domain: (error as NSError).domain, code: (error as NSError).code)
        Crashlytics.crashlytics().record(error: crashlyticsError)
    }
}
