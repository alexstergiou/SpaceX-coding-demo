//
//  MockDefaults.swift
//  SpaceXTests
//
//  Created by Alex Stergiou on 30/04/2021.
//

import Foundation

@testable import SpaceX

final class MockDefaults: DefaultsType {

    var valueType: DefaultsValueType?
    var values: [String: Data] = [:]
    var valueSetCalled: Bool = false
    subscript<T>(key: DefaultsKey<T>) -> T? where T : DefaultsValueType {
        get {
            return valueType as? T
        }
        set(newValue) {
            valueSetCalled = true
            if let data = newValue as? Data {
                values[key.key] = data
            }
            valueType = newValue
        }
    }

    var data: [String: Data] = [:]
    func data<T>(_ key: DefaultsKey<T>) -> Data? where T : DefaultsValueType {
        return data[key.key]
    }

    func hasKey<T>(_ key: DefaultsKey<T>) -> Bool where T : DefaultsValueType {
        return false
    }
}
