//
//  UserDefault.swift
//  PlomeCoreKit
//
//  Created by Mazuc Loïc on 20/01/2022.
//  Copyright © 2022 evaneos. All rights reserved.
//

import Foundation

public enum UserDefaultKeys: String, CaseIterable {
    case isSimulationModelRegister
    case hasOnboardingBeenSeen

    /// Key for test
    case userDefaultTest
}

public protocol DefaultsProtocol: AnyObject {
    func setData<T>(value: T, key: UserDefaultKeys)
    func getData<T>(type _: T.Type, forKey: UserDefaultKeys) -> T?
    func removeData(key: UserDefaultKeys)
}

public class Defaults: DefaultsProtocol {
    // MARK: - Properties

    private var userDefaults: UserDefaults

    // MARK: - Init

    public init(userDefaults: UserDefaults = UserDefaults.standard) {
        self.userDefaults = userDefaults
    }

    // MARK: - Methods

    public func setData<T>(value: T, key: UserDefaultKeys) {
        userDefaults.set(value, forKey: key.rawValue)
    }

    public func getData<T>(type _: T.Type, forKey: UserDefaultKeys) -> T? {
        let value = userDefaults.object(forKey: forKey.rawValue) as? T
        return value
    }

    public func removeData(key: UserDefaultKeys) {
        userDefaults.removeObject(forKey: key.rawValue)
    }
}
